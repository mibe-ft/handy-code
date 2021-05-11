WITH step01 AS (
    SELECT
          sf_log.lead_id__c  as id
        , sf_log."name" AS name_
        , CASE
            {%- for k,v in stage_names %}
                 WHEN sf_log."name" = '{{k}}'::character varying::text THEN '{{v}}'
            {%- endfor %}
                 ELSE sf_log."name" END AS stage_name
        , CASE
            {%- for k,v in stage_numbers %}
                 WHEN stage_name = '{{k}}'::character varying::text THEN {{v}}
            {%- endfor %}
                 ELSE NULL::integer END AS stage_number
        , sf_log.createddate
        , sf_log.lead_id__c AS lead_id
        , sf_leads.leadsource AS original_lead_source
        , CASE
        {%- for k,v in leadsource_types %}
            WHEN sf_leads.leadsource::text = '{{k}}'::character varying::text THEN '{{v}}'::character varying
        {%- endfor %}
            ELSE 'Unknown' END AS adjusted_lead_source
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
    LEFT JOIN ftsfdb.view_sfdc_users sf_users ON sf_leads.ownerid::text = sf_users.id::text
    LEFT JOIN dwabstraction.dim_country_latest dm_country ON LOWER(dm_country.country_name::text) = LOWER(sf_leads.country::text)
    LEFT JOIN ftsfdb.view_sfdc_opportunities sf_opps ON sf_opps.id::text = sf_log.opportunity__c::text
    LEFT JOIN ftsfdb.view_sfdc_contracts sf_contracts ON sf_opps.accountid::text = sf_contracts.accountid::text
    LEFT JOIN dwabstraction.dn_currencyexchangerate x ON x.fromcurrency_code = sf_opps.currencyisocode::CHARACTER(3)
                                                      AND x.fxyear = "date_part"('year'::CHARACTER VARYING::text, sf_contracts.createddate)
    LEFT JOIN biteam.conversion_visit c ON sf_leads.spoor_id::text = c.device_spoor_id::text
                                        AND c.system_action::text = 'b2b-confirmed'::CHARACTER VARYING::text
    LEFT JOIN ftspoordb.visits v ON c.conversion_visit_id = v.visit_id
    LEFT JOIN ftsfdb.view_sfdc_campaign_segments sf_cpseg ON v.campaign_id::text = sf_cpseg.segmentid__c::text
    WHERE sf_log.lead_id__c IN ('00Q4G00001BPPN8UAP','00Q4G000019UYfAUAW', '00Q4G000019TtFPUA0') -- todo delete me before release to production
      AND sf_leads.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
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
            WHERE name_ NOT IN ('Recycled', 'Suspect')
            )
    WHERE row_num = 1
)
, last_live_stg AS (
-- get last live stage
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
            WHERE name_ NOT IN ('Recycled', 'Suspect', 'Closed Lost', 'No Opportunity' )
            )
    WHERE row_num = 1
  )
, distinct_ids AS (
    SELECT
           id
         , original_lead_source
         , adjusted_lead_source
         , lead_industry_sector
         , salesforce_lead_segment_id_name
         , lead_spoor_id
         , createdbyid
         , lead_owner_id
         , lead_owner_name
         , lead_owner_team
         , lead_region
         , lead_subregion
         , lead_country
         , lead_gclid
         , lead_cpc
         , oppo_id
         , oppo_owner_id
         , oppo_owner_name
         , oppo_owner_team
         , oppo_amount_gbp
         , oppo_closed_lost_reason
         , oppo_closed_date
         , oppo_product_name
         , contract_amount_gbp
         , contract_start_date
         , contract_total_core_readers
         , contract_total_licenced_readers
         , contract_licence_type
         , contract_licence_name
         , contract_licence_solution
         , contract_type
         , contract_owner_id
         , contract_owner_name
         , contract_owner_team
         , client_type
         , contractnumber
         , sf_contract_number
         , spoor_id
         , visit_segment_id
         , visit_marketing_campaign_name
         , ROW_NUMBER() OVER(PARTITION BY id, visit_segment_id ORDER BY createddate DESC) AS row_num
    FROM step01
)
, stages_01 AS (
    SELECT
      id
	  {%- for v in stage_name_2 %}
	  , "max"(CASE WHEN stage_name::text = '{{v}}'::character varying::text THEN createddate ELSE NULL::timestamp without time zone END) AS {{v}}
      {%- endfor %}
    FROM step01
    GROUP BY id
)

