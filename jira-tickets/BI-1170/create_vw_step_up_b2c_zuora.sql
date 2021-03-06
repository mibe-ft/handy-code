DROP VIEW IF EXISTS biteam.vw_step_up_b2c_zuora;

CREATE OR REPLACE VIEW biteam.vw_step_up_b2c_zuora AS

WITH user_facts AS (
-- get b2c subs status for each day
	SELECT
		  ft_user_id
		, user_dkey
		, userstatus_dtm
		, userstatus_date_dkey
		, is_standardplus

	FROM
		dwabstraction.fact_userstatus fu
	WHERE
	 		userstatus_date_dkey = REPLACE(CURRENT_DATE -1,'-','')::INTEGER
		AND is_b2c = True
		AND user_dkey IN (SELECT user_dkey FROM dwabstraction.dn_arrangement_all WHERE to_datasource_dkey = 2) -- zuora users only
)
, b2c_subscriptions AS (
-- get additional info on b2c subs
-- row_number() identifies the latest arrangement event per day, per user, per arrangement
-- this is to make sure we grab the most recent arrangement details for each day if there are multiple changes in a day

	SELECT * FROM (
		SELECT
			   ft_user_id
			 , user_dkey
			 , b2c_marketing_region
			 , arrangementevent_dtm
			 , arrangement_id_dd
			 , to_arrangementtype_name
			 , to_arrangementlength_id
			 , to_arrangementproduct_name
			 , to_arrangementproduct_type
			 , to_arrangementstatus_name
			 , to_arrangementstatus_dkey
			 , to_arrangementproduct_code
			 , to_priceinctax
			 , to_pricegbpinctax
			 , start_dtm
			 , to_termstart_dtm
			 , to_end_dtm
			 , anniversary_date
			 , to_renewal_dtm
			 , to_cancelrequest_dtm
			 , to_cancel_dtm
			 , to_termstartdate_dkey
			 , to_enddate_dkey
			 , to_currency_code
			 , to_currency_name
			 , to_offer_name
			 , to_offer_id
			 , to_offer_price
			 , to_offer_type
			 , to_offer_rrp
			 , to_offer_percent_rrp
			 , to_cancelreason_dkey
			 , email
			 , to_offer_main_product_name
			 , to_offer_main_product_code
			 , title
			 , first_name
			 , last_name
			 , country_code
			 , campaigns_region
			 , industry_name
			 , ROW_NUMBER () OVER(PARTITION BY ft_user_id, arrangement_id_dd ORDER BY arrangementevent_dtm DESC) AS row_num
		FROM
			dwabstraction.dn_arrangementevent_all daa
		WHERE
				to_arrangementtype_dkey 	= 5 -- B2C Subscription
			AND to_datasource_dkey 			= 2 -- Zuora
			AND to_arrangementstatus_dkey 	IN (1,3) -- 1: Active 3:Cancelled
			)
		WHERE row_num = 1 -- filter out duplicate arrangement events in same day
)
, final_tbl AS (
-- output for final table
	SELECT * FROM (
		SELECT
			  bsu.ft_user_id
			, uf.user_dkey
			, uf.userstatus_date_dkey
			, uf.userstatus_dtm								AS date_
			, uf.is_standardplus
			, bsu.arrangementevent_dtm
			, bsu.start_dtm
			, bsu.to_termstart_dtm
			, bsu.to_end_dtm
			, bsu.anniversary_date
			, bsu.to_renewal_dtm
			, bsu.to_cancelrequest_dtm
			, bsu.to_cancel_dtm
			, bsu.arrangement_id_dd
			, bsu.to_arrangementtype_name -- e.g. b2c subscription
			, bsu.to_arrangementlength_id 					AS product_term-- length of arrangement
			, CASE WHEN rpt.rollup_product_term  = '1 year' THEN 'annual'
				   WHEN rpt.rollup_product_term  = '1 month / 4 weeks' THEN 'monthly'
				   WHEN rpt.rollup_product_term  = '3 months' THEN 'quarterly'
				   ELSE bsu.to_arrangementlength_id END AS product_term_adjusted
			, bsu.to_arrangementproduct_name 				AS product_name -- e.g. Premium FT.com
			, CASE --WHEN bsu.to_arrangementproduct_name = 'Standard FT.com' AND uf.is_standardplus = 1 THEN 'standard plus' -- TODO Uncomment when logic is supplied from Yuliya
				   WHEN bsu.to_arrangementproduct_name = 'Standard FT.com' THEN 'standard'
	   			   WHEN bsu.to_arrangementproduct_name = 'Premium FT.com' THEN 'premium'
	   			   WHEN bsu.to_arrangementproduct_name = 'e-Paper' THEN 'e-paper'
	   			   WHEN bsu.to_arrangementproduct_name = 'Newspaper - 5 weekdays' THEN 'print - monday - friday'
	   			   WHEN bsu.to_arrangementproduct_name = 'Newspaper - 6 Days a week' THEN 'print - monday - saturday'
	   			   WHEN bsu.to_arrangementproduct_name = 'Newspaper - Weekend Only' THEN 'print - weekend'
	   			   WHEN bsu.to_arrangementproduct_name = 'Premium FT.com with Newspaper - 5 weekdays' THEN 'bundle premium - monday - friday'
	   			   WHEN bsu.to_arrangementproduct_name = 'Premium FT.com with Newspaper - 6 Days a week' THEN 'bundle premium - monday - saturday'
	   			   WHEN bsu.to_arrangementproduct_name = 'Premium FT.com with Newspaper - Weekend Only' THEN 'bundle premium - weekend'
	   			   WHEN bsu.to_arrangementproduct_name = 'Standard FT.com with Newspaper - 6 Days a week' THEN 'bundle standard - monday to saturday'
	   			   WHEN bsu.to_arrangementproduct_name = 'Standard FT.com with Newspaper - Weekend Only' THEN 'bundle standard - weekend'
	   			   ELSE bsu.to_arrangementproduct_name END AS product_name_adjusted
			, bsu.to_arrangementproduct_type 				AS print_or_digital -- print or digital or bundle
			, bsu.to_arrangementstatus_name 				AS status_name-- e.g. Active, Cancelled, Pending, Payment Failure
			, bsu.to_arrangementstatus_dkey					AS status_key
			, bsu.to_arrangementproduct_code				AS product_code
			, bsu.to_priceinctax
			, bsu.to_pricegbpinctax
			, bsu.to_offer_name
			, bsu.to_offer_price
			, bsu.to_offer_id
			, COALESCE(to_offer_rrp, 9999)					AS rrp_price
			, bsu.to_offer_type
			, bsu.to_offer_rrp
			, bsu.to_offer_percent_rrp
			, 100-COALESCE(to_offer_percent_rrp, 9999)		AS current_discount
			, bsu.to_currency_code							AS currency_code
			, bsu.to_currency_name							AS currency_name
			, bsu.b2c_marketing_region						AS marketing_region
			, bsu.email                                     AS email_address
			, bsu.to_offer_main_product_name                AS subs_product
			, bsu.to_offer_main_product_code                AS product
			, bsu.title
			, bsu.first_name                                AS firstname
			, bsu.last_name                                 AS surname
			, bsu.country_code                              AS current_country_name
			, bsu.campaigns_region                          AS campaign_region
			, bsu.industry_name			                    AS industry
			, ROW_NUMBER () OVER(PARTITION BY uf.ft_user_id, bsu.arrangement_id_dd ORDER BY bsu.arrangementevent_dtm DESC) AS row_num

		FROM user_facts uf
		LEFT JOIN  b2c_subscriptions bsu ON uf.user_dkey = bsu.user_dkey
			  AND (uf.userstatus_date_dkey >= bsu.to_termstartdate_dkey)
			  AND (uf.userstatus_date_dkey <= bsu.to_enddate_dkey)
		LEFT JOIN bilayer.rollup_product_term rpt ON bsu.to_arrangementlength_id::CHARACTER VARYING = rpt.arrangementlength_id::CHARACTER VARYING
		)
    WHERE row_num = 1
)
, final_tbl_2 AS (

    SELECT
          f.ft_user_id
        , f.arrangement_id_dd AS arrangement_id
        , f.date_
        , INITCAP(TO_CHAR(date_, 'month')) AS step_up_month
        , LOWER(f.print_or_digital) AS print_or_digital
        , f.to_priceinctax AS current_price
        , f.to_offer_name AS current_offer
        , f.to_offer_id AS current_offer_id
        , f.marketing_region
        , f.currency_code
        , f.product_name
        , f.product_name_adjusted
        , f.product_term_adjusted
        , CASE WHEN m.offer_id IS NOT NULL THEN m.new_price
        	   WHEN m.offer_id IS NULL AND (current_offer LIKE '%RRP%' OR current_offer LIKE '%Full Price%')
        				 			   AND (m.new_price >= current_price) THEN m.new_price
        	   ELSE current_price
        	   END AS step_up_price
        , COALESCE(m.offer_id, current_offer_id) AS step_up_offer_id
        , CASE WHEN ABS(REPLACE(m.percent_discount, '%','')::NUMERIC(8,2)) IS NULL THEN 0
               ELSE ABS(REPLACE(m.percent_discount, '%','')::NUMERIC(8,2))
               END AS step_up_percent_discount
        , CASE WHEN f.is_standardplus = TRUE THEN 1
        	   WHEN f.is_standardplus = FALSE THEN 0 END AS is_standard_plus
        , CASE WHEN f.status_key = 3 THEN 1 ELSE 0 END AS is_cancelled
        , CASE WHEN (f.to_cancelrequest_dtm IS NOT NULL OR f.to_cancel_dtm IS NOT NULL) THEN 1 ELSE 0 END AS has_cancel_request
        , CASE WHEN current_price = step_up_price THEN 1 ELSE 0 END AS is_renewal
        , CASE WHEN current_price = step_up_price OR is_cancelled = 1 OR has_cancel_request = 1 THEN 0 ELSE 1 END AS is_eligible_for_step_up
        , CASE WHEN DATEDIFF(DAYS, CURRENT_DATE, DATEADD(YEAR, ABS(DATEDIFF(YEAR, CURRENT_DATE, f.anniversary_date)), f.anniversary_date)-1) < 0
        			THEN DATEDIFF(DAYS, CURRENT_DATE, DATEADD(YEAR, ABS(DATEDIFF(YEAR, CURRENT_DATE, f.anniversary_date))+1, f.anniversary_date)-1)
        	   WHEN DATEDIFF(DAYS, CURRENT_DATE, DATEADD(YEAR, ABS(DATEDIFF(YEAR, CURRENT_DATE, f.anniversary_date)), f.anniversary_date)-1) > 366
        	        THEN
        	        	CASE WHEN DATEDIFF(DAYS, CURRENT_DATE, CAST(EXTRACT(YEAR FROM CURRENT_DATE )||'-'||EXTRACT(MONTH FROM f.anniversary_date)||'-'||EXTRACT(DAY FROM f.anniversary_date) AS TIMESTAMP)-1) <= 0
        	        			THEN DATEDIFF(DAYS, CURRENT_DATE, CAST(EXTRACT(YEAR FROM CURRENT_DATE )+1||'-'||EXTRACT(MONTH FROM f.anniversary_date)||'-'||EXTRACT(DAY FROM f.anniversary_date) AS TIMESTAMP)-1)
        	        			ELSE DATEDIFF(DAYS, CURRENT_DATE, CAST(EXTRACT(YEAR FROM CURRENT_DATE )||'-'||EXTRACT(MONTH FROM f.anniversary_date)||'-'||EXTRACT(DAY FROM f.anniversary_date) AS TIMESTAMP)-1) END
        	   ELSE DATEDIFF(DAYS, CURRENT_DATE, DATEADD(YEAR, ABS(DATEDIFF(YEAR, CURRENT_DATE, f.anniversary_date)), f.anniversary_date)-1)
        	   END AS days_until_anniversary
        , f.email_address
		, f.subs_product
		, f.product
		, f.title
		, f.firstname
		, f.surname
		, f.current_country_name
		, f.campaign_region
		, f.industry
		, f.product_term_adjusted AS subs_term
    FROM final_tbl f
    LEFT JOIN biteam.step_up_matrix m ON f.product_name_adjusted::CHARACTER VARYING = m.product_name::CHARACTER VARYING
    AND f.product_term_adjusted::CHARACTER VARYING = m.product_term::CHARACTER VARYING
    AND f.currency_code::CHARACTER VARYING = m.currency::CHARACTER VARYING
    AND (f.to_priceinctax::FLOAT >= m.lower_band::FLOAT)
    AND (f.to_priceinctax::FLOAT <= m.higher_band::FLOAT)
    AND (f.date_::DATE >= m.valid_from)
    AND (f.date_::DATE <= m.valid_to)
)

SELECT *
FROM final_tbl_2
WHERE product_name_adjusted IN ('standard' , 'premium', 'e-paper', 'print - monday - friday'
                                , 'print - monday - saturday', 'print - weekend', 'premium bundle'
                                , 'bundle premium - monday - friday', 'bundle premium - monday - saturday'
                                , 'bundle premium - weekend', 'bundle standard - monday to saturday', 'bundle standard - weekend') -- standard plus to be added at later date
;
