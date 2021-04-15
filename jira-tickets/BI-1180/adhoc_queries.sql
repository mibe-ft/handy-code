--
SELECT  MIN(current_max_stage_timestamp), MAX(current_max_stage_timestamp)
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add` LIMIT 1000