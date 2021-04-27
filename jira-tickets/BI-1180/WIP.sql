SELECT 
	  sf_log.lead_id__c  as lead_id
	, sf_log."name" 
	, sf_log.createddate 
	, sf_leads.leadsource
--	, adjusted_lead_source -- this is derived from a case statement lines 3156 - 3237
	, sf_leads.industry_sector AS lead_industry_sector -- d
	, sf_leads.segment_id AS salesforce_lead_segment_id --d
	, sf_cpseg.marketing_campaign__r_name AS salesforce_lead_segment_id_name --de
	, sf_leads.spoor_id AS lead_spoor_id --d
	, sf_leads.createdbyid -- d
	, sf_leads.ownerid AS lead_owner_id --d
	, (sf_users.firstname::text || ' '::character varying::text) || sf_users.lastname::text AS lead_owner_name --e 
	, sf_users.team AS lead_owner_team --e
	, dm_country.b2b_sales_region AS lead_region --r
	, dm_country.b2b_sales_subregion AS lead_subregion --r
	, sf_leads.country AS lead_country --d
	, sf_leads.gclid AS lead_gclid --d
	, sf_leads.cpccampaign AS lead_cpc --d
	, sf_log.opportunity__c AS oppo_id --s --line 6342 -- opportunity__c 3277
	, sf_opps.ownerid AS oppo_owner_id --c
	, (sf_users.firstname::text || ' '::character varying::text) || sf_users.lastname::text AS oppo_owner_name --ee
	, sf_users.team AS oppo_owner_team --ee
--	, vo.gbpamount oppo_amount_gbp --vo
	, CASE WHEN sf_contracts.currencyisocode::text = 'GBP'::character varying::text THEN sf_contracts.amount
		    ELSE sf_contracts.amount / x.fxrate
			END AS oppo_amount_gbp
	, sf_opps.closed_lost_reason AS oppo_closed_lost_reason --c
	, sf_opps.closedate AS oppo_closed_date --c
	, sf_opps."type" AS oppo_product_name --c
--	, contract_amount_gbp --vc
--	, contract_start_date --h
--	, contract_total_core_readers --h
--	, contract_total_licenced_readers --h
--	, contract_licence_type --h
--	, contract_licence_name --h
--	, contract_licence_solution --h
--	, contract_type --h
--	, contract_owner_id --h
--	, contract_owner_name --f
--	, contract_owner_team --f
--	, client_type --h
--	, contractnumber --h
--	, sf_contract_number --h
--	, spoor_id --d line 6551
--	, visit_segment_id --v.campaign_id 6587
--	, visit_marketing_campaign_name --cs.marketing_campaign__r_name
	
FROM ftsfdb.view_sfdc_stage_log sf_log 
LEFT JOIN ftsfdb.view_sfdc_leads sf_leads ON sf_log.lead_id__c = sf_leads.id
LEFT JOIN ftsfdb.view_sfdc_campaign_segments sf_cpseg ON sf_leads.segment_id::text = sf_cpseg.segmentid__c::text
LEFT JOIN ftsfdb.view_sfdc_users sf_users ON sf_leads.ownerid::text = sf_users.id::text
LEFT JOIN dwabstraction.dim_country_latest dm_country ON lower(dm_country.country_name::text) = lower(sf_leads.country::text)
LEFT JOIN ftsfdb.view_sfdc_opportunities sf_opps ON sf_opps.id::text = sf_log.opportunity__c::text
LEFT JOIN ftsfdb.view_sfdc_contracts sf_contracts ON sf_opps.accountid::text = sf_contracts.accountid::text
LEFT JOIN dwabstraction.dn_currencyexchangerate x ON x.fromcurrency_code = sf_contracts.currencyisocode::character(3) 
												  AND x.fxyear = sf_contracts.startdate 
WHERE sf_log.lead_id__c = '00Q4G000019UYfAUAW' 