--, wip AS (
SELECT a.id
    , b.current_max_stage_timestamp
    , b.current_max_stage_name
    , b.current_max_stage_number
    , c.last_live_stage_timestamp
    , c.last_live_stage_name
    , c.last_live_stage_number
    , CASE
        WHEN b.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 'closed_won'::character varying
        WHEN b.current_max_stage_name = '_closed_lost'::character varying::text THEN 'closed_lost'::character varying
        WHEN b.current_max_stage_name = '_no_opportunity'::character varying::text THEN 'no_opportunity'::character varying
        ELSE 'live'::character varying
        END AS lead_status
    , CASE
        WHEN b.current_max_stage_name = 'nine_closed_won'::character varying::text THEN b.current_max_stage_name
        WHEN b.current_max_stage_name = '_closed_lost'::character varying::text THEN c.last_live_stage_name
        WHEN b.current_max_stage_name = '_no_opportunity'::character varying::text THEN c.last_live_stage_name
        ELSE b.current_max_stage_name
        END AS lead_status_stage_name
    , CASE
        WHEN d.one_marketing_ready_lead IS NULL THEN 0 ELSE 1 END AS one_marketing_ready_lead_pre
    , CASE
        WHEN d.two_marketing_qualified_lead IS NULL THEN 0 ELSE 1 END AS two_marketing_qualified_lead_pre
    , CASE
        WHEN d.three_sales_ready_lead IS NULL THEN 0 ELSE 1 END AS three_sales_ready_lead_pre
    , CASE
        WHEN d.four_converted_to_opp IS NULL THEN 0 ELSE 1 END AS four_converted_to_opp_pre
    , CASE
        WHEN d.five_discover IS NULL THEN 0 ELSE 1 END AS five_discover_pre
    , CASE
        WHEN d.six_develop_and_prove IS NULL THEN 0 ELSE 1 END AS six_develop_and_prove_pre
    , CASE
        WHEN d.seven_proposal_negotiation IS NULL THEN 0 ELSE 1 END AS seven_proposal_negotiation_pre
    , CASE
        WHEN d.eight_agree_and_close_contract IS NULL THEN 0 ELSE 1 END AS eight_agree_and_close_contract_pre
    , CASE
        WHEN d.nine_closed_won IS NULL THEN 0 ELSE 1 END AS nine_closed_won_pre
    , CASE
        WHEN d.one_marketing_ready_lead IS NOT NULL THEN 1
        WHEN d.one_marketing_ready_lead IS NULL
            AND (lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'five_discover'::character varying::text
                OR lead_status_stage_name = 'six_develop_and_prove'::character varying::text
                OR lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
                OR lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
                OR lead_status_stage_name = 'nine_closed_won'::character varying::text
                OR lead_status_stage_name = NULL::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 1
        ELSE 0
        END AS one_marketing_ready_lead
    , CASE
        WHEN d.two_marketing_qualified_lead IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.two_marketing_qualified_lead IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS two_marketing_qualified_lead
    , CASE
        WHEN d.three_sales_ready_lead IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.three_sales_ready_lead IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS three_sales_ready_lead
    , CASE
        WHEN d.four_converted_to_opp IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.four_converted_to_opp IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS four_converted_to_opp
    , CASE
        WHEN d.five_discover IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.five_discover IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS five_discover
    , CASE
        WHEN d.six_develop_and_prove IS NULL
           AND lead_status_stage_name IS NULL THEN 0
        WHEN d.six_develop_and_prove IS NULL
           AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'five_discover'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
           AND last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS six_develop_and_prove
    , CASE
        WHEN d.seven_proposal_negotiation IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.seven_proposal_negotiation IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'five_discover'::character varying::text
                OR lead_status_stage_name = 'six_develop_and_prove'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS seven_proposal_negotiation
    , CASE
        WHEN d.eight_agree_and_close_contract IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.eight_agree_and_close_contract IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'five_discover'::character varying::text
                OR lead_status_stage_name = 'six_develop_and_prove'::character varying::text
                OR lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS eight_agree_and_close_contract
    , CASE
        WHEN d.nine_closed_won IS NULL
            AND lead_status_stage_name IS NULL THEN 0
        WHEN d.nine_closed_won IS NULL
            AND (lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
                OR lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
                OR lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
                OR lead_status_stage_name = 'four_converted_to_opp'::character varying::text
                OR lead_status_stage_name = 'five_discover'::character varying::text
                OR lead_status_stage_name = 'six_develop_and_prove'::character varying::text
                OR lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
                OR lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
                OR lead_status_stage_name = 'clicked'::character varying::text
                OR lead_status_stage_name = 'Member'::character varying::text)
            AND c.last_live_stage_timestamp IS NOT NULL THEN 0
        ELSE 1
        END AS nine_closed_won
    , CASE
        WHEN d.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
        ELSE d.one_marketing_ready_lead
        END AS one_marketing_ready_lead_pre_timestamp
    , CASE
        WHEN d.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
        ELSE d.two_marketing_qualified_lead
        END AS two_marketing_qualified_lead_pre_timestamp
    , CASE
        WHEN d.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
        ELSE d.three_sales_ready_lead
        END AS three_sales_ready_lead_pre_timestamp
    , CASE
        WHEN d.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
        ELSE d.four_converted_to_opp
        END AS four_converted_to_opp_pre_timestamp
    , CASE
        WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
        ELSE d.five_discover
        END AS five_discover_pre_timestamp
    , CASE
        WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
        ELSE d.six_develop_and_prove
        END AS six_develop_and_prove_pre_timestamp
    , CASE
        WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
        ELSE d.seven_proposal_negotiation
        END AS seven_proposal_negotiation_pre_timestamp
    , CASE
        WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
        ELSE d.eight_agree_and_close_contract
        END AS eight_agree_and_close_contract_pre_timestamp
    , CASE
        WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
        ELSE d.nine_closed_won
        END AS nine_closed_won_pre_timestamp
    , CASE
        WHEN d._closed_lost IS NULL THEN NULL::timestamp without time zone
        ELSE d._closed_lost
        END AS _closed_lost
    , CASE --todo case 1
        WHEN d._no_opportunity IS NULL THEN NULL::timestamp without time zone
        ELSE d._no_opportunity
        END AS _no_opportunity
    , CASE
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.two_marketing_qualified_lead
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.three_sales_ready_lead
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
            ELSE d.four_converted_to_opp
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
            ELSE d.five_discover
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.one_marketing_ready_lead
        END
    END AS one_marketing_ready_lead_add
    , CASE --todo case 2
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.three_sales_ready_lead
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
            ELSE d.four_converted_to_opp
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
            ELSE d.five_discover
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.two_marketing_qualified_lead
        END
    END AS two_marketing_qualified_lead_add
    , CASE --todo case 3
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
            ELSE d.four_converted_to_opp
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
            ELSE d.five_discover
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
            ELSE d.three_sales_ready_lead
        END
    END AS three_sales_ready_lead_add
    , CASE --todo case 4
        WHEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
            ELSE d.five_discover
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
            ELSE d.four_converted_to_opp
        END
    END AS four_converted_to_opp_add
    , CASE --todo case 5
        WHEN
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.five_discover IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.five_discover IS NULL THEN NULL::timestamp without time zone
            ELSE d.five_discover
        END
    END AS five_discover_add
    , CASE --todo case 6
        WHEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
            ELSE d.six_develop_and_prove
        END
    END AS six_develop_and_prove_add
    , CASE --todo case 7
        WHEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END - '00:00:01'::interval
        WHEN
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
            ELSE d.seven_proposal_negotiation
        END
    END AS seven_proposal_negotiation_add
    , CASE --todo case 8
        WHEN
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN 0
            ELSE 1
        END = 0
        AND
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END - '00:00:01'::interval
        ELSE
        CASE
            WHEN d.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
            ELSE d.eight_agree_and_close_contract
        END
    END AS eight_agree_and_close_contract_add
    , CASE --todo case 9
        WHEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN 0
            ELSE 1
        END <> 0 THEN
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END
        ELSE
        CASE
            WHEN d.nine_closed_won IS NULL THEN NULL::timestamp without time zone
            ELSE d.nine_closed_won
        END
    END AS nine_closed_won_add
    , a.id AS lead_id
    , a.original_lead_source
    , a.adjusted_lead_source
    , a.lead_industry_sector
    , a.salesforce_lead_segment_id_name
    , a.lead_spoor_id
    , a.createdbyid
    , a.lead_owner_id
    , a.lead_owner_name
    , a.lead_owner_team
    , a.lead_region
    , a.lead_subregion
    , a.lead_country
    , a.lead_gclid
    , a.lead_cpc
    , a.oppo_id
    , a.oppo_owner_id
    , a.oppo_owner_name
    , a.oppo_owner_team
    , a.oppo_amount_gbp
    , a.oppo_closed_lost_reason
    , a.oppo_closed_date
    , a.oppo_product_name
    , a.contract_amount_gbp
    , a.contract_start_date
    , a.contract_total_core_readers
    , a.contract_total_licenced_readers
    , a.contract_licence_type
    , a.contract_licence_name
    , a.contract_licence_solution
    , a.contract_type
    , a.contract_owner_id
    , a.contract_owner_name
    , a.contract_owner_team
    , a.client_type
    , a.contractnumber
    , a.sf_contract_number
    , a.spoor_id
    , a.visit_segment_id
    , a.visit_marketing_campaign_name
FROM distinct_ids a
LEFT JOIN current_max_stg b ON a.id = b.id
LEFT JOIN last_live_stg c ON a.id = c.id
LEFT JOIN stages_01 d ON a.id = d.id
WHERE a.row_num = 1
--)
