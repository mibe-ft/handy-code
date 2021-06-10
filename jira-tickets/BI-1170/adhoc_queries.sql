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

-- distinct arrangement id
SELECT DISTINCT to_arrangementlength_id 
FROM dwabstraction.dn_arrangementevent_all daa 

-- get offer names
SELECT distinct to_offer_name
FROM dwabstraction.dn_arrangementevent_all daa 
ORDER BY 1
;

-- how does cancellations work, this shows active although person has requested cancellation
-- todo write check for dwabstraction.dn_arrangementevent_all 
SELECT *
FROM dwabstraction.dn_arrangementevent_all daa 
WHERE ft_user_id = '03a4b9df-938e-410e-b41c-f13a12fcefef'
ORDER BY arrangementevent_dtm 

-- check arrangement event types
select DISTINCT arrangementevent_name , arrangementevent_dkey 
from dwabstraction.dn_arrangementevent_all daa

-- creating the step up matrix

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
('GBP',0.01,146.30,154,'-50%',1,'bb776c53-abdd-280d-4279-cd9aeb0257ff','annual','standard'),
('GBP',146.31,196.65,207,'-33%',2,'a9582121-87c2-09a7-0cc0-4caf594985d5','annual','standard')
;
select * from #stepup_matrix;

-- check
select
--distinct to_arrangementproduct_name product_name
--distinct to_arrangementlength_id product_term
distinct to_arrangementproduct_type product_type
from dwabstraction.dn_arrangementevent_all daa
order by 1

-- create array of dates
SELECT CURRENT_DATE::TIMESTAMP  - (i * interval '1 day') as date_datetime
FROM generate_series(1,31) i
ORDER BY 1


-- investigate NULLS
SELECT *
FROM biteam.vw_step_up_automation vsua
WHERE product_name_adjusted = 'standard'
AND product_term_adjusted IN ('annual', 'monthly')
AND currency_code IN ('GBP', 'EUR', 'USD', 'AUD', 'HKD', 'SGD','JPY', 'CHF')
AND current_offer != 'Unknown'
AND step_up_price IS NULL
;

-- these are my should be nulls
SELECT *
FROM biteam.vw_step_up_automation vsua
WHERE product_name_adjusted = 'standard'
AND product_term_adjusted IN ('annual', 'monthly')
AND currency_code IN ('GBP', 'EUR', 'USD', 'AUD', 'HKD', 'SGD','JPY', 'CHF')
AND current_offer != 'Unknown'
AND step_up_price IS NULL
AND current_offer NOT LIKE '%RRP%'
;

-- check offer names
SELECT DISTINCT current_offer
FROM biteam.vw_step_up_automation vsua
WHERE product_name_adjusted = 'standard'
AND product_term_adjusted IN ('annual', 'monthly')
AND currency_code IN ('GBP', 'EUR', 'USD', 'AUD', 'HKD', 'SGD','JPY', 'CHF')
--AND current_offer != 'Unknown'
AND step_up_price IS NULL

WITH expected_nulls AS (
-- these are my should be nulls, filter should include cases where I expect nulls
SELECT *
FROM biteam.vw_step_up_automation vsua
WHERE product_name_adjusted = 'standard'
AND product_term_adjusted IN ('annual', 'monthly')
AND currency_code IN ('GBP', 'EUR', 'USD', 'AUD', 'HKD', 'SGD','JPY', 'CHF')
AND current_offer != 'Unknown'
AND step_up_price IS NULL
AND (current_offer LIKE '%RRP%' OR current_offer LIKE '%Full Price%')
--AND current_offer NOT LIKE '%RRP%' --
)
, unknowns AS (
SELECT * FROM biteam.vw_step_up_automation vsua
WHERE current_offer = 'Unknown'
)
, unexpected_nulls AS (
SELECT * FROM biteam.vw_step_up_automation vsua2
WHERE  step_up_price IS NULL
--ft_user_id NOT IN (SELECT ft_user_id FROM expected_nulls
)
SELECT
(SELECT COUNT(ft_user_id) FROM expected_nulls) AS expected_nulls_count,
(SELECT COUNT(ft_user_id) FROM unknowns) AS unknown_count,
(SELECT COUNT(ft_user_id) FROM unexpected_nulls) AS unexpected_nulls_count
--TODO there's around 61,739 of unexplained nulls

-- brings back current_offer TEST NC - Standard FT.com - Worldwide - 33% Discount Annual - Full Price Monthly
-- with currencies we don't have e.g TRY, BRL, CAD, MXN
SELECT *
FROM biteam.vw_step_up_automation vsua
WHERE product_name_adjusted = 'standard'
AND product_term_adjusted IN ('annual', 'monthly')
AND currency_code NOT IN ('GBP', 'EUR', 'USD', 'AUD', 'HKD', 'SGD','JPY', 'CHF')
AND current_offer != 'Unknown'
AND step_up_price IS NULL
--AND NOT (current_offer LIKE '%RRP%' OR current_offer LIKE '%Full Price%')

-- get top price per each combo
SELECT * FROM (
SELECT
	currency
	, new_price
	, percent_discount
	, offer_id
	, product_term
	, product_name
	, ROW_NUMBER () OVER(PARTITION BY currency, product_term, product_name ORDER BY new_price DESC) row_num

FROM biteam.step_up_matrix
)
WHERE row_num = 1

-- calculating sample size
select days_until_end_of_term
, product_term_adjusted
, product_name_adjusted
, round(count(arrangement_id)*.25)
from biteam.vw_step_up_b2c_zuora vsubcz
where days_until_end_of_term >= 28
and days_until_end_of_term <= 30
and is_eligible_for_step_up = 1
group by 1, 2,3
order by 3 desc;