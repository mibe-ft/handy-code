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

with FTDAG(dag_id='rs_to_bq_bilayer_rfv_weekly_mibe',
           max_active_runs=1,
           schedule_interval='0 3 * * MON',
           tags=['bilayer', 'rs_to_bq', 'rfv_weekly'],
           default_args=default_args,
           catchup=False) as dag:

    sql_file_reader = SqlFileReader(script_path=__file__)
    # create dictionary with files
    sql_files = {"t01": "sql/t01_previous_runs_check.sql.j2",
                 "t02": "sql/t02_rs_set_job_in_progress.sql.j2",
                 "t03": "sql/t03_select_rfv_weekly_records.sql.j2",
                 "t04": "sql/t04_rs_select_rfv_weekly.sql.j2",
                 "t06": "sql/t06_bq_merge_rfv_weekly.sql.j2",
                 "t07": "sql/t07_rs_set_job_to_complete.sql.j2"}
    # Step 1. RS: Check that the previous run completed successfully

    sql_t01 = sql_file_reader.render_query_from_template(sql_files["t01"])

    check_previous_run_completed = SqlSensorOperator(
        task_id="check_previous_run_completed",
        db_conn_id=dag.team_params.aws.connections.redshift.main.default,
        db_type=DatabaseType.REDSHIFT,
        sql_query=sql_t01,
        expected_result=[(1,)],
        poke_interval=120,  # 2 minutes
        timeout=600  # mark failed after 10 minutes
    )

    sql_t02 = sql_file_reader.render_query_from_template(sql_files["t02"])
    # Step 2. RS: Set the job to in_progress.
    rs_set_job_in_progress = RedshiftOperator(
        task_id="rs_set_job_in_progress",
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        sql=sql_t02

    )
    # Step 3. RS: Select records to be loaded.
    sql_t03 = sql_file_reader.render_query_from_template(sql_files["t03"])
    select_rfv_weekly_records = RedshiftOperator(
        task_id='select_rfv_weekly_records',
        sql=sql_t03,
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default
    )

    # Step 4.  Unload the records from the visits table to S3
    sql_t04 = sql_file_reader.render_query_from_template(sql_files["t04"])

    unload_rfv_weekly_to_s3 = RedshiftToS3Operator(
        task_id="unload_rfv_weekly_to_s3",
        sql_query=sql_t04,
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default,
        unload_options="delimiter '|' allowoverwrite parallel off addquotes"
    )

    # Step 5. Load table from S3 to Big Query (BI_Layer_integration)
    load_s3_rfv_weekly_to_bq = S3ToBigQueryOperator(
        task_id="load_s3_rfv_weekly_to_bq",
        s3_input=StoragePath(task_id="unload_rfv_weekly_to_s3"),
        big_query_conn_id=dag.team_params.google.connections.main.default,
        aws_conn_id=dag.team_params.aws.connections.iam.main.default,
        project=dag.team_params.google.projects.ft_bi_team.default,
        dataset=dag.team_params.google.projects.datasets.bi_layer_integration.default,
        table="rfv_weekly_stg",
        skip_leading_rows=0,
        field_delimiter=FileDelimiter.PIPE.value,
        unload_options="delimiter '|' allowoverwrite parallel off addquotes",
        write_disposition=WriteDisposition.WRITE_TRUNCATE.value
    )

    # Step 6.  Merge rfv_weekly staging into the main table
    bq_rfv_weekly = f'{dag.team_params.google.projects.ft_bi_team.default}'\
                    f'.{dag.team_params.google.projects.datasets.bi_layer_integration.default}'\
                    f'.rfv_weekly'
    bq_rfv_weekly_stg = f'{dag.team_params.google.projects.ft_bi_team.default}'\
                        f'.{dag.team_params.google.projects.datasets.bi_layer_integration.default}'\
                        f'.rfv_weekly_stg'
    sql_t06 = sql_file_reader.render_query_from_template(
        template_file=sql_files["t06"],
        params={'rfv_weekly_del':
                      bq_rfv_weekly,
                  'rfv_weekly_stg_0':
                      bq_rfv_weekly_stg,
                  'rfv_weekly_stg_1':
                      bq_rfv_weekly_stg,
                  'rfv_weekly_ins':
                      bq_rfv_weekly,
                  'rfv_weekly_stg_2':
                      bq_rfv_weekly_stg
                }
    )

    bq_merge_rfv_weekly_records = BigQueryOperator(
        task_id='bq_merge_rfv_weekly_records',
        use_legacy_sql=False,
        sql=sql_t06,
        bigquery_conn_id=dag.team_params.google.connections.main.default
    )

    # Step 7. Set the job to complete
    sql_t07 = sql_file_reader.render_query_from_template(sql_files["t07"])
    rs_set_job_complete = RedshiftOperator(
        task_id="rs_set_job_complete",
        sql=sql_t07,
        redshift_conn_id=dag.team_params.aws.connections.redshift.main.default
    )

    # Order Tasks
    check_previous_run_completed >> \
    rs_set_job_in_progress >> \
    select_rfv_weekly_records >> \
    unload_rfv_weekly_to_s3 >> \
    load_s3_rfv_weekly_to_bq >> \
    bq_merge_rfv_weekly_records >> \
    rs_set_job_complete
