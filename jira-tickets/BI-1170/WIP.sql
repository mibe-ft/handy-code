/*
 * Questions:
 * - write truncate in airflow or write append daily?
 * - do we need to filter on print and digital only? Bundle is also available in arrangement_all table
 * - how far back do we need to go with this table?
 * - do we need flag for active subscribers only? people who haven't initiated cancellation request
 *
 * */

WITH user_facts AS (
-- get user deets from fact user status
-- user_guid
-- date
-- print or digital
	SELECT
		  ft_user_id
		, user_dkey
		, userstatus_dtm
		, userstatus_date_dkey

	FROM
		dwabstraction.fact_userstatus fu
	WHERE
	--		userstatus_date_dkey = 20210415
		 user_dkey = 389
	--	AND user_dkey IN (260, 389, 10799463, 2874, 10807934, 7521, 19114, 20806, 26752, 30489, 32698, 10813871) -- randomly picked b2c users
		AND is_b2c = True
	--	AND user_dkey IN (SELECT user_dkey FROM dwabstraction.dn_arrangement_all WHERE to_datasource_dkey = 2)-- make sure zuora only
)
, b2c_subscriptions AS (
	SELECT
		   ft_user_id as ft_user_id_b
		 , user_dkey as user_dkey_b
		 , b2c_marketing_region
		 , arrangementevent_dtm
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

	FROM
		dwabstraction.dn_arrangementevent_all daa
	WHERE
			to_arrangementtype_dkey 	= 5 -- B2C Subscription
		AND to_datasource_dkey 			= 2 -- Zuora
	--	AND to_arrangementstatus_dkey 	= 1 -- Active
		AND user_dkey = 389
)

SELECT
	  uf.ft_user_id
	, uf.userstatus_dtm
	, bsu.arrangementevent_dtm
	, bsu.to_termstart_dtm
	, bsu.to_end_dtm
	, bsu.to_renewal_dtm
	, bsu.to_arrangementtype_name -- e.g. b2c subscription
	, bsu.to_arrangementlength_id -- length of arrangement
	, bsu.to_arrangementproduct_name -- e.g. Premium FT.com
	, bsu.to_arrangementproduct_type -- print or digital or bundle,
	, bsu.to_priceinctax -- more robust, to_offer_price could contain NULL values
	, bsu.to_currency_code
	, bsu.to_currency_name
	, bsu.b2c_marketing_region

FROM user_facts uf
LEFT JOIN b2c_subscriptions bsu ON uf.user_dkey = bsu.user_dkey_b
	  AND (uf.userstatus_date_dkey >= bsu.to_termstartdate_dkey)
	  AND (uf.userstatus_date_dkey <= bsu.to_enddate_dkey)
WHERE
	uf.userstatus_date_dkey IN (20171203, 20181203, 20191203, 20201203) -- check specific dates to see join has worked as expected
--	AND uf.userstatus_date_dkey >= 20170101

;