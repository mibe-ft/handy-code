SELECT 
	  vslog.lead_id__c  as lead_id
	, vslog."name" 
	, vslog.createddate 
	, vsl.leadsource
--	, adjusted_lead_source
--	, lead_industry_sector
--	, salesforce_lead_segment_id
--	, salesforce_lead_segment_id_name
--	, lead_spoor_id
--	, createdbyid
--	, lead_owner_id
--	, lead_owner_name
--	, lead_owner_team
--	, lead_region
--	, lead_subregion
--	, lead_country
--	, lead_gclid
--	, lead_cpc
--	, oppo_id
--	, oppo_owner_id
--	, oppo_owner_name
--	, oppo_owner_team
--	, oppo_amount_gbp
--	, oppo_closed_lost_reason
--	, oppo_closed_date
--	, oppo_product_name
--	, contract_amount_gbp
--	, contract_start_date
--	, contract_total_core_readers
--	, contract_total_licenced_readers
--	, contract_licence_type
--	, contract_licence_name
--	, contract_licence_solution
--	, contract_type
--	, contract_owner_id
--	, contract_owner_name
--	, contract_owner_team
--	, client_type
--	, contractnumber
--	, sf_contract_number
--	, spoor_id
--	, visit_segment_id
--	, visit_marketing_campaign_name
	
FROM ftsfdb.view_sfdc_stage_log vslog 
JOIN ftsfdb.view_sfdc_leads vsl ON vslog.lead_id__c = vsl.id
WHERE lead_id__c = '00Q4G000019UYfAUAW' 
