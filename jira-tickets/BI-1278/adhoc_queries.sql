INSERT INTO bilayer.job_date_config (job_name, table_name, load_status, first_date_to_process, last_date_to_process) VALUES
('rs_to_bq_bilayer_rfv_weekly', 'bilayer.rfv_weekly', 'complete', '2021-05-30', '2021-05-30');
SELECT * FROM bilayer.job_date_config;