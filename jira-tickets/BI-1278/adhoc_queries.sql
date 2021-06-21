INSERT INTO bilayer.job_date_config (job_name, table_name, load_status, first_date_to_process, last_date_to_process) VALUES
('rs_to_bq_bilayer_rfv_weekly', 'bilayer.rfv_weekly', 'complete', '2021-05-30', '2021-05-30');
SELECT * FROM bilayer.job_date_config where table_name = 'bilayer.rfv_weekly';

UPDATE bilayer.job_date_config
SET first_date_to_process = '2021-05-30' , last_date_to_process = '2021-05-30'
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


-- workings for date
SELECT cast(first_date_to_process as date) FROM bilayer.job_date_config WHERE table_name = 'bilayer.rfv_weekly';

select max(rfv_date) from bilayer.rfv_weekly rw ;
select cast(max(rfv_date)+1 as date) from bilayer.rfv_weekly rw ;
select cast('2021-06-21' as date) d1, cast(d1-7 as date), cast(d1-1 as date);

-- grant priviledges
grant all privileges on bilayer.rfv_weekly_stg to airflow_biteam;

SELECT 'GO' FROM bilayer.job_date_config
                  WHERE job_name = 'rs_to_bq_bilayer_rfv_weekly'
                  AND load_status = 'complete'
;

SELECT GETDATE(),DATE_TRUNC('d',getdate()) ;

-- create check for previous dag run and rfv_weekly has been completed
SELECT (COUNT(CASE WHEN check_ = 'GO' THEN 1 END) = 2)::INTEGER
FROM (
SELECT 1 AS check_ FROM bilayer.job_date_config
WHERE job_name = 'rs_to_bq_bilayer_rfv_weekly'
AND load_status = 'complete'

UNION ALL

SELECT DISTINCT 1 AS check_
FROM biteam.rfv_weekly
WHERE TRUNC(insert_dtm) = DATE_TRUNC('d',getdate())
)
;

select distinct 'GO' from biteam.rfv_weekly where insert_dtm = date_trunc('d',getdate());
select insert_dtm from biteam.rfv_weekly;


select distinct 'GO' from biteam.rfv_weekly where TRUNC(insert_dtm) = trunc(getdate());
select * from biteam.rfv_weekly where insert_dtm is not null LIMIT 10;

insert into biteam.rfv_weekly(insert_dtm) values
(getdate());


-- bigquery
select min(visit_date), max(visit_date) from `ft-bi-team.BI_Layer.visits`;
SELECT min(rfv_date), max(rfv_date)  FROM `ft-bi-team.Sandbox_bilayer_integration.rfv_weekly`; --WHERE DATE(_PARTITIONTIME) = "2021-06-20" LIMIT 1000
SELECT * FROM `ft-bi-team.Sandbox_bilayer_integration.rfv_weekly`;