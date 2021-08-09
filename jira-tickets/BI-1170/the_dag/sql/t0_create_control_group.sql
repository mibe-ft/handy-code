-- Step 2: Create table for subs in control group
DROP TABLE IF EXISTS #control_group;
CREATE TABLE #control_group AS (
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
	, days_until_anniversary
	, 1 AS is_control
FROM
    (
        SELECT   t.*
            , PERCENT_RANK() OVER (PARTITION BY product_name_adjusted, product_term_adjusted, print_or_digital, days_until_anniversary ORDER BY RANDOM()) AS pr
        FROM biteam.vw_step_up_b2c_zuora t
        WHERE days_until_anniversary = 30
          AND is_eligible_for_step_up = 1
    ) AS a
WHERE pr <= 0.25
)
;