# DAG steps

# Step 01: Run checks for latest data in dependencies
# Step 02: Create daily step up table and load into staging - biteam.stg_step_up_b2c_zuora_daily
# Step 03: Run checks on data quality of step 02, if pass then continue, if false then stop
# Step 04: Insert data from stg into actual table biteam.step_up_b2c_zuora_daily
# Step 05: Pass data from actual table to s3 bucket to be picked up by membership/seslav
# Step 06: Truncate staging tables

from datetime import datetime

from workflow.lib.airflow.custom.dag.model.ft_dag import FTDAG
from workflow.lib.airflow.custom.dag.service.dag_arguments_builder import DAGArgumentsBuilder
from workflow.lib.airflow.custom.storage.storage_path import StoragePath
from workflow.lib.airflow.custom.utils.sql.sql_file_reader import SqlFileReader
from workflow.lib.airflow.hooks.common.file.delimiter_file_hook.file_delimiter import FileDelimiter
from workflow.lib.airflow.operators.aws.redshift.redshift_to_s3.v1_0_1.redshift_to_s3_operator import \
    RedshiftToS3Operator
from workflow.lib.airflow.operators.aws.s3.s3_to_bigquery.v1_0_0.s3_to_bigquery_operator import S3ToBigQueryOperator
from workflow.lib.airflow.operators.google.bigquery.bigquery.v1_0_0.big_query_operator import BigQueryOperator
from workflow.lib.airflow.operators.aws.redshift.redshift.v1_0_0.redshift_operator import RedshiftOperator
from workflow.lib.airflow.operators.sql.sql_sensor_operator.v1_0_0.sql_sensor_operator import SqlSensorOperator
from workflow.lib.airflow.custom.utils.sql.sql_database_type import DatabaseType
from workflow.lib.airflow.operators.aws.s3.s3_to_bigquery.v1_0_0.models.write_disposition import WriteDisposition

default_args = DAGArgumentsBuilder.build(
    start_date=datetime(2020, 1, 1, 0, 0, 0),
    retries=0
)

with FTDAG(dag_id='rs_to_s3_step_up_b2c_zuora_daily',
           max_active_runs=1,
           schedule_interval='0 9 * * *',
           tags=['step_up'],
           default_args=default_args,
           catchup=False) as dag:

    sql_file_reader = SqlFileReader(script_path=__file__)
    # Create dictionary with files
    sql_files = {"t01": "sql/t01_check_dependencies.sql.j2",
                 "t02": "sql/t02_create_daily_step_up_table.sql.j2",
                 "t03": "sql/t03_step_up_stg_table_quality_checks.sql",
                 "t04": "sql/t04_load_data_from_stg_into_table.sql.j2",
                 "t05": "sql/t05_rs_to_s3.sql.j2",
                 "t06": "sql/t06_truncate_table.sql.j2"
                 }

    # Step 01: Run checks for latest data in dependencies
    sql_t01 = sql_file_reader.render_query_from_template(sql_files["t01"])

    t01_check_dependencies = SqlSensorOperator(
        task_id="t01_check_dependencies",
        db_conn_id=dag.team_params.aws.connections.redshift.main.default,
        db_type=DatabaseType.REDSHIFT,
        sql_query=sql_t01,
        expected_result=[(1,)],
        poke_interval=120,  # 2 minutes
        timeout=180  # mark failed after 3 minutes
    )

    # Step 02: Create daily step up table and load into staging - biteam.stg_step_up_b2c_zuora_daily
    sql_t02 = sql_file_reader.render_query_from_template(sql_files["t02"])

    t02_rs_load_data_into_staging = RedshiftOperator(
        task_id="t02_rs_load_data_into_staging",
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        sql=sql_t02

    )

    # Step 03: Run checks on data quality of step 02, if pass then continue, if false then stop
    sql_t03 = sql_file_reader.render_query_from_template(sql_files["t03"])

    t03_check_stg_table_data_quality = SqlSensorOperator(
        task_id="t03_check_stg_table_data_quality",
        db_conn_id=dag.team_params.aws.connections.redshift.main.default,
        db_type=DatabaseType.REDSHIFT,
        sql_query=sql_t03,
        expected_result=[(1,)],
        poke_interval=120,  # 2 minutes
        timeout=180  # mark failed after 3 minutes
    )

    # Step 04: Insert data from stg into actual table biteam.step_up_b2c_zuora_daily
    sql_t04 = sql_file_reader.render_query_from_template(sql_files["t04"])

    t04_rs_load_data_from_staging_into_tbl = RedshiftOperator(
        task_id="t04_rs_load_data_from_staging_into_tbl",
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        sql=sql_t04

    )
    # Step 05: Pass data from actual table to s3 bucket to be picked up by membership/seslav
    # TODO replace with details given by seslav
    sql_t05 = sql_file_reader.render_query_from_template(sql_files["t05"])

    t05_unload_step_up_daily_to_s3 = RedshiftToS3Operator(
        task_id="unload_step_up_daily_to_s3",
        sql_query=sql_t05,
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        unload_options="delimiter '|' allowoverwrite parallel off addquotes"
    )

    # Step 06: Truncate staging tables
    sql_t06 = sql_file_reader.render_query_from_template(sql_files["t06"])

    t06_truncate_stg = RedshiftOperator(
        task_id="t06_truncate_stg",
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        sql=sql_t06

    )

    # TODO add step to transfer data into bigquery

    # Order Tasks
    t01_check_dependencies >> \
    t02_rs_load_data_into_staging >> \
    t03_check_stg_table_data_quality >> \
    t04_rs_load_data_from_staging_into_tbl >> \
    t05_unload_step_up_daily_to_s3 >> \
    t06_truncate_stg
