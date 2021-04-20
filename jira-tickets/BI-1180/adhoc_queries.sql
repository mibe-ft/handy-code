--
SELECT  MIN(current_max_stage_timestamp), MAX(current_max_stage_timestamp)
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add` LIMIT 1000

-- get column names

SELECT column_name
FROM ft-bi-team.BI_layer_tables.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'funnels_b2b_nnb_add'