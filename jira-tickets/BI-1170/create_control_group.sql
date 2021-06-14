-- query to create the temp table for controls
DROP TABLE IF EXISTS #temp_step_up_b2c_zuora_control_group;
CREATE TABLE #temp_step_up_b2c_zuora_control_group AS (
SELECT
	  ft_user_id
	, arrangement_id
	, date_
	, print_or_digital
	, current_price
	, current_offer
	, current_offer_id
	, region
	, currency_code
	, product_name
	, product_name_adjusted
	, product_term_adjusted
	, step_up_price
	, step_up_offer_id
	, step_up_percent_discount
	, is_standard_plus
	, is_cancelled
	, has_cancel_request
	, is_renewal
	, is_eligible_for_step_up
	, days_until_end_of_term
	, 1 AS is_control
FROM
(
 	SELECT   t.*
  		, PERCENT_RANK() OVER (PARTITION BY product_name_adjusted, product_term_adjusted, print_or_digital ORDER BY RANDOM()) AS pr
	FROM biteam.vw_step_up_b2c_zuora t
	WHERE days_until_end_of_term >= 28
	AND days_until_end_of_term <= 30
	AND is_eligible_for_step_up = 1
) AS dt
WHERE pr <= 0.25
)
;

-- combine controls and non controls
-- TODO add in email template logic for controls
SELECT *
	, 0 AS is_control
FROM biteam.vw_step_up_b2c_zuora vsubcz
WHERE ft_user_id NOT IN (SELECT ft_user_id FROM #control_group)

UNION ALL

SELECT *
FROM #control_group