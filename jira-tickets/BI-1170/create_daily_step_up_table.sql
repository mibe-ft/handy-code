-- Step 1: Create table for comms logic
DROP TABLE IF EXISTS #step_up_comms_logic;
CREATE TABLE #step_up_comms_logic(
	print_or_digital VARCHAR,
	term VARCHAR,
	auto_renewal_single_term VARCHAR,
	renewal_step_up VARCHAR,
	is_control INTEGER,
	email_id INTEGER,
	send_comms INTEGER
)
;
INSERT INTO #step_up_comms_logic VALUES
	('digital','monthly','ar','renewal',NULL,2,0),
	('digital','annual','ar','renewal',NULL,2,1),
	('digital','monthly','ar','step up',0,1,1),
	('digital','monthly','ar','step up - control',1,2,0),
	('digital','annual','ar','step up',0,1,1),
	('digital','annual','ar','step up - control',1,2,1),
	('print','all','ar','renewal',NULL,4,1),
	('print','all','st','renewal',NULL,4,1),
	('print','all','ar','step up',NULL,3,1),
	('print','all','st','step up',NULL,3,1)
	;

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

-- Step 3:
    -- Combine controls with those to be stepped up
    -- Join comms logic
    -- Output is list of renewals, step ups and controls with email/comms logic
WITH step_01 AS (
    SELECT
    	  *
        , CASE WHEN is_eligible_for_step_up = 1 THEN 0 ELSE NULL END AS is_control
    FROM biteam.vw_step_up_b2c_zuora vsubcz
    WHERE NOT EXISTS (SELECT ft_user_id FROM #control_group c WHERE vsubcz.ft_user_id = c.ft_user_id)
        AND days_until_anniversary = 30

    UNION ALL

    SELECT *
    FROM #control_group

), step_02 AS (
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
		, is_control
		, CASE WHEN is_control = 0 AND is_eligible_for_step_up = 1 THEN 'step up'
			   WHEN is_control = 1 AND is_eligible_for_step_up = 1 THEN 'step up - control'
			   WHEN is_control IS NULL AND is_renewal = 1 AND is_eligible_for_step_up = 0 THEN 'renewal'
			   WHEN is_cancelled OR has_cancel_request THEN 'cancelled or cancel request'
			   END AS renewal_step_up
	FROM step_01
), step_03 AS (

	SELECT
		d.*
		, CASE WHEN s.email_id IS NULL THEN -9999 ELSE s.email_id END AS email_id
		, CASE WHEN s.email_id = 1 THEN 'Digital - Step Up In Price'
			   WHEN s.email_id = 2 THEN 'Digital - Renewal - No Price Change'
			   WHEN s.email_id = 3 THEN 'Print - Step Up In Price'
			   WHEN s.email_id = 4 THEN 'Print - Renewal - No Price Change'
			   ELSE 'Not Applicable'
			   END AS email_type_description
		, s.send_comms
	FROM step_02 AS d
	LEFT JOIN #step_up_comms_logic AS s ON d.print_or_digital = s.print_or_digital
										AND d.product_term_adjusted = s.term
										AND d.renewal_step_up = s.renewal_step_up
									 	AND d.is_control = s.is_control
)

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
	, CASE WHEN is_standard_plus = 1 THEN TRUE
		   WHEN is_standard_plus = 0 THEN FALSE
		   ELSE NULL END AS is_standard_plus
	, CASE WHEN is_cancelled = 1 THEN TRUE
		   WHEN is_cancelled = 0 THEN FALSE
		   ELSE NULL END AS is_cancelled
	, CASE WHEN has_cancel_request = 1 THEN TRUE
		   WHEN has_cancel_request = 0 THEN FALSE
		   ELSE NULL END AS has_cancel_request
	, CASE WHEN is_renewal = 1 THEN TRUE
		   WHEN is_renewal = 0 THEN FALSE
		   ELSE NULL END AS is_renewal
	, CASE WHEN is_eligible_for_step_up = 1 THEN TRUE
		   WHEN is_eligible_for_step_up = 0 THEN FALSE
		   ELSE NULL END AS is_eligible_for_step_up
	, days_until_anniversary
	, CASE WHEN is_control = 1 THEN TRUE
		   WHEN is_control = 0 THEN FALSE
		   ELSE NULL END AS is_control
	, renewal_step_up
	, email_id
	, email_type_description
	, CASE WHEN send_comms = 1 THEN TRUE
		   WHEN send_comms = 0 THEN FALSE
		   ELSE NULL END AS send_comms
FROM step_03
;
