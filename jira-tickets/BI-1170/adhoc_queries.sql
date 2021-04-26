/*
-- =============================================
-- Author:      Name
-- Create date:
-- Description: Redshift queries
-- =============================================
*/
-- preview table
SELECT
	dw_inserted_date,
	userstatus_date_dkey,
	userstatus_dtm,
	user_dkey,
	is_b2c,
	is_b2b,
	is_registered,
	is_trialist,
	is_converted_trialist,
	is_active,
	is_payment_failure,
	is_pending,
	is_print,
	is_complimentary,
	is_prospect,
	is_staff,
	is_unknown,
	is_developer,
	arrangement_id,
	is_deleted,
	ft_user_id,
	is_known_inactive_licence,
	primary_cohort,
	sub_cohort,
	article_allowance_cohort,
	is_b2c_partnership,
	is_standardplus,
	is_b2b_pfu,
	is_b2b_pfu_engageable_user_90,
	is_b2b_pfu_engageable_user_365
FROM
	dwabstraction.fact_userstatus
WHERE
	dw_inserted_date >= CURRENT_DATE -1
LIMIT 100
	;

select CURRENT_DATE-1;

/* filter on table for :
- yesterday
- b2c customer = true
- is_active = true

*/
SELECT 
	  dw_inserted_date
	, is_b2c
	, is_registered -- what is this?
	, is_print
	, ft_user_id
FROM 	
	dwabstraction.fact_userstatus fu 
WHERE
	userstatus_date_dkey = 20210422 -- this is the distribution key, makes more sense to use this!
AND is_b2c = True
AND is_active = True

;

-- find earliest record, takes awfully lonh
select min(userstatus_date_dkey), max(userstatus_date_dkey) from dwabstraction.fact_userstatus fu

/*
 * Select one active ft_user_id and look at all history
 * */
--user_dkey: 389 		ft_user_id: 9d0df5a3-a799-4760-ba33-b3f5ae78650e
--user_dkey: 5403170 	ft_user_id: bbfeef24-7065-4a2b-90c8-67247cdb1b23 get ft_user_id
-- TODO check that ft_user_id is unique similar to user_dkey and vice versa
SELECT 
	  dw_inserted_date
	, userstatus_dtm 
	, is_b2c
	, is_registered -- what is this?
	, is_print
	, user_dkey
	, ft_user_id
	, DENSE_RANK() OVER (PARTITION BY ft_user_id ORDER BY ft_user_id ASC) -- lazy check 
	, DENSE_RANK() OVER (PARTITION BY user_dkey ORDER BY user_dkey ASC) -- lazy check
FROM 	
	dwabstraction.fact_userstatus fu 
WHERE
	userstatus_date_dkey >= 20210415 -- this is the distribution key, makes more sense to use this!
AND user_dkey IN (5403170, 389)
--AND ft_user_id IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e', 'bbfeef24-7065-4a2b-90c8-67247cdb1b23')
--AND is_b2c = True
--AND is_active = True

;

/*
 * check for print customers
 * */

SELECT
	  dw_inserted_date
	, userstatus_dtm
	, is_b2c
	, is_registered -- what is this?
	, is_print
	, user_dkey
	, ft_user_id
	, DENSE_RANK() OVER (PARTITION BY ft_user_id ORDER BY ft_user_id ASC) -- lazy check
	, DENSE_RANK() OVER (PARTITION BY user_dkey ORDER BY user_dkey ASC) -- lazy check
FROM
	dwabstraction.fact_userstatus fu
WHERE
	userstatus_date_dkey >= 20210415 -- this is the distribution key, makes more sense to use this!
--AND user_dkey IN (5403170, 389)
--AND ft_user_id IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e', 'bbfeef24-7065-4a2b-90c8-67247cdb1b23')
--AND is_b2c = True
--AND is_active = True
AND is_print = True
ORDER BY user_dkey ASC
;

/*
get zuora info, this can be used later for joins to enrich it with information from other sources
*/
SELECT
*
FROM
	ftzuoradb.account
WHERE ftuserguid IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e')
--AND
	;

SELECT
*
FROM
	ftzuoradb.account_cdc
WHERE
	ftuserguid IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e');

-- query from Maria initial to join tables
select distinct fu.ft_user_id as user_guid
, userstatus_dtm
, arrangementeventdate_dkey
, case when is_print then 'Print' else 'Digital' end print_digital
, daa.b2c_marketing_region
, daa.to_arrangementtype_name
, daa.to_arrangementlength_id
from dwabstraction.fact_userstatus fu
join  dwabstraction.dn_arrangementevent_all daa
    on fu.user_dkey = daa.user_dkey
    and fu.userstatus_date_dkey >= daa.arrangementeventdate_dkey
WHERE  daa.to_datasource_dkey = 2 -- Zuora
    and fu.is_b2c is true

/* table: dwabstraction.dn_arrangement_all
 * get the followinh
 * - current price
 * - current offer
 * - region?
 * - product name
 * - product term
 * */
-- view all
SELECT *
FROM dwabstraction.dn_arrangement_all
WHERE user_dkey = 389
;

-- view specific columnms
SELECT
to_main_product_code
, to_main_product_name
, to_offer_main_product_code
--, produ
FROM dwabstraction.dn_arrangement_all
WHERE user_dkey = 389
;

WITH step01 AS (
-- get user deets from fact user status
-- user_guid
-- date
-- print or digital
SELECT
	  ft_user_id AS user_guid
	, userstatus_dtm AS "date"
	, CASE WHEN is_print = True  THEN 'Print'
		   WHEN is_print = False THEN 'Digital'
		   ELSE NULL END AS print_or_digital

FROM
	dwabstraction.fact_userstatus fu
WHERE
		userstatus_date_dkey = 20210415 -- this is the distribution key, makes more sense to use this!
	AND user_dkey IN (260, 389, 10799463, 2874, 10807934, 7521, 19114, 20806, 26752, 30489, 32698, 10813871) -- randomly picked b2c users
	AND is_b2c = True
)

SELECT * FROM step01
;
