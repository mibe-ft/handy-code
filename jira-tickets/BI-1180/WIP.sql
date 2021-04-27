SELECT 
	  sf_log.lead_id__c  as id
	, sf_log."name" 
	, sf_log.createddate 
	, sf_log.lead_id__c AS lead_id
	, sf_leads.leadsource AS original_lead_source
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
	, CASE WHEN sf_contracts.currencyisocode::text = 'GBP'::character varying::text THEN sf_contracts.amount
		    ELSE sf_contracts.amount / x.fxrate
			END AS oppo_amount_gbp --	, vo.gbpamount oppo_amount_gbp --vo
	, sf_opps.closed_lost_reason AS oppo_closed_lost_reason --c
	, sf_opps.closedate AS oppo_closed_date --c
	, sf_opps."type" AS oppo_product_name --c
	, CASE WHEN sf_contracts.currencyisocode::text = 'GBP'::character varying::text THEN sf_contracts.amount
		    ELSE sf_contracts.amount / x.fxrate
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
LEFT JOIN dwabstraction.dn_currencyexchangerate x ON x.fromcurrency_code = sf_contracts.currencyisocode::character(3) 
												  AND x.fxyear = sf_contracts.startdate 
	LEFT JOIN biteam.conversion_visit c ON
		sf_leads.spoor_id::text = c.device_spoor_id::text
		AND c.system_action::text = 'b2b-confirmed'::character varying::text
	LEFT JOIN ftspoordb.visits v ON
		c.conversion_visit_id = v.visit_id
WHERE sf_log.lead_id__c = '00Q4G00001BPPN8UAP'--'00Q4G000019UYfAUAW' 
;
--
-- need to get this working because gbpamount is not working 
SELECT
			t.lead_id,
			t.opportunity_id,
			t.contract,
			t.amount,
			t.currencyisocode,
			x.fxrate,
			CASE
				WHEN t.currencyisocode::text = 'GBP'::character varying::text THEN t.amount
				ELSE t.amount / x.fxrate
			END AS gbpamount
		FROM -- TODO From statement 42
			(
			SELECT
				l.id AS lead_id,
				"date_part"('year'::character varying::text,
				l.createddate) AS lead_created_year,
				o.opportunity_id,
				o.amount,
				o.currencyisocode,
				o.contract
			FROM -- TODO From statement 43
				ftsfdb.view_sfdc_leads l
			LEFT JOIN (
				SELECT
					sl.lead_id__c,
					o.id AS opportunity_id,
					o.amount,
					o.currencyisocode,
					o.contract
				FROM
					ftsfdb.view_sfdc_stage_log sl
				LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
					sl.opportunity__c::text = o.id::text
				WHERE
					sl.type__c::text = 'Opportunity'::character varying::text
				GROUP BY
					sl.lead_id__c,
					o.id,
					o.amount,
					o.currencyisocode,
					o.contract) o ON
				o.lead_id__c::text = l.id::text
			WHERE
				l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
			GROUP BY
				l.id,
				"date_part"('year'::character varying::text,
				l.createddate),
				o.opportunity_id,
				o.amount,
				o.currencyisocode,
				o.contract) t
		LEFT JOIN dwabstraction.dn_currencyexchangerate x ON
			x.fromcurrency_code = t.currencyisocode::character(3)
				AND x.fxyear = t.lead_created_year
			GROUP BY
				t.lead_id,
				t.opportunity_id,
				t.contract,
				t.amount,
				t.currencyisocode,
				x.fxrate