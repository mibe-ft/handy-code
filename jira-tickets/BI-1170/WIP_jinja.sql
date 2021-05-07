DROP TABLE IF EXISTS #step_up_matrix;
CREATE TABLE #step_up_matrix (
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

INSERT INTO #step_up_matrix VALUES
    ('GBP', 0.01, 146.3, 154.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('GBP', 146.31, 196.65, 207.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('GBP', 196.66, 219.45, 231.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('GBP', 219.46, 264.1, 278.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('GBP', 264.11, 293.55, 309.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('EUR', 0.01, 161.5, 170.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('EUR', 161.51, 215.65, 227.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('EUR', 215.66, 242.25, 255.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('EUR', 242.26, 290.7, 306.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('EUR', 290.71, 323.0, 340.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('USD', 0.01, 176.7, 186.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('USD', 176.71, 236.55, 249.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('USD', 236.56, 265.05, 279.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('USD', 265.06, 317.3, 334.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('USD', 317.31, 353.4, 372.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('AUD', 0.01, 176.7, 186.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('AUD', 176.71, 236.55, 249.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('AUD', 236.56, 265.05, 279.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('AUD', 265.06, 317.3, 334.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('AUD', 317.31, 353.4, 372.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('HKD', 0.01, 1336.65, 1407.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('HKD', 1336.66, 1790.75, 1885.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('HKD', 1790.76, 2004.5, 2110.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('HKD', 2004.51, 2405.4, 2532.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('HKD', 2405.41, 2673.3, 2814.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('SGD', 0.01, 225.15, 237.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('SGD', 225.16, 301.15, 317.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('SGD', 301.16, 337.25, 355.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('SGD', 337.26, 404.7, 426.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('SGD', 404.71, 450.3, 474.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('JPY', 0.01, 23712.0, 24960.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('JPY', 23712.01, 31773.7, 33446.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('JPY', 31773.71, 35568.0, 37440.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('JPY', 35568.01, 42681.6, 44928.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('JPY', 42681.61, 47424.0, 49920.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('CHF', 0.01, 177.65, 187.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'annual', 'standard'),
    ('CHF', 177.66, 238.45, 251.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'annual', 'standard'),
    ('CHF', 238.46, 266.95, 281.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'annual', 'standard'),
    ('CHF', 266.96, 320.15, 337.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'annual', 'standard'),
    ('CHF', 320.16, 356.25, 375.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'annual', 'standard'),
    ('GBP', 0.01, 15.675, 16.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('GBP', 15.69, 20.9, 22.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('GBP', 20.91, 23.275, 24.5, '-26%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('GBP', 23.29, 28.025, 29.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('GBP', 28.04, 31.35, 33.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('EUR', 0.01, 18.05, 19.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('EUR', 18.06, 23.75, 25.0, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('EUR', 23.76, 27.075, 28.5, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('EUR', 27.09, 32.3, 34.0, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('EUR', 32.31, 36.1, 38.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('USD', 0.01, 19.0, 20.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('USD', 19.01, 25.175, 26.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('USD', 25.19, 28.5, 30.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('USD', 28.51, 34.2, 36.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('USD', 34.21, 38.0, 40.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('AUD', 0.01, 19.0, 20.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('AUD', 19.01, 25.175, 26.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('AUD', 25.19, 28.5, 30.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('AUD', 28.51, 34.2, 36.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('AUD', 34.21, 38.0, 40.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('HKD', 0.01, 144.875, 152.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('HKD', 144.89, 193.8, 204.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('HKD', 193.81, 216.6, 228.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('HKD', 216.61, 260.3, 274.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('HKD', 260.31, 289.75, 305.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('SGD', 0.01, 24.7, 26.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('SGD', 24.71, 32.775, 34.5, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('SGD', 32.79, 37.05, 39.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('SGD', 37.06, 44.175, 46.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('SGD', 44.19, 49.4, 52.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('JPY', 0.01, 2569.75, 2705.0, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('JPY', 2569.76, 3442.8, 3624.0, '-33%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('JPY', 3442.81, 3854.15, 4057.0, '-25%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('JPY', 3854.16, 4625.55, 4869.0, '-10%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('JPY', 4625.56, 5139.5, 5410.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard'),
    ('CHF', 0.01, 19.475, 20.5, '-50%', 1, 'bb776c53-abdd-280d-4279-cd9aeb0257ff', 'monthly', 'standard'),
    ('CHF', 19.49, 25.65, 27.0, '-34%', 2, 'a9582121-87c2-09a7-0cc0-4caf594985d5', 'monthly', 'standard'),
    ('CHF', 25.66, 28.975, 30.5, '-26%', 3, 'c1773439-53dc-df3d-9acc-20ce2ecde318', 'monthly', 'standard'),
    ('CHF', 28.99, 34.675, 36.5, '-11%', 4, 'af5c6249-dccb-ed81-d1a8-3fbdf3a11800', 'monthly', 'standard'),
    ('CHF', 34.69, 38.95, 41.0, '0%', 5, 'c8ad55e6-ba74-fea0-f9da-a4546ae2ee23', 'monthly', 'standard')
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
			 , to_arrangementstatus_dkey
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
			 , to_offer_id
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
			, bsu.to_arrangementstatus_dkey					AS status_key
			, bsu.to_arrangementproduct_code				AS product_code
			, bsu.to_priceinctax
			, bsu.to_pricegbpinctax
			, bsu.to_offer_name
			, bsu.to_offer_price
			, bsu.to_offer_id
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
	, f.to_offer_id AS current_offer_id
	, f.region
	, f.currency_code
	, f.product_name_adjusted
	, f.product_term_adjusted
	, m.new_price AS step_up_price
	, m.offer_id AS step_up_offer_id
	, m.percent_discount AS step_up_percent_discount
	, CASE WHEN status_key = 3 THEN 1 ELSE 0 END AS is_cancelled
	, CASE WHEN (to_cancelrequest_dtm IS NOT NULL OR to_cancel_dtm IS NOT NULL) THEN 1 ELSE 0 END AS has_cancel_request
	, DATEDIFF(days, CURRENT_DATE, f.to_end_dtm) AS days_until_end_of_term

FROM final_tbl f
LEFT JOIN #step_up_matrix m ON f.product_name_adjusted::CHARACTER VARYING = m.subs_product::CHARACTER VARYING
AND f.product_term_adjusted::CHARACTER VARYING = m.subs_term::CHARACTER VARYING
AND f.currency_code::CHARACTER VARYING = m.currency::CHARACTER VARYING
AND (f.to_priceinctax::FLOAT >= m.lower_band::FLOAT)
AND (f.to_priceinctax::FLOAT <= m.higher_band::FLOAT)
--WHERE
------and product_name_adjusted = 'standard'
-- f.product_term_adjusted IN ('annual', 'monthly')
-- and f.arrangement_id_dd = 8528594
;