DROP TABLE IF EXISTS #stepup_matrix;
CREATE TABLE #stepup_matrix (
    currency VARCHAR,
    lower_band FLOAT,
    higher_band FLOAT,
    new_price FLOAT,
    percent_discount VARCHAR,
    code INT,
    offer_id VARCHAR,
    subs_term VARCHAR,
    subs_product VARCHAR
);

INSERT INTO #stepup_matrix VALUES
{%- for curr, lb, hb, np, pc_disc, code, offer_id, term, product in stepup_matrix %}
    ('{{curr}}', {{lb}}, {{hb}}, {{np}}, '{{pc_disc}}', {{code}}, '{{offer_id}}', '{{term}}', '{{product}}')
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;

WITH user_facts AS (
-- get b2c subs status for each day
	SELECT
		  ft_user_id
		, user_dkey
		, userstatus_dtm
		, userstatus_date_dkey

	FROM
		dwabstraction.fact_userstatus fu
	WHERE
	 		userstatus_date_dkey = 20210505 -- TODO question: how far back should we go
		AND is_b2c = True
		AND user_dkey IN (SELECT user_dkey FROM dwabstraction.dn_arrangement_all WHERE to_datasource_dkey = 2)-- make sure zuora only
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
			 , to_arrangementproduct_code
			 , to_priceinctax
			 , to_pricegbpinctax
			 , start_dtm
			 , to_termstart_dtm
			 , to_end_dtm
			 , to_renewal_dtm
			 , to_cancelrequest_dtm
			 , to_cancel_dtm
			 , to_termstartdate_dkey
			 , to_enddate_dkey
			 , to_currency_code
			 , to_currency_name
			 , to_offer_name
			 , to_offer_price
			 , to_offer_type
			 , to_offer_rrp
			 , to_offer_percent_rrp
			 , to_cancelreason_dkey
			 , ROW_NUMBER () OVER(PARTITION BY ft_user_id, arrangement_id_dd, DATE(arrangementevent_dtm) ORDER BY event_seq_no DESC, arrangementevent_dtm DESC) AS row_num
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
			  uf.ft_user_id
			, uf.user_dkey
			, uf.userstatus_date_dkey
			, uf.userstatus_dtm								AS date_
			, bsu.arrangementevent_dtm
			, bsu.start_dtm
			, bsu.to_termstart_dtm
			, bsu.to_end_dtm
			, bsu.to_renewal_dtm
			, bsu.to_cancelrequest_dtm
			, bsu.to_cancel_dtm
			, bsu.arrangement_id_dd
			, bsu.to_arrangementtype_name -- e.g. b2c subscription
			, bsu.to_arrangementlength_id 					AS product_term-- length of arrangement
			, CASE WHEN bsu.to_arrangementlength_id  = '12M' THEN 'annual'
				   WHEN bsu.to_arrangementlength_id  = '1M' THEN 'monthly'
				   ELSE bsu.to_arrangementlength_id END AS product_term_adjusted
			, bsu.to_arrangementproduct_name 				AS product_name -- e.g. Premium FT.com
			, CASE WHEN bsu.to_arrangementproduct_name = 'Standard FT.com' THEN 'standard'
	   			   WHEN bsu.to_arrangementproduct_name = 'Premium FT.com' THEN 'premium'
	   			   ELSE bsu.to_arrangementproduct_name END AS product_name_adjusted
			, bsu.to_arrangementproduct_type 				AS print_or_digital -- print or digital or bundle
			, bsu.to_arrangementstatus_name 				AS status_name-- e.g. Active, Cancelled, Pending, Payment Failure
			, bsu.to_arrangementproduct_code				AS product_code
			, bsu.to_priceinctax
			, bsu.to_pricegbpinctax
			, bsu.to_offer_name
			, bsu.to_offer_price
			, COALESCE(to_offer_rrp, 9999)					AS rrp_price -- todo sometimes null
			, bsu.to_offer_type
			, bsu.to_offer_rrp
			, bsu.to_offer_percent_rrp
			, 100-COALESCE(to_offer_percent_rrp, 9999)		AS current_discount
			, bsu.to_currency_code							AS currency_code
			, bsu.to_currency_name							AS currency_name
			, bsu.b2c_marketing_region						AS region
			, ROW_NUMBER () OVER(PARTITION BY uf.ft_user_id, bsu.arrangement_id_dd ORDER BY bsu.arrangementevent_dtm DESC) AS row_num

		FROM user_facts uf
		LEFT JOIN b2c_subscriptions bsu ON uf.user_dkey = bsu.user_dkey
			  AND (uf.userstatus_date_dkey >= bsu.to_termstartdate_dkey)
			  AND (uf.userstatus_date_dkey <= bsu.to_enddate_dkey)
		WHERE
			bsu.to_arrangementproduct_type IN ('Print', 'Digital')
		)
	WHERE row_num = 1
)
--TODO remove row num, format column names and column order
SELECT  -- *
	  f.ft_user_id
	, f.date_
	, f.print_or_digital
	, f.to_priceinctax AS current_price
	, f.to_offer_name AS current_offer
	, f.region
	, f.product_name_adjusted
	, f.product_term_adjusted
	, m.new_price AS step_up_price
	, m.offer_id AS step_up_offer_id
	, m.percent_discount

FROM final_tbl f
LEFT JOIN #stepup_matrix m ON f.product_name_adjusted::CHARACTER VARYING = m.subs_product::CHARACTER VARYING
AND f.product_term_adjusted::CHARACTER VARYING = m.subs_term::CHARACTER VARYING
AND f.currency_code::CHARACTER VARYING = m.currency::CHARACTER VARYING
AND (f.to_priceinctax::FLOAT >= m.lower_band::FLOAT)
AND (f.to_priceinctax::FLOAT <= m.higher_band::FLOAT)
--WHERE
------and product_name_adjusted = 'standard'
-- f.product_term_adjusted IN ('annual', 'monthly')
-- and f.arrangement_id_dd = 8528594
;