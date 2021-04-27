/*
 * Questions:
 * - write truncate in airflow or write append daily?
 * - do we need to filter on print and digital only? Bundle is also available in arrangement_all table
 * - how far back do we need to go with this table?
 * - do we need flag for active subscribers only? people who haven't initiated cancellation request
 * - what do we mean by 'current offer' - is this the price they are paying or the %discount compared to the current rrp??
 * */

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
--		    user_dkey = 389
	--	AND user_dkey IN (260, 389, 10799463, 2874, 10807934, 7521, 19114, 20806, 26752, 30489, 32698, 10813871) -- randomly picked b2c users
	 	userstatus_date_dkey = 20210423
		AND is_b2c = True
		AND user_dkey IN (SELECT user_dkey FROM dwabstraction.dn_arrangement_all WHERE to_datasource_dkey = 2)-- make sure zuora only
)
, b2c_subscriptions AS (
-- get additional info on b2c subs
	SELECT
		   ft_user_id as ft_user_id_b
		 , user_dkey as user_dkey_b
		 , b2c_marketing_region
		 , arrangementevent_dtm
		 , arrangement_id_dd
		 , to_arrangementtype_name
		 , to_arrangementlength_id
		 , to_arrangementproduct_name
		 , to_arrangementproduct_type -- print or digital or bundle
		 , to_priceinctax -- more robust, to_offer_price could contain NULL values
		 , to_termstart_dtm
		 , to_end_dtm
		 , to_renewal_dtm
		 , to_termstartdate_dkey
		 , to_enddate_dkey
		 , to_currency_code
		 , to_currency_name
		 , to_offer_rrp
		 , to_offer_percent_rrp
	FROM
		dwabstraction.dn_arrangementevent_all daa
	WHERE
			to_arrangementtype_dkey 	= 5 -- B2C Subscription
		AND to_datasource_dkey 			= 2 -- Zuora
	--	AND to_arrangementstatus_dkey 	= 1 -- Active
--		AND user_dkey = 389
)
, final_tbl AS (
-- output for final table
	SELECT
		  uf.ft_user_id
		, uf.user_dkey 
		, uf.userstatus_date_dkey 
		, uf.userstatus_dtm
		, bsu.arrangementevent_dtm
		, bsu.to_termstart_dtm
		, bsu.to_end_dtm
		, bsu.to_renewal_dtm
		, bsu.arrangement_id_dd
		, bsu.to_arrangementtype_name -- e.g. b2c subscription
		, bsu.to_arrangementlength_id -- length of arrangement
		, bsu.to_arrangementproduct_name -- e.g. Premium FT.com
		, bsu.to_arrangementproduct_type -- print or digital or bundle,
		, bsu.to_priceinctax -- more robust, to_offer_price could contain NULL values
		, bsu.to_offer_rrp
		, bsu.to_offer_percent_rrp
		, bsu.to_currency_code
		, bsu.to_currency_name
		, bsu.b2c_marketing_region
	
	FROM user_facts uf
	LEFT JOIN b2c_subscriptions bsu ON uf.user_dkey = bsu.user_dkey_b
		  AND (uf.userstatus_date_dkey >= bsu.to_termstartdate_dkey)
		  AND (uf.userstatus_date_dkey <= bsu.to_enddate_dkey)
--	WHERE
	--	uf.userstatus_date_dkey IN (20171203, 20181203, 20191203, 20201203) -- check specific dates to see join has worked as expected
	--	AND uf.userstatus_date_dkey >= 20170101
)

-- select columns for table out and format field names
SELECT 
	  ft_user_id 									AS ft_user_guid
	, userstatus_dtm 								AS "date"
	, to_arrangementproduct_type 					AS print_or_digital
	, arrangement_id_dd -- 
	, to_termstart_dtm
	, to_end_dtm
	, to_priceinctax 								AS current_price
	, COALESCE(to_offer_rrp, 9999)					AS rrp_price
	, to_offer_percent_rrp
	, 100-COALESCE(to_offer_percent_rrp, 9999)		AS current_discount
--	, AS current_offer 
	, b2c_marketing_region 							AS region
	, to_arrangementproduct_name 					AS product_name
	, to_arrangementlength_id 						AS product_term
FROM final_tbl
WHERE 
	to_arrangementproduct_type IN ('Print', 'Digital')
-- AND user_dkey = 389
-- AND userstatus_date_dkey IN (20171203, 20181203, 20191203, 20201203)
--	and ft_user_guid = '001702c0-afb6-4c64-9779-94cd106d4884'

;