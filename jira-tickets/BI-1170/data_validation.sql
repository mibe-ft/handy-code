-- to check individual users
SELECT
arrangementevent_dtm
, to_termstart_dtm
, to_end_dtm
, to_renewal_dtm
, arrangementevent_name
, to_arrangementtype_name
, to_arrangementlength_id
, to_arrangementproduct_name
, to_arrangementproduct_type -- print or digital or bundle
, to_offer_price
, to_priceinctax
--*
FROM dwabstraction.dn_arrangementevent_all
WHERE user_dkey = 389
ORDER BY arrangementevent_dtm

----
-- one line per ft-user per arrangement id per day
SELECT ft_user_guid
, arrangement_id_dd
, date_
, COUNT(DISTINCT date_) count_of_date
FROM dataset
GROUP BY 1,2,3
HAVING count_of_date > 1
-- limit 1 -- if 1st row > 1 then fail check

-- 001702c0-afb6-4c64-9779-94cd106d4884 - has two entries for 23-04-2021
-- checking for null values in specific 'important columns'

--todo create count of unique users and unique arrangements
select count(distinct ft_user_id) count_users, count(distinct arrangement_id_dd) count_arrangements
from final_tbl
-- 209,529 users, 210,255 - 20210423
-- 208,340 users, 209,059 - 20210505

-- check final data set has no dupes
SELECT 
arrangement_id_dd
, count(arrangement_id_dd)
FROM final_tbl
group by 1 
having count(arrangement_id_dd) > 1

-- 277219 in active status 20210506, includes all
SELECT count(distinct user_dkey)
FROM dwabstraction.dn_arrangement_all
WHERE to_datasource_dkey = 2
AND to_arrangementstatus_dkey 	IN (1)

-- 269,206 in active status 20210506
SELECT count(distinct user_dkey)
FROM dwabstraction.dn_arrangement_all daa
WHERE to_datasource_dkey = 2
AND to_arrangementstatus_dkey 	IN (1)
and to_arrangementproduct_type IN ('Print', 'Digital')


SELECT *
FROM final_tbl_2
WHERE --product_name_adjusted = 'standard'
 ft_user_id = '870c359b-0aca-4753-a08b-ddfde17bb1e4'

-- check dupes by arrangement
select arrangement_id
, count(arrangement_id)
from final_tbl_2
WHERE product_name_adjusted = 'standard'
group by 1
having count(arrangement_id)>1

-- check dupes by user_id
select ft_user_id
, count(ft_user_id)
from final_tbl_2
group by 1
having count(ft_user_id)>1

-- check nulls specifically for standard
SELECT *
FROM final_tbl_2
WHERE step_up_price IS NULL
and product_name_adjusted = 'standard'
;

-- check 25%
select renewal_step_up
, count(renewal_step_up)
from
(SELECT
	d.*
	, s.email_id
	, s.send_comms
FROM dataset_2 AS d
LEFT JOIN #step_up_comms_logic AS s ON d.print_or_digital = s.print_or_digital
AND d.product_term_adjusted = s.term
AND d.renewal_step_up = s.renewal_step_up
AND d.is_control = s.is_control
--where d.is_control = 1
)
group by 1
;

/*-- list of checks to write--------------------------------------------------------------------------
* this must be performed after all transformations are done but BEFORE data is transferred to AWS S3 bucket
* cols: success, assert_name, records
	staging checks before move to actual table
-- 1: days_until_anniversary 0 and 366 xx
-- 2: CHECK DUPES by arrangement - should be no more 1 count per arrangement id xx
-- 3: control is 25% of total xx
-- 4: 25% control for each combination of segments xx
-- 5: check control group does not overlap with non controls
-- 6: cannot be is_cancelled and eligible for step up
-- 7: cannot be is_renewal and eligible for step up
-- 8: cannot be has cancel request and eligible for step up

pre start dag checks
-- check yesterdays/todays date, as its supposed to be daily
-- create step in airflow for dependency on freshest data

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
		  MIN(check_) = 1 AS success
		, 'check 04: 25% control for each combination of segments' AS assert
	FROM (
	SELECT
		  date_
		, product_name_adjusted
		, product_term_adjusted
		, print_or_digital
		, days_until_anniversary
		, SUM(CASE WHEN is_control = TRUE THEN 1 END ) AS controls
		, SUM(CASE WHEN is_control = FALSE THEN 1 END ) AS non_controls
		, controls + non_controls AS total
		, ROUND(100.00 * controls/total) AS controls_percent
		, CASE WHEN controls_percent IN (25,26) OR (controls_percent IS NULL AND controls IS NULL AND non_controls IS NULL) THEN 1 ELSE 0 END AS check_
	FROM
		biteam.stg_step_up_b2c_zuora_daily
	GROUP BY
			  date_
			, product_name_adjusted
			, product_term_adjusted
			, print_or_digital
			, days_until_anniversary
			)
), check_05 AS (
	SELECT
		  COUNT(overlap) = 0 AS success
		, 'check 05: control group does not overlap with non controls per day' AS assert
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

), check_06 AS (
	SELECT
		  check_ = 0 AS success
		, 'check 06: cannot be is_cancelled and is_eligible_for_step_up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN is_cancelled IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)
), check_07 AS (

	SELECT
	  	  check_ = 0 AS success
		, 'check 07: cannot be is_renewal and eligible for step up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN is_renewal IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)

), check_08 AS (
--
	SELECT
	  	  check_ = 0 AS success
		, 'check 08: cannot be has cancel request and eligible for step up' AS assert
	FROM
	(SELECT COUNT(CASE WHEN has_cancel_request IS TRUE AND is_eligible_for_step_up IS TRUE THEN 0 END) AS check_
	FROM biteam.stg_step_up_b2c_zuora_daily)

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

	UNION

	SELECT * FROM check_08
	--union all
	--select false as success
	--, 'dummy' as assert


	ORDER BY assert
)

SELECT * FROM all_checks

-- for final query that can be used in airflow, if all checks are complete it should expected result should be 1
--SELECT MIN(success::INTEGER)
--FROM all_checks
;