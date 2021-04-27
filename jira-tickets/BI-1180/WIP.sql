SELECT 
	  sf_log.lead_id__c  as lead_id
	, sf_log."name" 
	, sf_log.createddate 
	, sf_leads.leadsource
--	, adjusted_lead_source -- this is derived from a case statement lines 3156 - 3237
--	, lead_industry_sector -- d
--	, salesforce_lead_segment_id --d
--	, salesforce_lead_segment_id_name --de
--	, lead_spoor_id --d
--	, createdbyid -- d
--	, lead_owner_id --d
--	, lead_owner_name --e 
--	, lead_owner_team --e
--	, lead_region --r
--	, lead_subregion --r
--	, lead_country --d
--	, lead_gclid --d
--	, lead_cpc --d
--	, oppo_id --s 
--	, oppo_owner_id --c
--	, oppo_owner_name --ee
--	, oppo_owner_team --ee
--	, oppo_amount_gbp --vo
--	, oppo_closed_lost_reason --c
--	, oppo_closed_date --c
--	, oppo_product_name --c
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
JOIN ftsfdb.view_sfdc_leads sf_leads ON sf_log.lead_id__c = sf_leads.id
WHERE lead_id__c = '00Q4G000019UYfAUAW' 