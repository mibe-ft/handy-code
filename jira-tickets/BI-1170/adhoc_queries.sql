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

-- subscription (arrangement types)
select distinct to_arrangementtype_dkey , to_arrangementtype_name
from dwabstraction.dn_arrangement_all daa


-- this contains the most recent status
SELECT *
FROM dwabstraction.dn_arrangement_all
WHERE user_dkey = 389
;

-- this contains all the statuses
SELECT
*
FROM dwabstraction.dn_arrangementevent_all daa
WHERE user_dkey = 389
;

-- view all diff datasources
select distinct to_datasource, to_datasource_dkey from dwabstraction.dn_arrangement_all daa

-- view statuses
select distinct to_arrangementstatus_dkey , to_arrangementstatus_name
from dwabstraction.dn_arrangement_all daa
;

-- check user appears to have two arrangements for same time span 
-- the user has one arrangement, 1 'payment failed record', 1 'active' record
SELECT *
FROM dwabstraction.dn_arrangementevent_all daa 
WHERE ft_user_id = '001702c0-afb6-4c64-9779-94cd106d4884'
ORDER BY arrangementevent_dtm 

;

-- check for users that have multiple changes to one arrangement in one day
WITH dataset AS (
SELECT 
  ft_user_id 
, user_dkey 
, arrangement_id_dd 
, arrangementevent_dkey 
, arrangementevent_dtm 
, arrangementeventdate_dkey 
, arrangementeventtime_dkey 
, to_termstart_dtm 
, to_end_dtm 
FROM dwabstraction.dn_arrangementevent_all daa 
WHERE --ft_user_id = '001702c0-afb6-4c64-9779-94cd106d4884'
/*AND*/ to_arrangementstatus_dkey 	= 1 -- Active
	AND to_cancelreason_dkey = -1
ORDER BY arrangementevent_dtm 
)

--/*
 SELECT 
ft_user_id 
, user_dkey 
, arrangement_id_dd 
, DATE(arrangementevent_dtm) date_
, COUNT(arrangement_id_dd) count_
FROM dataset
WHERE arrangementeventdate_dkey >= 20210401
GROUP BY 1,2,3,4
HAVING count_ > 1
--*/
--select * from dataset
--where user_dkey IN (16592420,16607654)
--ORDER BY user_dkey, arrangementevent_dtm
;

-- get all cancel reasons
select distinct to_cancelreason_dkey
, to_cancelreason 
from dwabstraction.dn_arrangementevent_all daa 
order by 1
;

-- check specific users
-- check window function
with dataset AS (
SELECT *, ROW_NUMBER () OVER(PARTITION BY user_dkey, arrangement_id_dd, DATE(arrangementevent_dtm) ORDER BY arrangementevent_dtm DESC) AS row_num
FROM dwabstraction.dn_arrangementevent_all daa 
where user_dkey IN (16654914,16640122)
--ORDER BY user_dkey, arrangementevent_dtm
)

SELECT * from dataset
;