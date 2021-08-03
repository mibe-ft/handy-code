/*-- list of checks to write--------------------------------------------------------------------------
* this must be performed after all transformations are done but BEFORE data is transferred to AWS S3 bucket
* cols: success, assert_name, records
	staging checks before move to actual table
-- 1: days_until_anniversary 0 and 366 xx
-- 2: CHECK DUPES by arrangement - should be no more 1 count per arrangement id xx
-- 3: control is 25% of total xx
-- 4: check control group does not overlap with non controls
-- 5: cannot be is_cancelled and eligible for step up
-- 6: cannot be is_renewal and eligible for step up
-- 7: cannot be has cancel request and eligible for step up
-- 8: step up price does not contain any nulls

post dag
-- check query for two files match for consistency -- same ft_ids, same number of ft_ids

*/ --------------------------------------------------------------------------------------------------

WITH check_01 AS (
	SELECT
		  SUM(CASE WHEN days_until_anniversary >= 0 AND days_until_anniversary <= 366 THEN 1 ELSE 0 END) = COUNT(1) AS success
		, 'check 01: days_until_anniversary field is between 0 and 366' AS assert
	FROM
		biteam.stg_step_up_b2c_zuora_daily

), check_02 AS (
	SELECT
		  count_ = 1 AS success
		, 'check 02: no duplicates in data by arrangement per day' AS assert
	FROM
	(	SELECT
			  date_
			, arrangement_id
			, COUNT(arrangement_id) count_
		FROM
			biteam.stg_step_up_b2c_zuora_daily
		GROUP BY
				 1,2
		ORDER BY
				 count_ DESC
		LIMIT 1
		)

), check_03 AS (
	SELECT
		  MIN(check_::INTEGER) = 1 AS success
		, 'check 03: control is 25% of total per day' AS assert
	FROM (
			SELECT
				  date_
				, ROUND(100.0 * SUM(CASE WHEN is_control IS TRUE THEN 1 END)/SUM(CASE WHEN is_eligible_for_step_up IS TRUE THEN 1 END))IN (25,26) AS check_
			FROM
				biteam.stg_step_up_b2c_zuora_daily
			GROUP BY 1
			ORDER BY check_ DESC
			)
), check_04 AS (
	SELECT
		  COUNT(overlap) = 0 AS success
		, 'check 04: control group does not overlap with non controls per day' AS assert
	FROM
		(SELECT
			  date_
			   ,COUNT(ft_user_id) AS overlap
		FROM
			biteam.stg_step_up_b2c_zuora_daily a
		WHERE is_control IS TRUE
		AND EXISTS (SELECT
						ft_user_id AS overlap
					FROM
						biteam.stg_step_up_b2c_zuora_daily b
					WHERE   is_control IS FALSE
						AND a.ft_user_id = b.ft_user_id
						AND a.date_ = b.date_)
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1)

), check_05 AS (
	SELECT
		  check_ = 0 AS success
		, 'check 05: cannot be is_cancelled and is_eligible_for_step_up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN is_cancelled IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)
), check_06 AS (

	SELECT
	  	  check_ = 0 AS success
		, 'check 06: cannot be is_renewal and eligible for step up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN is_renewal IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)

), check_07 AS (

	SELECT
	  	  check_ = 0 AS success
		, 'check 07: cannot be has cancel request and eligible for step up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN has_cancel_request IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)

), check_08 AS (
	SELECT
		  SUM(CASE WHEN step_up_price IS NULL THEN 1 ELSE 0 END) = 0 AS success
		, 'check 08: step up price does not contain any nulls'
	FROM biteam.stg_step_up_b2c_zuora_daily ssubczd

), all_checks AS (
	SELECT * FROM check_01

	UNION ALL

	SELECT * FROM check_02

	UNION ALL

	SELECT * FROM check_03

	UNION ALL

	SELECT * FROM check_04

	UNION ALL

	SELECT * FROM check_05

	UNION ALL

	SELECT * FROM check_06

	UNION ALL

	SELECT * FROM check_07

	UNION ALL

	SELECT * FROM check_08

	ORDER BY assert
)

-- SELECT * FROM all_checks -- Uncomment if you want to know which checks have failed/completed

-- If all checks are complete,  the expected result should be 1 -- this is to be used with the SqlSensorOperator()
SELECT MIN(success::INTEGER)
FROM all_checks
;