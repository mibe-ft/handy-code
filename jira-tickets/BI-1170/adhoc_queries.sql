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
	accountnumber,
	additionalemailaddresses,
	allowinvoiceedit,
	autopay,
	balance,
	batch,
	bcdsettingoption,
	billcycleday,
	communicationprofileid,
	createdbyid,
	createddate,
	creditbalance,
	crmid,
	currency,
	customerservicerepname,
	defaultpaymentmethodid,
	accountid,
	invoicedeliveryprefsemail,
	invoicedeliveryprefsprint,
	invoicetemplateid,
	lastinvoicedate,
	"name",
	parentid,
	paymentgateway,
	paymentterm,
	purchaseordernumber,
	salesrepname,
	status,
	taxexemptcertificateid,
	taxexemptcertificatetype,
	taxexemptdescription,
	taxexempteffectivedate,
	taxexemptexpirationdate,
	taxexemptissuingjurisdiction,
	taxexemptstatus,
	totalinvoicebalance,
	updatedbyid,
	updateddate,
	ftuserguid,
	billtocontact_accountid,
	billtocontact_address1,
	billtocontact_address2,
	billtocontact_city,
	billtocontact_country,
	billtocontact_county,
	billtocontact_createdbyid,
	billtocontact_createddate,
	billtocontact_fax,
	billtocontact_firstname,
	billtocontact_homephone,
	billtocontact_id,
	billtocontact_lastname,
	billtocontact_mobilephone,
	billtocontact_nickname,
	billtocontact_otherphone,
	billtocontact_otherphonetype,
	billtocontact_personalemail,
	billtocontact_postalcode,
	billtocontact_state,
	billtocontact_taxregion,
	billtocontact_updatedbyid,
	billtocontact_updateddate,
	billtocontact_workemail,
	billtocontact_workphone,
	billto_businessaddress,
	soldtocontact_accountid,
	soldtocontact_address1,
	soldtocontact_address2,
	soldtocontact_city,
	soldtocontact_country,
	soldtocontact_county,
	soldtocontact_createdbyid,
	soldtocontact_createddate,
	soldtocontact_description,
	soldtocontact_fax,
	soldtocontact_firstname,
	soldtocontact_homephone,
	soldtocontact_id,
	soldtocontact_lastname,
	soldtocontact_mobilephone,
	soldtocontact_nickname,
	soldtocontact_otherphone,
	soldtocontact_otherphonetype,
	soldtocontact_personalemail,
	soldtocontact_postalcode,
	soldtocontact_state,
	soldtocontact_taxregion,
	soldtocontact_updatedbyid,
	soldtocontact_updateddate,
	soldtocontact_workemail,
	soldtocontact_workphone
FROM
	ftzuoradb.account
WHERE ftuserguid IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e')
--AND
	;

SELECT
	dw_account_key,
	dw_from_date,
	dw_end_date,
	dw_latest,
	dw_action,
	dw_record_version,
	accountnumber,
	additionalemailaddresses,
	allowinvoiceedit,
	autopay,
	balance,
	batch,
	bcdsettingoption,
	billcycleday,
	communicationprofileid,
	createdbyid,
	createddate,
	creditbalance,
	crmid,
	currency,
	customerservicerepname,
	defaultpaymentmethodid,
	accountid,
	invoicedeliveryprefsemail,
	invoicedeliveryprefsprint,
	invoicetemplateid,
	lastinvoicedate,
	"name",
	parentid,
	paymentgateway,
	paymentterm,
	purchaseordernumber,
	salesrepname,
	status,
	taxexemptcertificateid,
	taxexemptcertificatetype,
	taxexemptdescription,
	taxexempteffectivedate,
	taxexemptexpirationdate,
	taxexemptissuingjurisdiction,
	taxexemptstatus,
	totalinvoicebalance,
	updatedbyid,
	updateddate,
	ftuserguid,
	billtocontact_accountid,
	billtocontact_address1,
	billtocontact_address2,
	billtocontact_city,
	billtocontact_country,
	billtocontact_county,
	billtocontact_createdbyid,
	billtocontact_createddate,
	billtocontact_fax,
	billtocontact_firstname,
	billtocontact_homephone,
	billtocontact_id,
	billtocontact_lastname,
	billtocontact_mobilephone,
	billtocontact_nickname,
	billtocontact_otherphone,
	billtocontact_otherphonetype,
	billtocontact_personalemail,
	billtocontact_postalcode,
	billtocontact_state,
	billtocontact_taxregion,
	billtocontact_updatedbyid,
	billtocontact_updateddate,
	billtocontact_workemail,
	billtocontact_workphone,
	billto_businessaddress,
	soldtocontact_accountid,
	soldtocontact_address1,
	soldtocontact_address2,
	soldtocontact_city,
	soldtocontact_country,
	soldtocontact_county,
	soldtocontact_createdbyid,
	soldtocontact_createddate,
	soldtocontact_description,
	soldtocontact_fax,
	soldtocontact_firstname,
	soldtocontact_homephone,
	soldtocontact_id,
	soldtocontact_lastname,
	soldtocontact_mobilephone,
	soldtocontact_nickname,
	soldtocontact_otherphone,
	soldtocontact_otherphonetype,
	soldtocontact_personalemail,
	soldtocontact_postalcode,
	soldtocontact_state,
	soldtocontact_taxregion,
	soldtocontact_updatedbyid,
	soldtocontact_updateddate,
	soldtocontact_workemail,
	soldtocontact_workphone
FROM
	ftzuoradb.account_cdc
WHERE
	ftuserguid IN ('9d0df5a3-a799-4760-ba33-b3f5ae78650e');

