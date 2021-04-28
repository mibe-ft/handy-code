/*
 * Questions:
 * - write truncate in airflow or write append daily?
 * - do we need to filter on print and digital only? Bundle is also available in arrangementevent_all table
 * - do you need all subscription types for B2C or just annual? if so, i need the logic for annual subs
 * - do you want both active and cancelled customer data?
 * - how far back do we need to go with this table?
 * - what do we mean by 'current offer' - is this the price they are paying or the %discount compared to the current rrp??
 * - where is the fast stats data? - who do you receive this from or do you pull this yourself?
 * - how do you calculate the formulated data in yellow?
 */

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
	 		userstatus_date_dkey = 20210423 -- TODO question: how far back should we go
		AND is_b2c = True
		AND user_dkey IN (SELECT user_dkey FROM dwabstraction.dn_arrangement_all WHERE to_datasource_dkey = 2)-- make sure zuora only
)
, b2c_subscriptions AS (
-- get additional info on b2c subs
-- row_number() identifies the latest arrangement event per day, per user, per arrangement
-- this is to make sure we grab the most recent arrangement details for each day if there are multiple changes in a day

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
, b2c_subscriptions_no_dupes AS (
-- filter out duplicate arrangement events
	SELECT ft_user_id AS ft_user_id_b
		 , user_dkey AS user_dkey_b
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
	FROM b2c_subscriptions 
	WHERE row_num = 1
) 
, final_tbl AS (
-- output for final table
	SELECT
		  uf.ft_user_id
		, uf.user_dkey 
		, uf.userstatus_date_dkey 
		, uf.userstatus_dtm
		, bsu.arrangementevent_dtm
		, bsu.start_dtm
		, bsu.to_termstart_dtm
		, bsu.to_end_dtm
		, bsu.to_renewal_dtm
		, bsu.to_cancelrequest_dtm
		, bsu.arrangement_id_dd
		, bsu.to_arrangementtype_name -- e.g. b2c subscription
		, bsu.to_arrangementlength_id -- length of arrangement
		, bsu.to_arrangementproduct_name -- e.g. Premium FT.com
		, bsu.to_arrangementproduct_type -- print or digital or bundle
		, bsu.to_arrangementstatus_name -- e.g. Active, Cancelled, Pending, Payment Failure
		, bsu.to_arrangementproduct_code
		, bsu.to_priceinctax 
		, bsu.to_pricegbpinctax
		, bsu.to_offer_name
		, bsu.to_offer_price
		, bsu.to_offer_type
		, bsu.to_offer_rrp
		, bsu.to_offer_percent_rrp
		, bsu.to_currency_code
		, bsu.to_currency_name
		, bsu.b2c_marketing_region
	
	FROM user_facts uf
	LEFT JOIN b2c_subscriptions_no_dupes bsu ON uf.user_dkey = bsu.user_dkey_b
		  AND (uf.userstatus_date_dkey >= bsu.to_termstartdate_dkey)
		  AND (uf.userstatus_date_dkey <= bsu.to_enddate_dkey)

)
-- select columns for table out and format field names
SELECT 
	  ft_user_id 									AS ft_user_guid
	, userstatus_dtm 								AS date_
--	, arrangementevent_dtm --X
	, to_arrangementproduct_type 					AS print_or_digital
	, to_arrangementstatus_name						AS status
	, arrangement_id_dd -- 
	, start_dtm
	, to_termstart_dtm
	, to_end_dtm -- TODO: create case statement i.e. if status = cancelled then to_cancelrequest_dtm
	, to_cancelrequest_dtm
	, to_priceinctax 								
	, to_pricegbpinctax								
	, to_offer_name
	, to_offer_price
	, to_offer_type
	, COALESCE(to_offer_rrp, 9999)					AS rrp_price -- todo sometimes null
	, to_offer_percent_rrp
	, 100-COALESCE(to_offer_percent_rrp, 9999)		AS current_discount
--	, AS current_offer 
	, b2c_marketing_region 							AS region
	, to_arrangementproduct_code					AS product_code
	, to_arrangementproduct_name 					AS product_name
	, to_arrangementlength_id 						AS product_term
	, to_currency_code								AS currency_code
--	, to_currency_name								AS currency_name
FROM final_tbl
WHERE 
	to_arrangementproduct_type IN ('Print', 'Digital')
	
;