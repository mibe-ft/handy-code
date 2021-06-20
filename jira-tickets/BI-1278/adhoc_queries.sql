INSERT INTO bilayer.job_date_config (job_name, table_name, load_status, first_date_to_process, last_date_to_process) VALUES
('rs_to_bq_bilayer_rfv_weekly', 'bilayer.rfv_weekly', 'complete', '2021-05-30', '2021-05-30');
SELECT * FROM bilayer.job_date_config where table_name = 'bilayer.rfv_weekly';

UPDATE bilayer.job_date_config
SET load_status = 'complete', record_modified_date = GETDATE()
WHERE job_name = 'rs_to_bq_bilayer_rfv_weekly';

-- check there is data
select count(1) from bilayer.rfv_weekly rw ;

-- create staging table
DROP TABLE IF EXISTS bilayer.rfv_weekly_stg;
            CREATE TABLE bilayer.rfv_weekly_stg as (
            SELECT * FROM bilayer.rfv_weekly
            WHERE rfv_date >= (SELECT cast(first_date_to_process as date) FROM bilayer.job_date_config WHERE table_name = 'bilayer.rfv_weekly')
            AND rfv_date <= (SELECT cast(last_date_to_process as date) FROM bilayer.job_date_config WHERE table_name = 'bilayer.rfv_weekly')
            );

-- check there is data in staging
select * from bilayer.rfv_weekly_stg;