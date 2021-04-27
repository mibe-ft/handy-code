SELECT 
	  vslog.lead_id__c  as lead_id
	, vslog."name" 
	, vslog.createddate 
	, vsl.leadsource
FROM ftsfdb.view_sfdc_stage_log vslog 
JOIN ftsfdb.view_sfdc_leads vsl ON vslog.lead_id__c = vsl.id
WHERE lead_id__c = '00Q4G000019UYfAUAW' 
