WITH check_01 AS (
	SELECT
		  MAX(userstatus_date_dkey) = REPLACE(CURRENT_DATE, '-', '')::INTEGER AS success
		, 'check 01: todays data for dwabstraction.fact_userstatus - VIEW' AS assert
	FROM dwabstraction.fact_userstatus

), check_02 AS (
	SELECT
		   REPLACE(DATE(MAX(dw_updated_date)), '-', '')::INTEGER = REPLACE(CURRENT_DATE, '-', '')::INTEGER AS success
		 , 'check 02: todays data for dwabstraction.dn_arrangementevent_all - TABLE' AS assert
	FROM dwabstraction.dn_arrangementevent_all

), all_checks AS (
	SELECT * FROM check_01

	UNION ALL

	SELECT * FROM check_02

	ORDER BY assert
)

-- SELECT * FROM all_checks -- Uncomment if you want to know which checks have failed/completed
-- If all checks are complete,  the expected result should be 1 -- this is to be used with the SqlSensorOperator()
SELECT MIN(success::INTEGER)
FROM all_checks