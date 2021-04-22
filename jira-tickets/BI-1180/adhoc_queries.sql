/*
-- =============================================
-- Author:      Name
-- Create date:
-- Description: BigQuery
-- =============================================
*/

--
SELECT  MIN(current_max_stage_timestamp), MAX(current_max_stage_timestamp)
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add` LIMIT 1000

-- get column names

SELECT column_name
FROM ft-bi-team.BI_layer_tables.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'funnels_b2b_nnb_add'

SELECT    table_catalog
        , table_schema
        , table_name
        , column_name
        , ordinal_position
        , data_type
FROM ft-bi-team.BI_layer_tables.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'funnels_b2b_nnb_add'

-- look at specific opportunity
SELECT  *
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add`
where id = '00Q4G00001CQEdzUAH'
LIMIT 1000

-- look several opportunities using declare
DECLARE var_ids ARRAY<STRING>;
SET var_ids = (SELECT ['00Q4G00001CQEdzUAH', '00Q4G00001CvK2WUAV', '00Q4G00001CuKScUAN'] as list);
SELECT  *
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add`
WHERE id in (select id from unnest (var_ids) id)
LIMIT 1000

-- check lead id is same as lead_id
DECLARE var_lead_id STRING;
SET var_lead_id = '00Q4G00001CQEdzUAH';
SELECT  id, lead_id, cast(id = lead_id as int64), id = lead_id
FROM `ft-bi-team.BI_layer_tables.funnels_b2b_nnb_add`
WHERE id = var_lead_id
;

/*
-- =============================================
-- Author:      Name
-- Create date:
-- Description: Redshift queries
-- =============================================
*/

--the id in the funnels table in bigquery is the lead_id
SELECT dw_load_sfdc_contracts_key, dw_from_date, dw_end_date, dw_latest, dw_action, dw_record_version, id, isdeleted, masterrecordid, lastname, firstname, salutation, "name", recordtypeid, title, company, street, city, state, postalcode, country, phone, mobilephone, email, website, description, leadsource, status, currencyisocode, ownerid, hasoptedoutofemail, isconverted, converteddate, convertedaccountid, convertedcontactid, convertedopportunityid, isunreadbyowner, createddate, createdbyid, lastmodifieddate, lastmodifiedbyid, systemmodstamp, lastactivitydate, emailbouncedreason, emailbounceddate, confidential_opt_in__c, ft_opt_in__c, third_party_opt_in__c, product_name__c, promotional_code__c, industry_sector__c, no_of_employees__c, other__c, mkto2__inferred_city__c, mkto2__inferred_company__c, mkto2__inferred_country__c, mkto2__inferred_metropolitan_area__c, mkto2__inferred_phone_area_code__c, mkto2__inferred_postal_code__c, mkto2__inferred_state_region__c, mkto2__original_referrer__c, mkto2__original_search_engine__c, mkto2__original_search_phrase__c, mkto2__original_source_info__c, mkto2__original_source_type__c, author_status__c, author__c, edition__c, ft_com_url__c, featured_executive__c, headline__c, other_syndication__c, page_number__c, photographer__c, publication_date__c, section__c, sub_section__c, nvmcontactworld__nvm_mobile__c, nvmcontactworld__nvm_phone__c, gclid__c, cpccampaign__c, lead_region__c, mkto2__lead_score__c, spoor_id__c, segment_id__c, job_function__c, sub_sector__c, no_opportunity_reason__c, channel_partner__c
FROM ftsfdb.sfdc_leads_cdc
where id = '00Q4G00001CQEdzUAH'

-- view all stages for particular ID
SELECT
	dw_load_sfdc_contracts_key,
	dw_from_date,
	dw_end_date,
	dw_latest,
	dw_action,
	dw_record_version,
	id,
	"name",
	createdbyid,
	createddate,
	lastmodifiedbyid,
	lastmodifieddate,
	lead__c,
	lead_id__c,
	opportunity__c,
	type__c
FROM
	ftsfdb.sfdc_stage_log_cdc
where
	lead_id__c = '00Q4G00001CQEdzUAH' ;