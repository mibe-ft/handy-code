WITH step01 AS (
SELECT
      sf_log.lead_id__c  as id
    , sf_log."name" AS name_
    , CASE
         WHEN sf_log."name" = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'
         WHEN sf_log."name" = 'Engaged'::character varying::text THEN 'two_marketing_qualified_lead'
         WHEN sf_log."name" = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'
         WHEN sf_log."name" = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'
         WHEN sf_log."name" = 'Qualified'::character varying::text THEN 'four_converted_to_opp'
         WHEN sf_log."name" = 'Discover'::character varying::text THEN 'five_discover'
         WHEN sf_log."name" = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'
         WHEN sf_log."name" = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'
         WHEN sf_log."name" = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'
         WHEN sf_log."name" = 'Closed Won'::character varying::text THEN 'nine_closed_won'
         WHEN sf_log."name" = 'Closed Lost'::character varying::text THEN '_closed_lost'
         WHEN sf_log."name" = 'No Opportunity'::character varying::text THEN '_no_opportunity'
         ELSE sf_log."name" END AS stage_name
    , CASE
        WHEN stage_name = '_no_opportunity'::character varying::text THEN 0
        WHEN stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
        WHEN stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
        WHEN stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
        WHEN stage_name = 'four_converted_to_opp'::character varying::text THEN 4
        WHEN stage_name = 'five_discover'::character varying::text THEN 5
        WHEN stage_name = 'six_develop_and_prove'::character varying::text THEN 6
        WHEN stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
        WHEN stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
        WHEN stage_name = 'nine_closed_won'::character varying::text THEN 9
        WHEN stage_name = '_closed_lost'::character varying::text THEN 10
        WHEN stage_name = 'Member'::character varying::text THEN 99
        WHEN stage_name = 'unknown'::character varying::text THEN 99
        WHEN stage_name = 'Open'::character varying::text THEN 99
        WHEN stage_name = 'Marketing qualified'::character varying::text THEN 2
        WHEN stage_name = 'Financial Services'::character varying::text THEN 99
        WHEN stage_name = 'Concurrency'::character varying::text THEN 99
        WHEN stage_name = 'clicked'::character varying::text THEN 99
        ELSE NULL::integer END AS stage_number
    , sf_log.createddate
    , sf_log.lead_id__c AS lead_id
    , sf_leads.leadsource AS original_lead_source
    , CASE
        WHEN sf_leads.leadsource::text = 'Build Batch'::character varying::text THEN 'Build Batch'::character varying
        WHEN sf_leads.leadsource::text = 'Build Final'::character varying::text THEN 'Build Final'::character varying
        WHEN sf_leads.leadsource::text = 'Client Source Batch'::character varying::text THEN 'Client Source Batch'::character varying
        WHEN sf_leads.leadsource::text = 'Client Source Final'::character varying::text THEN 'Client Source Final'::character varying
        WHEN sf_leads.leadsource::text = 'B2C-Individual Digital'::character varying::text THEN 'B2C-Individual Digital'::character varying
        WHEN sf_leads.leadsource::text = 'Corporate'::character varying::text THEN 'Corporate'::character varying
        WHEN sf_leads.leadsource::text = 'Registered'::character varying::text THEN 'Registered'::character varying
        WHEN sf_leads.leadsource::text = 'Sales Inside'::character varying::text THEN 'Sales Inside'::character varying
        WHEN sf_leads.leadsource::text = '2-9ers'::character varying::text THEN '2-9ers'::character varying
        WHEN sf_leads.leadsource::text = 'Agency'::character varying::text THEN 'Agency'::character varying
        WHEN sf_leads.leadsource::text = 'API Form'::character varying::text THEN 'API Form'::character varying
        WHEN sf_leads.leadsource::text = 'Bloomberg Leads'::character varying::text THEN 'Bloomberg'::character varying
        WHEN sf_leads.leadsource::text = 'Bloomberg Terminal'::character varying::text THEN 'Bloomberg'::character varying
        WHEN sf_leads.leadsource::text = 'Channel Partner'::character varying::text THEN 'Channel Partner'::character varying
        WHEN sf_leads.leadsource::text = 'Channel Referral'::character varying::text THEN 'Channel Referral'::character varying
        WHEN sf_leads.leadsource::text = 'Contact sales form'::character varying::text THEN 'Contact sales form'::character varying
        WHEN sf_leads.leadsource::text = 'Contact support form'::character varying::text THEN 'Contact support form'::character varying
        WHEN sf_leads.leadsource::text = 'Contact Us Form'::character varying::text THEN 'Contact Us Form'::character varying
        WHEN sf_leads.leadsource::text = 'Concurrency'::character varying::text THEN 'Copyright'::character varying
        WHEN sf_leads.leadsource::text = 'Copyright'::character varying::text THEN 'Copyright'::character varying
        WHEN sf_leads.leadsource::text = 'Email Forwarding'::character varying::text THEN 'Copyright'::character varying
        WHEN sf_leads.leadsource::text = 'Generic Email Address'::character varying::text THEN 'Copyright'::character varying
        WHEN sf_leads.leadsource::text = 'Overcopying'::character varying::text THEN 'Copyright'::character varying
        WHEN sf_leads.leadsource::text = 'Corporate Blog Subscriber'::character varying::text THEN 'Corporate Blog Subscriber'::character varying
        WHEN sf_leads.leadsource::text = 'Current Client'::character varying::text THEN 'Current Client'::character varying
        WHEN sf_leads.leadsource::text = 'Customer Referral'::character varying::text THEN 'Customer Referral'::character varying
        WHEN sf_leads.leadsource::text = 'Existing Client'::character varying::text THEN 'Customer Referral'::character varying
        WHEN sf_leads.leadsource::text = 'Existing Customer'::character varying::text THEN 'Customer Referral'::character varying
        WHEN sf_leads.leadsource::text = 'Case Study Download'::character varying::text THEN 'Document Download'::character varying
        WHEN sf_leads.leadsource::text = 'Document Download'::character varying::text THEN 'Document Download'::character varying
        WHEN sf_leads.leadsource::text = 'FTCorporate asset download'::character varying::text THEN 'Document Download'::character varying
        WHEN sf_leads.leadsource::text = 'Email Enquiry'::character varying::text THEN 'Email Enquiry'::character varying
        WHEN sf_leads.leadsource::text = 'Event'::character varying::text THEN 'Event'::character varying
        WHEN sf_leads.leadsource::text = 'FT Event'::character varying::text THEN 'Event'::character varying
        WHEN sf_leads.leadsource::text = 'Free Trial Form'::character varying::text THEN 'Free Trial Form'::character varying
        WHEN sf_leads.leadsource::text = 'FT Confidential Research'::character varying::text THEN 'FT Confidential Research'::character varying
        WHEN sf_leads.leadsource::text = 'FT Content'::character varying::text THEN 'FT Content'::character varying
        WHEN sf_leads.leadsource::text = 'FT Dept Referral'::character varying::text THEN 'FT Dept Referral'::character varying
        WHEN sf_leads.leadsource::text = 'FT Referral'::character varying::text THEN 'FT Referral'::character varying
        WHEN sf_leads.leadsource::text = 'FT.com'::character varying::text THEN 'FT.com'::character varying
        WHEN sf_leads.leadsource::text = 'Google Research'::character varying::text THEN 'Google Research'::character varying
        WHEN sf_leads.leadsource::text = 'Telephone Research'::character varying::text THEN 'Google Research'::character varying
        WHEN sf_leads.leadsource::text = 'Industry Contacts'::character varying::text THEN 'Industry Contacts'::character varying
        WHEN sf_leads.leadsource::text = 'Lighthouse'::character varying::text THEN 'Lighthouse'::character varying
        WHEN sf_leads.leadsource::text = 'Salesforce'::character varying::text THEN 'Lighthouse'::character varying
        WHEN sf_leads.leadsource::text = 'Linkedin Ads'::character varying::text THEN 'LinkedIn Ads'::character varying
        WHEN sf_leads.leadsource::text = 'LinkedIn Research'::character varying::text THEN 'LinkedIn Research'::character varying
        WHEN sf_leads.leadsource::text = 'Linkedin Search'::character varying::text THEN 'LinkedIn Research'::character varying
        WHEN sf_leads.leadsource::text = 'Manila'::character varying::text THEN 'Manila Research'::character varying
        WHEN sf_leads.leadsource::text = 'Manila Reseach'::character varying::text THEN 'Manila Research'::character varying
        WHEN sf_leads.leadsource::text = 'Manila Reseacrh'::character varying::text THEN 'Manila Research'::character varying
        WHEN sf_leads.leadsource::text = 'Manila Research'::character varying::text THEN 'Manila Research'::character varying
        WHEN sf_leads.leadsource::text = 'Phone Enquiry'::character varying::text THEN 'Phone Enquiry'::character varying
        WHEN sf_leads.leadsource::text = 'Print Customer'::character varying::text THEN 'Print Customer'::character varying
        WHEN sf_leads.leadsource::text = 'Secondary Schools'::character varying::text THEN 'Secondary Schools'::character varying
        WHEN sf_leads.leadsource::text = 'Syndication Sales Plan'::character varying::text THEN 'Syndication'::character varying
        WHEN sf_leads.leadsource::text = 'Telephone Prospecting'::character varying::text THEN 'Telephone Prospecting'::character varying
        WHEN sf_leads.leadsource::text = 'List Research (Company)'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Marketing/Third Party List'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Merit Data'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Merit Research'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Scout'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Third Party Data'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Third Party List'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Third Party Research'::character varying::text THEN 'Third Party'::character varying
        WHEN sf_leads.leadsource::text = 'Default - Please update'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Government Intelligence Digest'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'http://thefinlab.com/'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Other'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Republishing Africa'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Restoring Client Trust Report'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'SFDC-IN|Financial Times News Feed'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Unknown'::character varying::text THEN 'Unknown'::character varying
        WHEN sf_leads.leadsource::text = 'Web chat'::character varying::text THEN 'Web Chat'::character varying
        WHEN sf_leads.leadsource::text = 'Free Trial Request Form'::character varying::text THEN 'Free Trial Request Form'::character varying
        WHEN sf_leads.leadsource::text = 'Internet Research'::character varying::text THEN 'Internet Research'::character varying
        WHEN sf_leads.leadsource::text = 'Online Order Form'::character varying::text THEN 'Online Order Form'::character varying
        WHEN sf_leads.leadsource::text = 'Sales Navigator'::character varying::text THEN 'Sales Navigator'::character varying
        WHEN sf_leads.leadsource::text = 'Trialist'::character varying::text THEN 'Trialist'::character varying
        ELSE 'Unknown' END AS adjusted_leadsource
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
    , sf_opps.currencyisocode --x
    , sf_opps.amount --x
    , x.fxrate --x
    , CASE WHEN sf_opps.currencyisocode::text = 'GBP'::character varying::text THEN sf_opps.amount
            ELSE sf_opps.amount / x.fxrate
            END AS oppo_amount_gbp --	, vo.gbpamount oppo_amount_gbp --vo TODO doesn't populate
    , sf_opps.closed_lost_reason AS oppo_closed_lost_reason --c
    , sf_opps.closedate AS oppo_closed_date --c
    , sf_opps."type" AS oppo_product_name --c
    , CASE WHEN sf_opps.currencyisocode::text = 'GBP'::character varying::text THEN sf_opps.amount
            ELSE sf_opps.amount / x.fxrate
            END AS contract_amount_gbp --	, contract_amount_gbp --vc
    , sf_contracts.startdate AS contract_start_date --h
    , sf_contracts.total_core_readers AS contract_total_core_readers --h
    , sf_contracts.total_licenced_readers AS contract_total_licenced_readers --h
    , sf_contracts.licencetype AS contract_licence_type --h
    , sf_contracts.licencee_name AS contract_licence_name --h
    , sf_contracts.licence_solution AS contract_licence_solution --h
    , sf_contracts."type" AS contract_type --h
    , sf_contracts.ownerid AS contract_owner_id --h
    , (sf_users.firstname::text || ' '::character varying::text) || sf_users.lastname::text AS contract_owner_name --f
    , sf_users.team AS contract_owner_team --f
    , sf_contracts.client_type  --h
    , sf_contracts.contractnumber --h
    , sf_contracts.contractnumber_c AS sf_contract_number --h
    , sf_leads.spoor_id --d line 6551
    , v.campaign_id AS visit_segment_id --v.campaign_id 6587
    , sf_cpseg.marketing_campaign__r_name::text AS visit_marketing_campaign_name --cs.marketing_campaign__r_name
FROM ftsfdb.view_sfdc_stage_log sf_log
LEFT JOIN ftsfdb.view_sfdc_leads sf_leads ON sf_log.lead_id__c = sf_leads.id
LEFT JOIN ftsfdb.view_sfdc_campaign_segments sf_cpseg ON sf_leads.segment_id::text = sf_cpseg.segmentid__c::text
LEFT JOIN ftsfdb.view_sfdc_users sf_users ON sf_leads.ownerid::text = sf_users.id::text
LEFT JOIN dwabstraction.dim_country_latest dm_country ON lower(dm_country.country_name::text) = lower(sf_leads.country::text)
LEFT JOIN ftsfdb.view_sfdc_opportunities sf_opps ON sf_opps.id::text = sf_log.opportunity__c::text
LEFT JOIN ftsfdb.view_sfdc_contracts sf_contracts ON sf_opps.accountid::text = sf_contracts.accountid::text
LEFT JOIN dwabstraction.dn_currencyexchangerate x ON x.fromcurrency_code = sf_opps.currencyisocode::character(3)
												  AND x.fxyear = "date_part"('year'::character varying::text, sf_contracts.createddate)
LEFT JOIN biteam.conversion_visit c ON sf_leads.spoor_id::text = c.device_spoor_id::text
									AND c.system_action::text = 'b2b-confirmed'::character varying::text
LEFT JOIN ftspoordb.visits v ON c.conversion_visit_id = v.visit_id
WHERE sf_log.lead_id__c IN ('00Q4G00001BPPN8UAP','00Q4G000019UYfAUAW')
)
, current_max_stg AS (

-- getting current max stage nums
SELECT id
	 , createddate AS current_max_stage_timestamp
	 , stage_name AS current_max_stage_name
	 , stage_number AS current_max_stage_number
FROM (
SELECT id
, createddate
, stage_name
, stage_number
, name_
, ROW_NUMBER () OVER(PARTITION BY id ORDER BY createddate DESC) row_num
FROM step01
)
WHERE row_num = 1
  AND name_ NOT IN ('Recycled', 'Suspect')

)

SELECT id
	 , createddate AS last_live_stage_timestamp
	 , stage_name AS last_live_stage_name
	 , stage_number AS last_live_stage_number
FROM (
SELECT id
, createddate
, stage_name
, stage_number
, name_
, ROW_NUMBER () OVER(PARTITION BY id ORDER BY createddate DESC) row_num
FROM step01
)
WHERE row_num = 1
  AND name_ NOT IN ('Recycled', 'Suspect', 'Closed Lost', 'No Opportunity' )