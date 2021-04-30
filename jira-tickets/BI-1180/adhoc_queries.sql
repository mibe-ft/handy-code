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

SELECT *
 FROM `ft-data.biteam.funnels_b2b_nnb` 
 where id = '00Q4G000019UYfAUAW' 
 --WHERE DATE(_PARTITIONTIME) = "2021-04-27" LIMIT 1000
 
 -- for checking against the new query I created
 SELECT *
 FROM `ft-data.biteam.funnels_b2b_nnb` 
 WHERE DATE(_PARTITIONTIME) > "2021-04-26" 
 and contract_start_date IS NOT NULL
 and id = '00Q4G00001BPPN8UAP'
 LIMIT 1000

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

-- for testing against query I've written 
SELECT *
 FROM `ft-data.biteam.funnels_b2b_nnb` 
 WHERE DATE(_PARTITIONTIME) > "2021-04-26" 
 and contract_start_date IS NOT NULL
 and id = '00Q4G00001BPPN8UAP'
 LIMIT 1000
 
-- write query to understand how many teams there are and how many null VALUES 
-- the field 'team' is mostly missing - how do we tell who belongs where?
-- is it already in salesforce but not pulled in?
-- TODO calculate running total
select CASE WHEN team IS NULL THEN 'missing' ELSE team END AS team_modified
, COUNT(COALESCE(team,'9999')) count_users
, SUM(count_users) OVER() total
, (1.0*count_users)/(1.0*total) *100.0 pc_of_total

from ftsfdb.view_sfdc_users vsu 
group by 1
order by 2 desc

-- how do you define student? USE 'SSI' in licencee name as suggested by Srikanth & Elitsa
-- TODO: make more efficient?
select distinct licencee_name__c 
from ftsfdb.sfdc_contracts_cdc scc
where licencee_name__c ILIKE '%SSI%'

-- pull unique list of leadsource

--Lead sources that do not contain inside and unknown, not equal to Secondary Schools, API Form and Agency
-- leadsource NOT IN ('Unknown','Secondary Schools', 'API Form',  'Agency')
-- exclude NULL values too?
-- what is 'inside' is that sales inside?
select DISTINCT leadsource 
from ftsfdb.view_sfdc_leads vsl 
order by 1

-- - Lead sources that equal to: Channel Referral, Contact Us Form, Customer Referral, Email Enquiry
--, Free Trail Request Form, FT Dept Referral, Online Order Form, Phone Enquiry, Web Chat

/*
 leadsource IN ('Channel Referral', 'Contact Us Form', 'Customer Referral', 'Email Enquiry', 'Free Trial Request Form',
 FT Dept Referral, 'Online Order Form', 'Phone Enquiry', 'Web chat')
 include all contact forms?
 Contact Us Form - Corporate
 Contact Us Form - Education
 Contact sales form
*/

-- how to distinguish outbound and inbound leads
--If possible to include a toggle that filters inbound and outbound leads, the user can select TRUE or FALSE when
-- filtering data from the NNB Funnel Dashboard.