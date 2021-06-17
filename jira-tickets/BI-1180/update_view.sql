CALL bilayer.sp_take_from_schema_owner('biteam', 'funnels_b2b_nnb_2021', 'maka.ibe');
DROP VIEW IF EXISTS biteam.funnels_b2b_nnb_2021;
CREATE OR REPLACE VIEW biteam.funnels_b2b_nnb_2021 AS -- TODO uncomment this when you want to replace the view, need permission to change view
SELECT
	a.id,
	a.current_max_stage_timestamp,
	a.current_max_stage_name,
	a.current_max_stage_number,
	a.last_live_stage_timestamp,
	a.last_live_stage_name,
	a.last_live_stage_number,
	a.lead_status,
	a.lead_status_stage_name,
	a.one_marketing_ready_lead_pre,
	a.two_marketing_qualified_lead_pre,
	a.three_sales_ready_lead_pre,
	a.four_converted_to_opp_pre,
	a.five_discover_pre,
	a.six_develop_and_prove_pre,
	a.seven_proposal_negotiation_pre,
	a.eight_agree_and_close_contract_pre,
	a.nine_closed_won_pre,
	a.one_marketing_ready_lead,
	a.two_marketing_qualified_lead,
	a.three_sales_ready_lead,
	a.four_converted_to_opp,
	a.five_discover,
	a.six_develop_and_prove,
	a.seven_proposal_negotiation,
	a.eight_agree_and_close_contract,
	a.nine_closed_won,
	a.one_marketing_ready_lead_pre_timestamp,
	a.two_marketing_qualified_lead_pre_timestamp,
	a.three_sales_ready_lead_pre_timestamp,
	a.four_converted_to_opp_pre_timestamp,
	a.five_discover_pre_timestamp,
	a.six_develop_and_prove_pre_timestamp,
	a.seven_proposal_negotiation_pre_timestamp,
	a.eight_agree_and_close_contract_pre_timestamp,
	a.nine_closed_won_pre_timestamp,
	a._closed_lost,
	a._no_opportunity,
	a.one_marketing_ready_lead_add,
	a.two_marketing_qualified_lead_add,
	a.three_sales_ready_lead_add,
	a.four_converted_to_opp_add,
	a.five_discover_add,
	a.six_develop_and_prove_add,
	a.seven_proposal_negotiation_add,
	a.eight_agree_and_close_contract_add,
	a.nine_closed_won_add,
	b.lead_id,
	b.original_lead_source,
	b.adjusted_lead_source,
	b.lead_industry_sector,
	b.salesforce_lead_segment_id,
	b.salesforce_lead_segment_id_name,
	b.lead_spoor_id,
	b.createdbyid,
	b.lead_owner_id,
	b.lead_owner_name,
	b.lead_owner_team,
	b.lead_region,
	b.lead_subregion,
	b.lead_country,
	b.lead_gclid,
	b.lead_cpc,
	b.oppo_id,
	b.oppo_owner_id,
	b.oppo_owner_name,
	b.oppo_owner_team,
	b.oppo_amount_gbp,
	b.oppo_closed_lost_reason,
	b.oppo_closed_date,
	b.oppo_product_name,
	b.contract_amount_gbp,
	b.contract_start_date,
	b.contract_total_core_readers,
	b.contract_total_licenced_readers,
	b.contract_licence_type,
	b.contract_licence_name,
	b.contract_licence_solution,
	b.contract_type,
	b.contract_owner_id,
	b.contract_owner_name,
	b.contract_owner_team,
	b.client_type,
	b.contractnumber,
	b.sf_contract_number,
	c.spoor_id,
	c.visit_segment_id,
	c.visit_marketing_campaign_name,
	CASE WHEN original_lead_source IN ('Contact Us Form',
                                        'Email Enquiry',
                                        'Phone Enquiry',
                                        'Web chat',
                                        'Free Trial Request Form',
                                        'Online Order Form',
                                        'Channel Referral',
                                        'Customer Referral',
                                        'FT Dept Referral',
                                        'Print Customer',
'Document Download') AND (salesforce_lead_segment_id IS NULL OR salesforce_lead_segment_id = '' OR salesforce_lead_segment_id IN ('9fbe4fe1-9315-3d67-cc6d-2bc7650c4aea', '383c7f63-abf4-b62d-cb33-4c278e6fdf61'
, '97f89239-a1e9-81b2-7029-14ec0d40de41', '0e98e5a8-0380-84bb-6d56-13f4c806143b'
, 'd68c23b1-f58c-b610-124a-b90590582fa2', '5aaa048e-0bbc-f3d0-7d85-f845c0d89400')) THEN 'inbound'
WHEN original_lead_source IN ('Online Order Form',
'Contact Us Form',
'Email Enquiry',
'Phone Enquiry',
'Copyright',
'Advocacy',
'FT Content',
'Trialist',
'Lighthouse',
'Sales Navigator',
'Free Trial Request Form',
'Third Party List',
'Manila Research',
'Event',
'Document Download') AND (salesforce_lead_segment_id IS NOT NULL OR salesforce_lead_segment_id != '' OR salesforce_lead_segment_id NOT IN ('9fbe4fe1-9315-3d67-cc6d-2bc7650c4aea', '383c7f63-abf4-b62d-cb33-4c278e6fdf61'
, '97f89239-a1e9-81b2-7029-14ec0d40de41', '0e98e5a8-0380-84bb-6d56-13f4c806143b'
, 'd68c23b1-f58c-b610-124a-b90590582fa2', '5aaa048e-0bbc-f3d0-7d85-f845c0d89400')) THEN 'outbound'
ELSE NULL END AS inbound_outbound
FROM -- TODO From statement 1
	(
	SELECT
		a.id,
		a.current_max_stage_timestamp,
		a.current_max_stage_name,
		a.current_max_stage_no AS current_max_stage_number,
		a.last_live_stage_timestamp,
		a.last_live_stage_name,
		a.last_live_stage_no AS last_live_stage_number,
		a.lead_status,
		a.lead_status_stage_name,
		CASE
			WHEN a.one_marketing_ready_lead IS NULL THEN 0
			ELSE 1
		END AS one_marketing_ready_lead_pre,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL THEN 0
			ELSE 1
		END AS two_marketing_qualified_lead_pre,
		CASE
			WHEN a.three_sales_ready_lead IS NULL THEN 0
			ELSE 1
		END AS three_sales_ready_lead_pre,
		CASE
			WHEN a.four_converted_to_opp IS NULL THEN 0
			ELSE 1
		END AS four_converted_to_opp_pre,
		CASE
			WHEN a.five_discover IS NULL THEN 0
			ELSE 1
		END AS five_discover_pre,
		CASE
			WHEN a.six_develop_and_prove IS NULL THEN 0
			ELSE 1
		END AS six_develop_and_prove_pre,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL THEN 0
			ELSE 1
		END AS seven_proposal_negotiation_pre,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL THEN 0
			ELSE 1
		END AS eight_agree_and_close_contract_pre,
		CASE
			WHEN a.nine_closed_won IS NULL THEN 0
			ELSE 1
		END AS nine_closed_won_pre,
		CASE
			WHEN a.one_marketing_ready_lead IS NOT NULL THEN 1
			WHEN a.one_marketing_ready_lead IS NULL
			AND (a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'five_discover'::character varying::text
			OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
			OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
			OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
			OR a.lead_status_stage_name = 'nine_closed_won'::character varying::text
			OR a.lead_status_stage_name = NULL::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 1
			ELSE 0
		END AS one_marketing_ready_lead,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.two_marketing_qualified_lead IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS two_marketing_qualified_lead,
		CASE
			WHEN a.three_sales_ready_lead IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.three_sales_ready_lead IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS three_sales_ready_lead,
		CASE
			WHEN a.four_converted_to_opp IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.four_converted_to_opp IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS four_converted_to_opp,
		CASE
			WHEN a.five_discover IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.five_discover IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS five_discover,
		CASE
			WHEN a.six_develop_and_prove IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.six_develop_and_prove IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'five_discover'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS six_develop_and_prove,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.seven_proposal_negotiation IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'five_discover'::character varying::text
			OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS seven_proposal_negotiation,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.eight_agree_and_close_contract IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'five_discover'::character varying::text
			OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
			OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS eight_agree_and_close_contract,
		CASE
			WHEN a.nine_closed_won IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.nine_closed_won IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
			OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
			OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
			OR a.lead_status_stage_name = 'five_discover'::character varying::text
			OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
			OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
			OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
			OR a.lead_status_stage_name = 'clicked'::character varying::text
			OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END AS nine_closed_won,
		CASE
			WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.one_marketing_ready_lead
		END AS one_marketing_ready_lead_pre_timestamp,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.two_marketing_qualified_lead
		END AS two_marketing_qualified_lead_pre_timestamp,
		CASE
			WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.three_sales_ready_lead
		END AS three_sales_ready_lead_pre_timestamp,
		CASE
			WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
			ELSE a.four_converted_to_opp
		END AS four_converted_to_opp_pre_timestamp,
		CASE
			WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
			ELSE a.five_discover
		END AS five_discover_pre_timestamp,
		CASE
			WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
			ELSE a.six_develop_and_prove
		END AS six_develop_and_prove_pre_timestamp,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
			ELSE a.seven_proposal_negotiation
		END AS seven_proposal_negotiation_pre_timestamp,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
			ELSE a.eight_agree_and_close_contract
		END AS eight_agree_and_close_contract_pre_timestamp,
		CASE
			WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
			ELSE a.nine_closed_won
		END AS nine_closed_won_pre_timestamp,
		CASE
			WHEN a._closed_lost IS NULL THEN NULL::timestamp without time zone
			ELSE a._closed_lost
		END AS _closed_lost,
		CASE
			WHEN a._no_opportunity IS NULL THEN NULL::timestamp without time zone
			ELSE a._no_opportunity
		END AS _no_opportunity,
		CASE
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.two_marketing_qualified_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.one_marketing_ready_lead
			END
		END AS one_marketing_ready_lead_add,
		CASE
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.two_marketing_qualified_lead
			END
		END AS two_marketing_qualified_lead_add,
		CASE
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END
		END AS three_sales_ready_lead_add,
		CASE
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END
		END AS four_converted_to_opp_add,
		CASE
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END
		END AS five_discover_add,
		CASE
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END
		END AS six_develop_and_prove_add,
		CASE
			WHEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END
		END AS seven_proposal_negotiation_add,
		CASE
			WHEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END
		END AS eight_agree_and_close_contract_add,
		CASE
			WHEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END
			ELSE
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END
		END AS nine_closed_won_add
	FROM -- TODO From statement 2
		(
		SELECT
			a.id,
			a.current_max_stage_timestamp,
			a.current_max_stage_name,
			a.current_max_stage_no,
			a.last_live_stage_timestamp,
			a.last_live_stage_name,
			a.last_live_stage_no,
			a.lead_status,
			a.lead_status_stage_name,
			a.lead_status_stage_number,
			"max"(
			CASE
				WHEN a.stage_name::text = 'one_marketing_ready_lead'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS one_marketing_ready_lead,
			"max"(
			CASE
				WHEN a.stage_name::text = 'two_marketing_qualified_lead'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS two_marketing_qualified_lead,
			"max"(
			CASE
				WHEN a.stage_name::text = 'three_sales_ready_lead'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS three_sales_ready_lead,
			"max"(
			CASE
				WHEN a.stage_name::text = 'four_converted_to_opp'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS four_converted_to_opp,
			"max"(
			CASE
				WHEN a.stage_name::text = 'five_discover'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS five_discover,
			"max"(
			CASE
				WHEN a.stage_name::text = 'six_develop_and_prove'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS six_develop_and_prove,
			"max"(
			CASE
				WHEN a.stage_name::text = 'seven_proposal_negotiation'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS seven_proposal_negotiation,
			"max"(
			CASE
				WHEN a.stage_name::text = 'eight_agree_and_close_contract'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS eight_agree_and_close_contract,
			"max"(
			CASE
				WHEN a.stage_name::text = 'nine_closed_won'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS nine_closed_won,
			"max"(
			CASE
				WHEN a.stage_name::text = '_closed_lost'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS _closed_lost,
			"max"(
			CASE
				WHEN a.stage_name::text = '_no_opportunity'::character varying::text THEN a.createddate
				ELSE NULL::timestamp without time zone
			END) AS _no_opportunity
		FROM -- TODO From statement 3
			(
			SELECT
				a.id,
				a.stage_name,
				a.stage_number,
				a.createddate,
				a.min_created_date,
				a.stage_rank,
				a.current_max_stage_timestamp,
				a.current_max_stage_name,
				CASE
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 0
					WHEN a.current_max_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
					WHEN a.current_max_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
					WHEN a.current_max_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
					WHEN a.current_max_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
					WHEN a.current_max_stage_name = 'five_discover'::character varying::text THEN 5
					WHEN a.current_max_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
					WHEN a.current_max_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
					WHEN a.current_max_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 9
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 10
					WHEN a.current_max_stage_name = 'Member'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'unknown'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Open'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Marketing qualified'::character varying::text THEN 2
					WHEN a.current_max_stage_name = 'Financial Services'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Concurrency'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'clicked'::character varying::text THEN 99
					ELSE NULL::integer
				END AS current_max_stage_no,
				a.last_live_stage_timestamp,
				a.last_live_stage_name,
				CASE
					WHEN a.last_live_stage_name = '_no_opportunity'::character varying::text THEN 0
					WHEN a.last_live_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
					WHEN a.last_live_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
					WHEN a.last_live_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
					WHEN a.last_live_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
					WHEN a.last_live_stage_name = 'five_discover'::character varying::text THEN 5
					WHEN a.last_live_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
					WHEN a.last_live_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
					WHEN a.last_live_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
					WHEN a.last_live_stage_name = 'nine_closed_won'::character varying::text THEN 9
					WHEN a.last_live_stage_name = '_closed_lost'::character varying::text THEN 10
					WHEN a.last_live_stage_name = 'Member'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'unknown'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Open'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Marketing qualified'::character varying::text THEN 2
					WHEN a.last_live_stage_name = 'Financial Services'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Concurrency'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'clicked'::character varying::text THEN 99
					ELSE NULL::integer
				END AS last_live_stage_no,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 'closed_won'::character varying
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 'closed_lost'::character varying
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 'no_opportunity'::character varying
					ELSE 'live'::character varying
				END AS lead_status,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_name
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_name
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_name
					ELSE a.current_max_stage_name
				END AS lead_status_stage_name,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_number
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_number
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_number
					ELSE a.current_max_stage_number
				END AS lead_status_stage_number
			FROM -- TODO From statement 4
				(
				SELECT
					a.id,
					a.stage_name,
					"left"(a.stage_name::text,
					1) AS stage_number,
					a.createddate,
					a.min_created_date,
					a.stage_rank,
					a.current_max_stage_timestamp,
					b.current_max_stage_name,
					b.current_max_stage_number,
					b.last_live_stage_timestamp,
					b.last_live_stage_name,
					b.last_live_stage_number
				FROM -- TODO From statement 5
					(
					SELECT
						i.id,
						i.stage_name,
						i.createddate,
						i.min_created_date,
						i.stage_rank,
						i.current_max_stage AS current_max_stage_timestamp,
						e.current_max_stage_live AS last_live_stage_timestamp
					FROM -- TODO From statement 6
						(
						SELECT
							a.id,
							CASE
								WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
								WHEN a.name::text = 'Engaged'::character varying::text
								OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
								WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
								WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
								WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
								WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
								WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
								WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
								WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
								WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
								WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
								ELSE a.name
							END AS stage_name,
							a.createddate,
							a.min_created_date,
							a.stage_rank,
							"max"(b.createddate) AS current_max_stage
						FROM -- TODO From statement 7
							(
							SELECT
								l.id,
								sl.name,
								sl.createddate,
								pg_catalog.row_number() OVER( PARTITION BY l.id
							ORDER BY
								sl.createddate) AS stage_rank,
								min(sl.createddate) AS min_created_date
							FROM -- TODO From statement 8
								ftsfdb.view_sfdc_leads l
							JOIN ftsfdb.view_sfdc_stage_log sl ON
								sl.lead_id__c::text = l.id::text
							LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
								o.id::text = sl.opportunity__c::text
							WHERE
								l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
							GROUP BY
								l.id,
								sl.name,
								sl.createddate) a
						LEFT JOIN (
							SELECT
								l.id,
								sl.name,
								sl.createddate,
								pg_catalog.row_number() OVER( PARTITION BY l.id
							ORDER BY
								sl.createddate) AS stage_rank,
								min(sl.createddate) AS min_created_date
							FROM -- TODO From statement 9
								ftsfdb.view_sfdc_leads l
							JOIN ftsfdb.view_sfdc_stage_log sl ON
								sl.lead_id__c::text = l.id::text
							LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
								o.id::text = sl.opportunity__c::text
							WHERE
								l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
							GROUP BY
								l.id,
								sl.name,
								sl.createddate) b ON
							b.id::text = a.id::text
						WHERE
							a.name::text <> 'Suspect'::character varying::text
							AND a.name::text <> 'Recycled'::character varying::text
							AND b.name::text <> 'Suspect'::character varying::text
							AND b.name::text <> 'Recycled'::character varying::text
						GROUP BY
							a.id,
							CASE
								WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
								WHEN a.name::text = 'Engaged'::character varying::text
								OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
								WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
								WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
								WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
								WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
								WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
								WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
								WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
								WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
								WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
								ELSE a.name
							END,
							a.createddate,
							a.min_created_date,
							a.stage_rank) i
					LEFT JOIN (
						SELECT
							a.id,
							"max"(b.createddate) AS current_max_stage_live
						FROM -- TODO From statement 10
							(
							SELECT
								l.id,
								sl.name,
								sl.createddate,
								pg_catalog.row_number() OVER( PARTITION BY l.id
							ORDER BY
								sl.createddate) AS stage_rank,
								min(sl.createddate) AS min_created_date
							FROM -- TODO From statement 11
								ftsfdb.view_sfdc_leads l
							JOIN ftsfdb.view_sfdc_stage_log sl ON
								sl.lead_id__c::text = l.id::text
							LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
								o.id::text = sl.opportunity__c::text
							WHERE
								l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
							GROUP BY
								l.id,
								sl.name,
								sl.createddate) a
						LEFT JOIN (
							SELECT
								l.id,
								sl.name,
								sl.createddate,
								pg_catalog.row_number() OVER( PARTITION BY l.id
							ORDER BY
								sl.createddate) AS stage_rank,
								min(sl.createddate) AS min_created_date
							FROM -- TODO From statement 12
								ftsfdb.view_sfdc_leads l
							JOIN ftsfdb.view_sfdc_stage_log sl ON
								sl.lead_id__c::text = l.id::text
							LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
								o.id::text = sl.opportunity__c::text
							WHERE
								l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
							GROUP BY
								l.id,
								sl.name,
								sl.createddate) b ON
							b.id::text = a.id::text
						WHERE
							a.name::text <> 'Suspect'::character varying::text
							AND a.name::text <> 'Recycled'::character varying::text
							AND a.name::text <> 'Closed Lost'::character varying::text
							AND a.name::text <> 'No Opportunity'::character varying::text
							AND b.name::text <> 'Suspect'::character varying::text
							AND b.name::text <> 'Recycled'::character varying::text
							AND b.name::text <> 'Closed Lost'::character varying::text
							AND b.name::text <> 'No Opportunity'::character varying::text
						GROUP BY
							a.id) e ON
						i.id::text = e.id::text
					GROUP BY
						i.id,
						i.stage_name,
						i.createddate,
						i.min_created_date,
						i.stage_rank,
						i.current_max_stage,
						e.current_max_stage_live) a
				LEFT JOIN (
					SELECT
						a.id,
						a.current_max_stage_timestamp,
						"max"(
						CASE
							WHEN a.current_max_stage_timestamp = a.createddate THEN a.stage_name
							ELSE NULL::character varying
						END::text) AS current_max_stage_name,
						"max"(
						CASE
							WHEN a.current_max_stage_timestamp = a.createddate THEN "left"(a.stage_name::text,
							1)::character varying
							ELSE NULL::character varying
						END::text) AS current_max_stage_number,
						a.last_live_stage_timestamp,
						"max"(
						CASE
							WHEN a.last_live_stage_timestamp = a.createddate THEN a.stage_name
							ELSE NULL::character varying
						END::text) AS last_live_stage_name,
						"max"(
						CASE
							WHEN a.last_live_stage_timestamp = a.createddate THEN "left"(a.stage_name::text,
							1)::character varying
							ELSE NULL::character varying
						END::text) AS last_live_stage_number
					FROM -- TODO From statement 13
						(
						SELECT
							i.id,
							i.stage_name,
							i.createddate,
							i.min_created_date,
							i.stage_rank,
							i.current_max_stage AS current_max_stage_timestamp,
							e.current_max_stage_live AS last_live_stage_timestamp
						FROM -- TODO From statement 14
							(
							SELECT
								a.id,
								CASE
									WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
									WHEN a.name::text = 'Engaged'::character varying::text
										OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
										WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
										WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
										WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
										WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
										WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
										WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
										WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
										WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
										WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
										ELSE a.name
									END AS stage_name,
									a.createddate,
									a.min_created_date,
									a.stage_rank,
									"max"(b.createddate) AS current_max_stage
								FROM -- TODO From statement 15
									(
									SELECT
										l.id,
										sl.name,
										sl.createddate,
										pg_catalog.row_number() OVER( PARTITION BY l.id
									ORDER BY
										sl.createddate) AS stage_rank,
										min(sl.createddate) AS min_created_date
									FROM -- TODO From statement 16
										ftsfdb.view_sfdc_leads l
									JOIN ftsfdb.view_sfdc_stage_log sl ON
										sl.lead_id__c::text = l.id::text
									LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
										o.id::text = sl.opportunity__c::text
									WHERE
										l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
										AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
									GROUP BY
										l.id,
										sl.name,
										sl.createddate) a
								LEFT JOIN (
									SELECT
										l.id,
										sl.name,
										sl.createddate,
										pg_catalog.row_number() OVER( PARTITION BY l.id
									ORDER BY
										sl.createddate) AS stage_rank,
										min(sl.createddate) AS min_created_date
									FROM -- TODO From statement 17
										ftsfdb.view_sfdc_leads l
									JOIN ftsfdb.view_sfdc_stage_log sl ON
										sl.lead_id__c::text = l.id::text
									LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
										o.id::text = sl.opportunity__c::text
									WHERE
										l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
										AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
									GROUP BY
										l.id,
										sl.name,
										sl.createddate) b ON
									b.id::text = a.id::text
								WHERE
									a.name::text <> 'Suspect'::character varying::text
									AND a.name::text <> 'Recycled'::character varying::text
									AND b.name::text <> 'Suspect'::character varying::text
									AND b.name::text <> 'Recycled'::character varying::text
								GROUP BY
									a.id,
									CASE
										WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
										WHEN a.name::text = 'Engaged'::character varying::text
										OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
										WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
										WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
										WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
										WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
										WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
										WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
										WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
										WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
										WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
										ELSE a.name
									END,
									a.createddate,
									a.min_created_date,
									a.stage_rank) i
						LEFT JOIN (
							SELECT
								a.id,
								"max"(b.createddate) AS current_max_stage_live
							FROM -- TODO From statement 18
								(
								SELECT
									l.id,
									sl.name,
									sl.createddate,
									pg_catalog.row_number() OVER( PARTITION BY l.id
								ORDER BY
									sl.createddate) AS stage_rank,
									min(sl.createddate) AS min_created_date
								FROM -- TODO From statement 19
									ftsfdb.view_sfdc_leads l
								JOIN ftsfdb.view_sfdc_stage_log sl ON
									sl.lead_id__c::text = l.id::text
								LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
									o.id::text = sl.opportunity__c::text
								WHERE
									l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
									AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								GROUP BY
									l.id,
									sl.name,
									sl.createddate) a
							LEFT JOIN (
								SELECT
									l.id,
									sl.name,
									sl.createddate,
									pg_catalog.row_number() OVER( PARTITION BY l.id
								ORDER BY
									sl.createddate) AS stage_rank,
									min(sl.createddate) AS min_created_date
								FROM -- TODO From statement 20
									ftsfdb.view_sfdc_leads l
								JOIN ftsfdb.view_sfdc_stage_log sl ON
									sl.lead_id__c::text = l.id::text
								LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
									o.id::text = sl.opportunity__c::text
								WHERE
									l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
									AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
								GROUP BY
									l.id,
									sl.name,
									sl.createddate) b ON
								b.id::text = a.id::text
							WHERE
								a.name::text <> 'Suspect'::character varying::text
								AND a.name::text <> 'Recycled'::character varying::text
								AND a.name::text <> 'Closed Lost'::character varying::text
								AND a.name::text <> 'No Opportunity'::character varying::text
								AND b.name::text <> 'Suspect'::character varying::text
								AND b.name::text <> 'Recycled'::character varying::text
								AND b.name::text <> 'Closed Lost'::character varying::text
								AND b.name::text <> 'No Opportunity'::character varying::text
							GROUP BY
								a.id) e ON
							i.id::text = e.id::text
						GROUP BY
							i.id,
							i.stage_name,
							i.createddate,
							i.min_created_date,
							i.stage_rank,
							i.current_max_stage,
							e.current_max_stage_live) a
					GROUP BY
						a.id,
						a.current_max_stage_timestamp,
						a.last_live_stage_timestamp
					ORDER BY
						a.id DESC) b ON
					a.id::text = b.id::text
				GROUP BY
					a.id,
					a.stage_name,
					a.createddate,
					a.min_created_date,
					a.stage_rank,
					a.current_max_stage_timestamp,
					b.current_max_stage_name,
					b.current_max_stage_number,
					b.last_live_stage_timestamp,
					b.last_live_stage_name,
					b.last_live_stage_number
				ORDER BY
					a.id DESC) a
			GROUP BY
				a.id,
				a.stage_name,
				a.stage_number,
				a.createddate,
				a.min_created_date,
				a.stage_rank,
				a.current_max_stage_timestamp,
				a.current_max_stage_name,
				CASE
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 0
					WHEN a.current_max_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
					WHEN a.current_max_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
					WHEN a.current_max_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
					WHEN a.current_max_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
					WHEN a.current_max_stage_name = 'five_discover'::character varying::text THEN 5
					WHEN a.current_max_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
					WHEN a.current_max_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
					WHEN a.current_max_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 9
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 10
					WHEN a.current_max_stage_name = 'Member'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'unknown'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Open'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Marketing qualified'::character varying::text THEN 2
					WHEN a.current_max_stage_name = 'Financial Services'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'Concurrency'::character varying::text THEN 99
					WHEN a.current_max_stage_name = 'clicked'::character varying::text THEN 99
					ELSE NULL::integer
				END,
				a.last_live_stage_timestamp,
				a.last_live_stage_name,
				CASE
					WHEN a.last_live_stage_name = '_no_opportunity'::character varying::text THEN 0
					WHEN a.last_live_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
					WHEN a.last_live_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
					WHEN a.last_live_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
					WHEN a.last_live_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
					WHEN a.last_live_stage_name = 'five_discover'::character varying::text THEN 5
					WHEN a.last_live_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
					WHEN a.last_live_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
					WHEN a.last_live_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
					WHEN a.last_live_stage_name = 'nine_closed_won'::character varying::text THEN 9
					WHEN a.last_live_stage_name = '_closed_lost'::character varying::text THEN 10
					WHEN a.last_live_stage_name = 'Member'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'unknown'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Open'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Marketing qualified'::character varying::text THEN 2
					WHEN a.last_live_stage_name = 'Financial Services'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'Concurrency'::character varying::text THEN 99
					WHEN a.last_live_stage_name = 'clicked'::character varying::text THEN 99
					ELSE NULL::integer
				END,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 'closed_won'::character varying
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 'closed_lost'::character varying
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 'no_opportunity'::character varying
					ELSE 'live'::character varying
				END,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_name
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_name
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_name
					ELSE a.current_max_stage_name
				END,
				CASE
					WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_number
					WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_number
					WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_number
					ELSE a.current_max_stage_number
				END
			ORDER BY
				a.id DESC) a
		GROUP BY
			a.id,
			a.current_max_stage_timestamp,
			a.current_max_stage_name,
			a.current_max_stage_no,
			a.last_live_stage_timestamp,
			a.last_live_stage_name,
			a.last_live_stage_no,
			a.lead_status,
			a.lead_status_stage_name,
			a.lead_status_stage_number) a
	GROUP BY
		a.id,
		a.current_max_stage_timestamp,
		a.current_max_stage_name,
		a.current_max_stage_no,
		a.last_live_stage_timestamp,
		a.last_live_stage_name,
		a.last_live_stage_no,
		a.lead_status,
		a.lead_status_stage_name,
		CASE
			WHEN a.one_marketing_ready_lead IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.three_sales_ready_lead IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.four_converted_to_opp IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.five_discover IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.six_develop_and_prove IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.nine_closed_won IS NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.one_marketing_ready_lead IS NOT NULL THEN 1
			WHEN a.one_marketing_ready_lead IS NULL
			AND (a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'five_discover'::character varying::text
				OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
				OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
				OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
				OR a.lead_status_stage_name = 'nine_closed_won'::character varying::text
				OR a.lead_status_stage_name = NULL::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 1
			ELSE 0
		END,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.two_marketing_qualified_lead IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.three_sales_ready_lead IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.three_sales_ready_lead IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.four_converted_to_opp IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.four_converted_to_opp IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.five_discover IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.five_discover IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.six_develop_and_prove IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.six_develop_and_prove IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'five_discover'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.seven_proposal_negotiation IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'five_discover'::character varying::text
				OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.eight_agree_and_close_contract IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'five_discover'::character varying::text
				OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
				OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.nine_closed_won IS NULL
			AND a.lead_status_stage_name IS NULL THEN 0
			WHEN a.nine_closed_won IS NULL
			AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
				OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
				OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
				OR a.lead_status_stage_name = 'five_discover'::character varying::text
				OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
				OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
				OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
				OR a.lead_status_stage_name = 'clicked'::character varying::text
				OR a.lead_status_stage_name = 'Member'::character varying::text)
			AND a.last_live_stage_timestamp IS NOT NULL THEN 0
			ELSE 1
		END,
		CASE
			WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.one_marketing_ready_lead
		END,
		CASE
			WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.two_marketing_qualified_lead
		END,
		CASE
			WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
			ELSE a.three_sales_ready_lead
		END,
		CASE
			WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
			ELSE a.four_converted_to_opp
		END,
		CASE
			WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
			ELSE a.five_discover
		END,
		CASE
			WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
			ELSE a.six_develop_and_prove
		END,
		CASE
			WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
			ELSE a.seven_proposal_negotiation
		END,
		CASE
			WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
			ELSE a.eight_agree_and_close_contract
		END,
		CASE
			WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
			ELSE a.nine_closed_won
		END,
		CASE
			WHEN a._closed_lost IS NULL THEN NULL::timestamp without time zone
			ELSE a._closed_lost
		END,
		CASE
			WHEN a._no_opportunity IS NULL THEN NULL::timestamp without time zone
			ELSE a._no_opportunity
		END,
		CASE
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.two_marketing_qualified_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.one_marketing_ready_lead
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.two_marketing_qualified_lead
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
				ELSE a.three_sales_ready_lead
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
				ELSE a.four_converted_to_opp
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.five_discover IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
				ELSE a.five_discover
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
				ELSE a.six_develop_and_prove
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END - '00:00:01'::interval
			WHEN
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
				ELSE a.seven_proposal_negotiation
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN 0
				ELSE 1
			END = 0
			AND
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END - '00:00:01'::interval
			ELSE
			CASE
				WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
				ELSE a.eight_agree_and_close_contract
			END
		END,
		CASE
			WHEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN 0
				ELSE 1
			END <> 0 THEN
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END
			ELSE
			CASE
				WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
				ELSE a.nine_closed_won
			END
		END) a
LEFT JOIN (
	SELECT
		s.id AS lead_id,
		d.leadsource AS original_lead_source,
		CASE
			WHEN d.leadsource::text = 'Build Batch'::character varying::text THEN 'Build Batch'::character varying
			WHEN d.leadsource::text = 'Build Final'::character varying::text THEN 'Build Final'::character varying
			WHEN d.leadsource::text = 'Client Source Batch'::character varying::text THEN 'Client Source Batch'::character varying
			WHEN d.leadsource::text = 'Client Source Final'::character varying::text THEN 'Client Source Final'::character varying
			WHEN d.leadsource::text = 'B2C-Individual Digital'::character varying::text THEN 'B2C-Individual Digital'::character varying
			WHEN d.leadsource::text = 'Corporate'::character varying::text THEN 'Corporate'::character varying
			WHEN d.leadsource::text = 'Registered'::character varying::text THEN 'Registered'::character varying
			WHEN d.leadsource::text = 'Sales Inside'::character varying::text THEN 'Sales Inside'::character varying
			WHEN d.leadsource::text = '2-9ers'::character varying::text THEN '2-9ers'::character varying
			WHEN d.leadsource::text = 'Agency'::character varying::text THEN 'Agency'::character varying
			WHEN d.leadsource::text = 'API Form'::character varying::text THEN 'API Form'::character varying
			WHEN d.leadsource::text = 'Bloomberg Leads'::character varying::text THEN 'Bloomberg'::character varying
			WHEN d.leadsource::text = 'Bloomberg Terminal'::character varying::text THEN 'Bloomberg'::character varying
			WHEN d.leadsource::text = 'Channel Partner'::character varying::text THEN 'Channel Partner'::character varying
			WHEN d.leadsource::text = 'Channel Referral'::character varying::text THEN 'Channel Referral'::character varying
			WHEN d.leadsource::text = 'Contact sales form'::character varying::text THEN 'Contact sales form'::character varying
			WHEN d.leadsource::text = 'Contact support form'::character varying::text THEN 'Contact support form'::character varying
			WHEN d.leadsource::text = 'Contact Us Form'::character varying::text THEN 'Contact Us Form'::character varying
			WHEN d.leadsource::text = 'Concurrency'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Copyright'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Email Forwarding'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Generic Email Address'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Overcopying'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Corporate Blog Subscriber'::character varying::text THEN 'Corporate Blog Subscriber'::character varying
			WHEN d.leadsource::text = 'Current Client'::character varying::text THEN 'Current Client'::character varying
			WHEN d.leadsource::text = 'Customer Referral'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Existing Client'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Existing Customer'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Case Study Download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'Document Download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'FTCorporate asset download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'Email Enquiry'::character varying::text THEN 'Email Enquiry'::character varying
			WHEN d.leadsource::text = 'Event'::character varying::text THEN 'Event'::character varying
			WHEN d.leadsource::text = 'FT Event'::character varying::text THEN 'Event'::character varying
			WHEN d.leadsource::text = 'Free Trial Form'::character varying::text THEN 'Free Trial Form'::character varying
			WHEN d.leadsource::text = 'FT Confidential Research'::character varying::text THEN 'FT Confidential Research'::character varying
			WHEN d.leadsource::text = 'FT Content'::character varying::text THEN 'FT Content'::character varying
			WHEN d.leadsource::text = 'FT Dept Referral'::character varying::text THEN 'FT Dept Referral'::character varying
			WHEN d.leadsource::text = 'FT Referral'::character varying::text THEN 'FT Referral'::character varying
			WHEN d.leadsource::text = 'FT.com'::character varying::text THEN 'FT.com'::character varying
			WHEN d.leadsource::text = 'Google Research'::character varying::text THEN 'Google Research'::character varying
			WHEN d.leadsource::text = 'Telephone Research'::character varying::text THEN 'Google Research'::character varying
			WHEN d.leadsource::text = 'Industry Contacts'::character varying::text THEN 'Industry Contacts'::character varying
			WHEN d.leadsource::text = 'Lighthouse'::character varying::text THEN 'Lighthouse'::character varying
			WHEN d.leadsource::text = 'Salesforce'::character varying::text THEN 'Lighthouse'::character varying
			WHEN d.leadsource::text = 'Linkedin Ads'::character varying::text THEN 'LinkedIn Ads'::character varying
			WHEN d.leadsource::text = 'LinkedIn Research'::character varying::text THEN 'LinkedIn Research'::character varying
			WHEN d.leadsource::text = 'Linkedin Search'::character varying::text THEN 'LinkedIn Research'::character varying
			WHEN d.leadsource::text = 'Manila'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Reseach'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Reseacrh'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Research'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Phone Enquiry'::character varying::text THEN 'Phone Enquiry'::character varying
			WHEN d.leadsource::text = 'Print Customer'::character varying::text THEN 'Print Customer'::character varying
			WHEN d.leadsource::text = 'Secondary Schools'::character varying::text THEN 'Secondary Schools'::character varying
			WHEN d.leadsource::text = 'Syndication Sales Plan'::character varying::text THEN 'Syndication'::character varying
			WHEN d.leadsource::text = 'Telephone Prospecting'::character varying::text THEN 'Telephone Prospecting'::character varying
			WHEN d.leadsource::text = 'List Research (Company)'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Marketing/Third Party List'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Merit Data'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Merit Research'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Scout'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party Data'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party List'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party Research'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Default - Please update'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Government Intelligence Digest'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'http://thefinlab.com/'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Other'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Republishing Africa'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Restoring Client Trust Report'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'SFDC-IN|Financial Times News Feed'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Unknown'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Web chat'::character varying::text THEN 'Web Chat'::character varying
			WHEN d.leadsource::text = 'Free Trial Request Form'::character varying::text THEN 'Free Trial Request Form'::character varying
			WHEN d.leadsource::text = 'Internet Research'::character varying::text THEN 'Internet Research'::character varying
			WHEN d.leadsource::text = 'Online Order Form'::character varying::text THEN 'Online Order Form'::character varying
			WHEN d.leadsource::text = 'Sales Navigator'::character varying::text THEN 'Sales Navigator'::character varying
			WHEN d.leadsource::text = 'Trialist'::character varying::text THEN 'Trialist'::character varying
			ELSE 'Unknown'::character varying
		END AS adjusted_lead_source,
		d.industry_sector AS lead_industry_sector,
		d.segment_id AS salesforce_lead_segment_id,
		de.marketing_campaign__r_name AS salesforce_lead_segment_id_name,
		d.spoor_id AS lead_spoor_id,
		d.createdbyid,
		d.ownerid AS lead_owner_id,
		(e.firstname::text || ' '::character varying::text) || e.lastname::text AS lead_owner_name,
		e.team AS lead_owner_team,
		r.b2b_sales_region AS lead_region,
		r.b2b_sales_subregion AS lead_subregion,
		d.country AS lead_country,
		d.gclid AS lead_gclid,
		d.cpccampaign AS lead_cpc,
		s.opportunity_c AS oppo_id,
		c.ownerid AS oppo_owner_id,
		(ee.firstname::text || ' '::character varying::text) || ee.lastname::text AS oppo_owner_name,
		ee.team AS oppo_owner_team,
		vo.gbpamount AS oppo_amount_gbp,
		c.closed_lost_reason AS oppo_closed_lost_reason,
		c.closedate AS oppo_closed_date,
		c."type" AS oppo_product_name,
		vc.gbpamount AS contract_amount_gbp,
		h.startdate AS contract_start_date,
		h.total_core_readers AS contract_total_core_readers,
		h.total_licenced_readers AS contract_total_licenced_readers,
		h.licencetype AS contract_licence_type,
		h.licencee_name AS contract_licence_name,
		h.licence_solution AS contract_licence_solution,
		h."type" AS contract_type,
		h.ownerid AS contract_owner_id,
		(f.firstname::text || ' '::character varying::text) || f.lastname::text AS contract_owner_name,
		f.team AS contract_owner_team,
		h.client_type,
		h.contractnumber,
		h.contractnumber_c AS sf_contract_number
	FROM -- TODO From statement 21
		(
		SELECT
			a.id,
			"max"(b.opportunity__c::text) AS opportunity_c
		FROM -- TODO From statement 22
			(
			SELECT
				a.id,
				a.current_max_stage_timestamp,
				a.current_max_stage_name,
				a.current_max_stage_no AS current_max_stage_number,
				a.last_live_stage_timestamp,
				a.last_live_stage_name,
				a.last_live_stage_no AS last_live_stage_number,
				a.lead_status,
				a.lead_status_stage_name,
				CASE
					WHEN a.one_marketing_ready_lead IS NULL THEN 0
					ELSE 1
				END AS one_marketing_ready_lead_pre,
				CASE
					WHEN a.two_marketing_qualified_lead IS NULL THEN 0
					ELSE 1
				END AS two_marketing_qualified_lead_pre,
				CASE
					WHEN a.three_sales_ready_lead IS NULL THEN 0
					ELSE 1
				END AS three_sales_ready_lead_pre,
				CASE
					WHEN a.four_converted_to_opp IS NULL THEN 0
					ELSE 1
				END AS four_converted_to_opp_pre,
				CASE
					WHEN a.five_discover IS NULL THEN 0
					ELSE 1
				END AS five_discover_pre,
				CASE
					WHEN a.six_develop_and_prove IS NULL THEN 0
					ELSE 1
				END AS six_develop_and_prove_pre,
				CASE
					WHEN a.seven_proposal_negotiation IS NULL THEN 0
					ELSE 1
				END AS seven_proposal_negotiation_pre,
				CASE
					WHEN a.eight_agree_and_close_contract IS NULL THEN 0
					ELSE 1
				END AS eight_agree_and_close_contract_pre,
				CASE
					WHEN a.nine_closed_won IS NULL THEN 0
					ELSE 1
				END AS nine_closed_won_pre,
				CASE
					WHEN a.one_marketing_ready_lead IS NOT NULL THEN 1
					WHEN a.one_marketing_ready_lead IS NULL
						AND (a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
							OR a.lead_status_stage_name = 'nine_closed_won'::character varying::text
							OR a.lead_status_stage_name = NULL::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 1
						ELSE 0
					END AS one_marketing_ready_lead,
					CASE
						WHEN a.two_marketing_qualified_lead IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.two_marketing_qualified_lead IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS two_marketing_qualified_lead,
					CASE
						WHEN a.three_sales_ready_lead IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.three_sales_ready_lead IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS three_sales_ready_lead,
					CASE
						WHEN a.four_converted_to_opp IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.four_converted_to_opp IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS four_converted_to_opp,
					CASE
						WHEN a.five_discover IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.five_discover IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS five_discover,
					CASE
						WHEN a.six_develop_and_prove IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.six_develop_and_prove IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS six_develop_and_prove,
					CASE
						WHEN a.seven_proposal_negotiation IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.seven_proposal_negotiation IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS seven_proposal_negotiation,
					CASE
						WHEN a.eight_agree_and_close_contract IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.eight_agree_and_close_contract IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS eight_agree_and_close_contract,
					CASE
						WHEN a.nine_closed_won IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.nine_closed_won IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END AS nine_closed_won,
					CASE
						WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.one_marketing_ready_lead
					END AS one_marketing_ready_lead_pre_timestamp,
					CASE
						WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.two_marketing_qualified_lead
					END AS two_marketing_qualified_lead_pre_timestamp,
					CASE
						WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.three_sales_ready_lead
					END AS three_sales_ready_lead_pre_timestamp,
					CASE
						WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
						ELSE a.four_converted_to_opp
					END AS four_converted_to_opp_pre_timestamp,
					CASE
						WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
						ELSE a.five_discover
					END AS five_discover_pre_timestamp,
					CASE
						WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
						ELSE a.six_develop_and_prove
					END AS six_develop_and_prove_pre_timestamp,
					CASE
						WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
						ELSE a.seven_proposal_negotiation
					END AS seven_proposal_negotiation_pre_timestamp,
					CASE
						WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
						ELSE a.eight_agree_and_close_contract
					END AS eight_agree_and_close_contract_pre_timestamp,
					CASE
						WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
						ELSE a.nine_closed_won
					END AS nine_closed_won_pre_timestamp,
					CASE
						WHEN a._closed_lost IS NULL THEN NULL::timestamp without time zone
						ELSE a._closed_lost
					END AS _closed_lost,
					CASE
						WHEN a._no_opportunity IS NULL THEN NULL::timestamp without time zone
						ELSE a._no_opportunity
					END AS _no_opportunity,
					CASE
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.two_marketing_qualified_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.one_marketing_ready_lead
						END
					END AS one_marketing_ready_lead_add,
					CASE
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.two_marketing_qualified_lead
						END
					END AS two_marketing_qualified_lead_add,
					CASE
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END
					END AS three_sales_ready_lead_add,
					CASE
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END
					END AS four_converted_to_opp_add,
					CASE
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END
					END AS five_discover_add,
					CASE
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END
					END AS six_develop_and_prove_add,
					CASE
						WHEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END
					END AS seven_proposal_negotiation_add,
					CASE
						WHEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END
					END AS eight_agree_and_close_contract_add,
					CASE
						WHEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END
						ELSE
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END
					END AS nine_closed_won_add
				FROM -- TODO From statement 23
					(
					SELECT
						a.id,
						a.current_max_stage_timestamp,
						a.current_max_stage_name,
						a.current_max_stage_no,
						a.last_live_stage_timestamp,
						a.last_live_stage_name,
						a.last_live_stage_no,
						a.lead_status,
						a.lead_status_stage_name,
						a.lead_status_stage_number,
						"max"(
						CASE
							WHEN a.stage_name::text = 'one_marketing_ready_lead'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS one_marketing_ready_lead,
						"max"(
						CASE
							WHEN a.stage_name::text = 'two_marketing_qualified_lead'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS two_marketing_qualified_lead,
						"max"(
						CASE
							WHEN a.stage_name::text = 'three_sales_ready_lead'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS three_sales_ready_lead,
						"max"(
						CASE
							WHEN a.stage_name::text = 'four_converted_to_opp'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS four_converted_to_opp,
						"max"(
						CASE
							WHEN a.stage_name::text = 'five_discover'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS five_discover,
						"max"(
						CASE
							WHEN a.stage_name::text = 'six_develop_and_prove'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS six_develop_and_prove,
						"max"(
						CASE
							WHEN a.stage_name::text = 'seven_proposal_negotiation'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS seven_proposal_negotiation,
						"max"(
						CASE
							WHEN a.stage_name::text = 'eight_agree_and_close_contract'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS eight_agree_and_close_contract,
						"max"(
						CASE
							WHEN a.stage_name::text = 'nine_closed_won'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS nine_closed_won,
						"max"(
						CASE
							WHEN a.stage_name::text = '_closed_lost'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS _closed_lost,
						"max"(
						CASE
							WHEN a.stage_name::text = '_no_opportunity'::character varying::text THEN a.createddate
							ELSE NULL::timestamp without time zone
						END) AS _no_opportunity
					FROM -- TODO From statement 24
						(
						SELECT
							a.id,
							a.stage_name,
							a.stage_number,
							a.createddate,
							a.min_created_date,
							a.stage_rank,
							a.current_max_stage_timestamp,
							a.current_max_stage_name,
							CASE
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 0
								WHEN a.current_max_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
								WHEN a.current_max_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
								WHEN a.current_max_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
								WHEN a.current_max_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
								WHEN a.current_max_stage_name = 'five_discover'::character varying::text THEN 5
								WHEN a.current_max_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
								WHEN a.current_max_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
								WHEN a.current_max_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 9
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 10
								WHEN a.current_max_stage_name = 'Member'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'unknown'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Open'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Marketing qualified'::character varying::text THEN 2
								WHEN a.current_max_stage_name = 'Financial Services'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Concurrency'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'clicked'::character varying::text THEN 99
								ELSE NULL::integer
							END AS current_max_stage_no,
							a.last_live_stage_timestamp,
							a.last_live_stage_name,
							CASE
								WHEN a.last_live_stage_name = '_no_opportunity'::character varying::text THEN 0
								WHEN a.last_live_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
								WHEN a.last_live_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
								WHEN a.last_live_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
								WHEN a.last_live_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
								WHEN a.last_live_stage_name = 'five_discover'::character varying::text THEN 5
								WHEN a.last_live_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
								WHEN a.last_live_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
								WHEN a.last_live_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
								WHEN a.last_live_stage_name = 'nine_closed_won'::character varying::text THEN 9
								WHEN a.last_live_stage_name = '_closed_lost'::character varying::text THEN 10
								WHEN a.last_live_stage_name = 'Member'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'unknown'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Open'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Marketing qualified'::character varying::text THEN 2
								WHEN a.last_live_stage_name = 'Financial Services'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Concurrency'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'clicked'::character varying::text THEN 99
								ELSE NULL::integer
							END AS last_live_stage_no,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 'closed_won'::character varying
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 'closed_lost'::character varying
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 'no_opportunity'::character varying
								ELSE 'live'::character varying
							END AS lead_status,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_name
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_name
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_name
								ELSE a.current_max_stage_name
							END AS lead_status_stage_name,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_number
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_number
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_number
								ELSE a.current_max_stage_number
							END AS lead_status_stage_number
						FROM -- TODO From statement 25
							(
							SELECT
								a.id,
								a.stage_name,
								"left"(a.stage_name::text,
								1) AS stage_number,
								a.createddate,
								a.min_created_date,
								a.stage_rank,
								a.current_max_stage_timestamp,
								b.current_max_stage_name,
								b.current_max_stage_number,
								b.last_live_stage_timestamp,
								b.last_live_stage_name,
								b.last_live_stage_number
							FROM -- TODO From statement 26
								(
								SELECT
									i.id,
									i.stage_name,
									i.createddate,
									i.min_created_date,
									i.stage_rank,
									i.current_max_stage AS current_max_stage_timestamp,
									e.current_max_stage_live AS last_live_stage_timestamp
								FROM -- TODO From statement 27
									(
									SELECT
										a.id,
										CASE
											WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
											WHEN a.name::text = 'Engaged'::character varying::text
												OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
												WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
												WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
												WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
												WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
												WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
												WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
												WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
												WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
												WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
												ELSE a.name
											END AS stage_name,
											a.createddate,
											a.min_created_date,
											a.stage_rank,
											"max"(b.createddate) AS current_max_stage
										FROM -- TODO From statement 28
											(
											SELECT
												l.id,
												sl.name,
												sl.createddate,
												pg_catalog.row_number() OVER( PARTITION BY l.id
											ORDER BY
												sl.createddate) AS stage_rank,
												min(sl.createddate) AS min_created_date
											FROM -- TODO From statement 29
												ftsfdb.view_sfdc_leads l
											JOIN ftsfdb.view_sfdc_stage_log sl ON
												sl.lead_id__c::text = l.id::text
											LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
												o.id::text = sl.opportunity__c::text
											WHERE
												l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											GROUP BY
												l.id,
												sl.name,
												sl.createddate) a
										LEFT JOIN (
											SELECT
												l.id,
												sl.name,
												sl.createddate,
												pg_catalog.row_number() OVER( PARTITION BY l.id
											ORDER BY
												sl.createddate) AS stage_rank,
												min(sl.createddate) AS min_created_date
											FROM -- TODO From statement 30
												ftsfdb.view_sfdc_leads l
											JOIN ftsfdb.view_sfdc_stage_log sl ON
												sl.lead_id__c::text = l.id::text
											LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
												o.id::text = sl.opportunity__c::text
											WHERE
												l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											GROUP BY
												l.id,
												sl.name,
												sl.createddate) b ON
											b.id::text = a.id::text
										WHERE
											a.name::text <> 'Suspect'::character varying::text
											AND a.name::text <> 'Recycled'::character varying::text
											AND b.name::text <> 'Suspect'::character varying::text
											AND b.name::text <> 'Recycled'::character varying::text
										GROUP BY
											a.id,
											CASE
												WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
												WHEN a.name::text = 'Engaged'::character varying::text
												OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
												WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
												WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
												WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
												WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
												WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
												WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
												WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
												WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
												WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
												ELSE a.name
											END,
											a.createddate,
											a.min_created_date,
											a.stage_rank) i
								LEFT JOIN (
									SELECT
										a.id,
										"max"(b.createddate) AS current_max_stage_live
									FROM -- TODO From statement 31
										(
										SELECT
											l.id,
											sl.name,
											sl.createddate,
											pg_catalog.row_number() OVER( PARTITION BY l.id
										ORDER BY
											sl.createddate) AS stage_rank,
											min(sl.createddate) AS min_created_date
										FROM -- TODO From statement 32
											ftsfdb.view_sfdc_leads l
										JOIN ftsfdb.view_sfdc_stage_log sl ON
											sl.lead_id__c::text = l.id::text
										LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
											o.id::text = sl.opportunity__c::text
										WHERE
											l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
										GROUP BY
											l.id,
											sl.name,
											sl.createddate) a
									LEFT JOIN (
										SELECT
											l.id,
											sl.name,
											sl.createddate,
											pg_catalog.row_number() OVER( PARTITION BY l.id
										ORDER BY
											sl.createddate) AS stage_rank,
											min(sl.createddate) AS min_created_date
										FROM -- TODO From statement 33
											ftsfdb.view_sfdc_leads l
										JOIN ftsfdb.view_sfdc_stage_log sl ON
											sl.lead_id__c::text = l.id::text
										LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
											o.id::text = sl.opportunity__c::text
										WHERE
											l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
										GROUP BY
											l.id,
											sl.name,
											sl.createddate) b ON
										b.id::text = a.id::text
									WHERE
										a.name::text <> 'Suspect'::character varying::text
										AND a.name::text <> 'Recycled'::character varying::text
										AND a.name::text <> 'Closed Lost'::character varying::text
										AND a.name::text <> 'No Opportunity'::character varying::text
										AND b.name::text <> 'Suspect'::character varying::text
										AND b.name::text <> 'Recycled'::character varying::text
										AND b.name::text <> 'Closed Lost'::character varying::text
										AND b.name::text <> 'No Opportunity'::character varying::text
									GROUP BY
										a.id) e ON
									i.id::text = e.id::text
								GROUP BY
									i.id,
									i.stage_name,
									i.createddate,
									i.min_created_date,
									i.stage_rank,
									i.current_max_stage,
									e.current_max_stage_live) a
							LEFT JOIN (
								SELECT
									a.id,
									a.current_max_stage_timestamp,
									"max"(
									CASE
										WHEN a.current_max_stage_timestamp = a.createddate THEN a.stage_name
										ELSE NULL::character varying
									END::text) AS current_max_stage_name,
									"max"(
									CASE
										WHEN a.current_max_stage_timestamp = a.createddate THEN "left"(a.stage_name::text,
										1)::character varying
										ELSE NULL::character varying
									END::text) AS current_max_stage_number,
									a.last_live_stage_timestamp,
									"max"(
									CASE
										WHEN a.last_live_stage_timestamp = a.createddate THEN a.stage_name
										ELSE NULL::character varying
									END::text) AS last_live_stage_name,
									"max"(
									CASE
										WHEN a.last_live_stage_timestamp = a.createddate THEN "left"(a.stage_name::text,
										1)::character varying
										ELSE NULL::character varying
									END::text) AS last_live_stage_number
								FROM -- TODO From statement 34
									(
									SELECT
										i.id,
										i.stage_name,
										i.createddate,
										i.min_created_date,
										i.stage_rank,
										i.current_max_stage AS current_max_stage_timestamp,
										e.current_max_stage_live AS last_live_stage_timestamp
									FROM -- TODO From statement 35
										(
										SELECT
											a.id,
											CASE
												WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
												WHEN a.name::text = 'Engaged'::character varying::text
													OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
													WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
													WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
													WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
													WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
													WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
													WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
													WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
													WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
													WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
													ELSE a.name
												END AS stage_name,
												a.createddate,
												a.min_created_date,
												a.stage_rank,
												"max"(b.createddate) AS current_max_stage
											FROM -- TODO From statement 36
												(
												SELECT
													l.id,
													sl.name,
													sl.createddate,
													pg_catalog.row_number() OVER( PARTITION BY l.id
												ORDER BY
													sl.createddate) AS stage_rank,
													min(sl.createddate) AS min_created_date
												FROM -- TODO From statement 37
													ftsfdb.view_sfdc_leads l
												JOIN ftsfdb.view_sfdc_stage_log sl ON
													sl.lead_id__c::text = l.id::text
												LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
													o.id::text = sl.opportunity__c::text
												WHERE
													l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
													AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												GROUP BY
													l.id,
													sl.name,
													sl.createddate) a
											LEFT JOIN (
												SELECT
													l.id,
													sl.name,
													sl.createddate,
													pg_catalog.row_number() OVER( PARTITION BY l.id
												ORDER BY
													sl.createddate) AS stage_rank,
													min(sl.createddate) AS min_created_date
												FROM -- TODO From statement 38
													ftsfdb.view_sfdc_leads l
												JOIN ftsfdb.view_sfdc_stage_log sl ON
													sl.lead_id__c::text = l.id::text
												LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
													o.id::text = sl.opportunity__c::text
												WHERE
													l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
													AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												GROUP BY
													l.id,
													sl.name,
													sl.createddate) b ON
												b.id::text = a.id::text
											WHERE
												a.name::text <> 'Suspect'::character varying::text
												AND a.name::text <> 'Recycled'::character varying::text
												AND b.name::text <> 'Suspect'::character varying::text
												AND b.name::text <> 'Recycled'::character varying::text
											GROUP BY
												a.id,
												CASE
													WHEN a.name::text = 'Marketing ready'::character varying::text THEN 'one_marketing_ready_lead'::character varying
													WHEN a.name::text = 'Engaged'::character varying::text
													OR a.name::text = 'Marketing qualified'::character varying::text THEN 'two_marketing_qualified_lead'::character varying
													WHEN a.name::text = 'Sales ready'::character varying::text THEN 'three_sales_ready_lead'::character varying
													WHEN a.name::text = 'Qualified'::character varying::text THEN 'four_converted_to_opp'::character varying
													WHEN a.name::text = 'Discover'::character varying::text THEN 'five_discover'::character varying
													WHEN a.name::text = 'Develop & Prove'::character varying::text THEN 'six_develop_and_prove'::character varying
													WHEN a.name::text = 'Proposal/Negotiation'::character varying::text THEN 'seven_proposal_negotiation'::character varying
													WHEN a.name::text = 'Agree & Close Contract'::character varying::text THEN 'eight_agree_and_close_contract'::character varying
													WHEN a.name::text = 'Closed Won'::character varying::text THEN 'nine_closed_won'::character varying
													WHEN a.name::text = 'Closed Lost'::character varying::text THEN '_closed_lost'::character varying
													WHEN a.name::text = 'No Opportunity'::character varying::text THEN '_no_opportunity'::character varying
													ELSE a.name
												END,
												a.createddate,
												a.min_created_date,
												a.stage_rank) i
									LEFT JOIN (
										SELECT
											a.id,
											"max"(b.createddate) AS current_max_stage_live
										FROM -- TODO From statement 39
											(
											SELECT
												l.id,
												sl.name,
												sl.createddate,
												pg_catalog.row_number() OVER( PARTITION BY l.id
											ORDER BY
												sl.createddate) AS stage_rank,
												min(sl.createddate) AS min_created_date
											FROM -- TODO From statement 40
												ftsfdb.view_sfdc_leads l
											JOIN ftsfdb.view_sfdc_stage_log sl ON
												sl.lead_id__c::text = l.id::text
											LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
												o.id::text = sl.opportunity__c::text
											WHERE
												l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											GROUP BY
												l.id,
												sl.name,
												sl.createddate) a
										LEFT JOIN (
											SELECT
												l.id,
												sl.name,
												sl.createddate,
												pg_catalog.row_number() OVER( PARTITION BY l.id
											ORDER BY
												sl.createddate) AS stage_rank,
												min(sl.createddate) AS min_created_date
											FROM -- TODO From statement 41
												ftsfdb.view_sfdc_leads l
											JOIN ftsfdb.view_sfdc_stage_log sl ON
												sl.lead_id__c::text = l.id::text
											LEFT JOIN ftsfdb.view_sfdc_opportunities o ON
												o.id::text = sl.opportunity__c::text
											WHERE
												l.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
												AND sl.createddate >= '2018-01-01 00:00:00'::timestamp without time zone
											GROUP BY
												l.id,
												sl.name,
												sl.createddate) b ON
											b.id::text = a.id::text
										WHERE
											a.name::text <> 'Suspect'::character varying::text
											AND a.name::text <> 'Recycled'::character varying::text
											AND a.name::text <> 'Closed Lost'::character varying::text
											AND a.name::text <> 'No Opportunity'::character varying::text
											AND b.name::text <> 'Suspect'::character varying::text
											AND b.name::text <> 'Recycled'::character varying::text
											AND b.name::text <> 'Closed Lost'::character varying::text
											AND b.name::text <> 'No Opportunity'::character varying::text
										GROUP BY
											a.id) e ON
										i.id::text = e.id::text
									GROUP BY
										i.id,
										i.stage_name,
										i.createddate,
										i.min_created_date,
										i.stage_rank,
										i.current_max_stage,
										e.current_max_stage_live) a
								GROUP BY
									a.id,
									a.current_max_stage_timestamp,
									a.last_live_stage_timestamp
								ORDER BY
									a.id DESC) b ON
								a.id::text = b.id::text
							GROUP BY
								a.id,
								a.stage_name,
								a.createddate,
								a.min_created_date,
								a.stage_rank,
								a.current_max_stage_timestamp,
								b.current_max_stage_name,
								b.current_max_stage_number,
								b.last_live_stage_timestamp,
								b.last_live_stage_name,
								b.last_live_stage_number
							ORDER BY
								a.id DESC) a
						GROUP BY
							a.id,
							a.stage_name,
							a.stage_number,
							a.createddate,
							a.min_created_date,
							a.stage_rank,
							a.current_max_stage_timestamp,
							a.current_max_stage_name,
							CASE
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 0
								WHEN a.current_max_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
								WHEN a.current_max_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
								WHEN a.current_max_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
								WHEN a.current_max_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
								WHEN a.current_max_stage_name = 'five_discover'::character varying::text THEN 5
								WHEN a.current_max_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
								WHEN a.current_max_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
								WHEN a.current_max_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 9
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 10
								WHEN a.current_max_stage_name = 'Member'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'unknown'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Open'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Marketing qualified'::character varying::text THEN 2
								WHEN a.current_max_stage_name = 'Financial Services'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'Concurrency'::character varying::text THEN 99
								WHEN a.current_max_stage_name = 'clicked'::character varying::text THEN 99
								ELSE NULL::integer
							END,
							a.last_live_stage_timestamp,
							a.last_live_stage_name,
							CASE
								WHEN a.last_live_stage_name = '_no_opportunity'::character varying::text THEN 0
								WHEN a.last_live_stage_name = 'one_marketing_ready_lead'::character varying::text THEN 1
								WHEN a.last_live_stage_name = 'two_marketing_qualified_lead'::character varying::text THEN 2
								WHEN a.last_live_stage_name = 'three_sales_ready_lead'::character varying::text THEN 3
								WHEN a.last_live_stage_name = 'four_converted_to_opp'::character varying::text THEN 4
								WHEN a.last_live_stage_name = 'five_discover'::character varying::text THEN 5
								WHEN a.last_live_stage_name = 'six_develop_and_prove'::character varying::text THEN 6
								WHEN a.last_live_stage_name = 'seven_proposal_negotiation'::character varying::text THEN 7
								WHEN a.last_live_stage_name = 'eight_agree_and_close_contract'::character varying::text THEN 8
								WHEN a.last_live_stage_name = 'nine_closed_won'::character varying::text THEN 9
								WHEN a.last_live_stage_name = '_closed_lost'::character varying::text THEN 10
								WHEN a.last_live_stage_name = 'Member'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'unknown'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Open'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Marketing qualified'::character varying::text THEN 2
								WHEN a.last_live_stage_name = 'Financial Services'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'Concurrency'::character varying::text THEN 99
								WHEN a.last_live_stage_name = 'clicked'::character varying::text THEN 99
								ELSE NULL::integer
							END,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN 'closed_won'::character varying
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN 'closed_lost'::character varying
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN 'no_opportunity'::character varying
								ELSE 'live'::character varying
							END,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_name
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_name
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_name
								ELSE a.current_max_stage_name
							END,
							CASE
								WHEN a.current_max_stage_name = 'nine_closed_won'::character varying::text THEN a.current_max_stage_number
								WHEN a.current_max_stage_name = '_closed_lost'::character varying::text THEN a.last_live_stage_number
								WHEN a.current_max_stage_name = '_no_opportunity'::character varying::text THEN a.last_live_stage_number
								ELSE a.current_max_stage_number
							END
						ORDER BY
							a.id DESC) a
					GROUP BY
						a.id,
						a.current_max_stage_timestamp,
						a.current_max_stage_name,
						a.current_max_stage_no,
						a.last_live_stage_timestamp,
						a.last_live_stage_name,
						a.last_live_stage_no,
						a.lead_status,
						a.lead_status_stage_name,
						a.lead_status_stage_number) a
				GROUP BY
					a.id,
					a.current_max_stage_timestamp,
					a.current_max_stage_name,
					a.current_max_stage_no,
					a.last_live_stage_timestamp,
					a.last_live_stage_name,
					a.last_live_stage_no,
					a.lead_status,
					a.lead_status_stage_name,
					CASE
						WHEN a.one_marketing_ready_lead IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.two_marketing_qualified_lead IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.three_sales_ready_lead IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.four_converted_to_opp IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.five_discover IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.six_develop_and_prove IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.seven_proposal_negotiation IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.eight_agree_and_close_contract IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.nine_closed_won IS NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.one_marketing_ready_lead IS NOT NULL THEN 1
						WHEN a.one_marketing_ready_lead IS NULL
						AND (a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
							OR a.lead_status_stage_name = 'nine_closed_won'::character varying::text
							OR a.lead_status_stage_name = NULL::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 1
						ELSE 0
					END,
					CASE
						WHEN a.two_marketing_qualified_lead IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.two_marketing_qualified_lead IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.three_sales_ready_lead IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.three_sales_ready_lead IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.four_converted_to_opp IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.four_converted_to_opp IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.five_discover IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.five_discover IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.six_develop_and_prove IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.six_develop_and_prove IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.seven_proposal_negotiation IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.seven_proposal_negotiation IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.eight_agree_and_close_contract IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.eight_agree_and_close_contract IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.nine_closed_won IS NULL
						AND a.lead_status_stage_name IS NULL THEN 0
						WHEN a.nine_closed_won IS NULL
						AND (a.lead_status_stage_name = 'one_marketing_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'two_marketing_qualified_lead'::character varying::text
							OR a.lead_status_stage_name = 'three_sales_ready_lead'::character varying::text
							OR a.lead_status_stage_name = 'four_converted_to_opp'::character varying::text
							OR a.lead_status_stage_name = 'five_discover'::character varying::text
							OR a.lead_status_stage_name = 'six_develop_and_prove'::character varying::text
							OR a.lead_status_stage_name = 'seven_proposal_negotiation'::character varying::text
							OR a.lead_status_stage_name = 'eight_agree_and_close_contract'::character varying::text
							OR a.lead_status_stage_name = 'clicked'::character varying::text
							OR a.lead_status_stage_name = 'Member'::character varying::text)
						AND a.last_live_stage_timestamp IS NOT NULL THEN 0
						ELSE 1
					END,
					CASE
						WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.one_marketing_ready_lead
					END,
					CASE
						WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.two_marketing_qualified_lead
					END,
					CASE
						WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
						ELSE a.three_sales_ready_lead
					END,
					CASE
						WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
						ELSE a.four_converted_to_opp
					END,
					CASE
						WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
						ELSE a.five_discover
					END,
					CASE
						WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
						ELSE a.six_develop_and_prove
					END,
					CASE
						WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
						ELSE a.seven_proposal_negotiation
					END,
					CASE
						WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
						ELSE a.eight_agree_and_close_contract
					END,
					CASE
						WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
						ELSE a.nine_closed_won
					END,
					CASE
						WHEN a._closed_lost IS NULL THEN NULL::timestamp without time zone
						ELSE a._closed_lost
					END,
					CASE
						WHEN a._no_opportunity IS NULL THEN NULL::timestamp without time zone
						ELSE a._no_opportunity
					END,
					CASE
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.two_marketing_qualified_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.one_marketing_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.one_marketing_ready_lead
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.two_marketing_qualified_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.two_marketing_qualified_lead
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.three_sales_ready_lead IS NULL THEN NULL::timestamp without time zone
							ELSE a.three_sales_ready_lead
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.four_converted_to_opp IS NULL THEN NULL::timestamp without time zone
							ELSE a.four_converted_to_opp
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.five_discover IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.five_discover IS NULL THEN NULL::timestamp without time zone
							ELSE a.five_discover
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.six_develop_and_prove IS NULL THEN NULL::timestamp without time zone
							ELSE a.six_develop_and_prove
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END - '00:00:01'::interval
						WHEN
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.seven_proposal_negotiation IS NULL THEN NULL::timestamp without time zone
							ELSE a.seven_proposal_negotiation
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN 0
							ELSE 1
						END = 0
						AND
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END - '00:00:01'::interval
						ELSE
						CASE
							WHEN a.eight_agree_and_close_contract IS NULL THEN NULL::timestamp without time zone
							ELSE a.eight_agree_and_close_contract
						END
					END,
					CASE
						WHEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN 0
							ELSE 1
						END <> 0 THEN
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END
						ELSE
						CASE
							WHEN a.nine_closed_won IS NULL THEN NULL::timestamp without time zone
							ELSE a.nine_closed_won
						END
					END) a
		LEFT JOIN ftsfdb.view_sfdc_stage_log b ON
			a.id::text = b.lead_id__c::text
		GROUP BY
			a.id) s
	LEFT JOIN ftsfdb.view_sfdc_leads d ON
		s.id::text = d.id::text
	LEFT JOIN ftsfdb.view_sfdc_users e ON
		d.ownerid::text = e.id::text
	LEFT JOIN ftsfdb.view_sfdc_opportunities c ON
		s.opportunity_c = c.id::text
	LEFT JOIN ftsfdb.view_sfdc_users ee ON
		c.ownerid::text = ee.id::text
	LEFT JOIN (
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
				x.fxrate) vo ON
		s.opportunity_c = vo.opportunity_id::text
	LEFT JOIN (
		SELECT
			t.accountid,
			t.id,
			t.contract_start_year,
			t.amount,
			t.currencyisocode,
			x.fxrate,
			CASE
				WHEN t.currencyisocode::text = 'GBP'::character varying::text THEN t.amount
				ELSE t.amount / x.fxrate
			END AS gbpamount
		FROM -- TODO From statement 44
			(
			SELECT
				view_sfdc_contracts.accountid,
				view_sfdc_contracts.id,
				"date_part"('year'::character varying::text,
				view_sfdc_contracts.startdate) AS contract_start_year,
				view_sfdc_contracts.amount,
				view_sfdc_contracts.currencyisocode
			FROM -- TODO From statement 45
				ftsfdb.view_sfdc_contracts
			WHERE
				view_sfdc_contracts.startdate >= '2018-01-01'::date
			GROUP BY
				view_sfdc_contracts.accountid,
				view_sfdc_contracts.id,
				"date_part"('year'::character varying::text,
				view_sfdc_contracts.startdate),
				view_sfdc_contracts.amount,
				view_sfdc_contracts.currencyisocode) t
		LEFT JOIN dwabstraction.dn_currencyexchangerate x ON
			x.fromcurrency_code = t.currencyisocode::character(3)
				AND x.fxyear = t.contract_start_year
			GROUP BY
				t.accountid,
				t.id,
				t.contract_start_year,
				t.amount,
				t.currencyisocode,
				x.fxrate) vc ON
		c.accountid::text = vc.accountid::text
		AND c.contract::text = vc.id::text
	LEFT JOIN ftsfdb.view_sfdc_contracts h ON
		h.id::text = c.contract::text
	LEFT JOIN ftsfdb.view_sfdc_campaign_segments de ON
		d.segment_id::text = de.segmentid__c::text
	LEFT JOIN ftsfdb.view_sfdc_users f ON
		h.ownerid::text = f.id::text
	LEFT JOIN dwabstraction.dim_country_latest r ON
		lower(r.country_name::text) = lower(d.country::text)
	GROUP BY
		s.id,
		d.leadsource,
		CASE
			WHEN d.leadsource::text = 'Build Batch'::character varying::text THEN 'Build Batch'::character varying
			WHEN d.leadsource::text = 'Build Final'::character varying::text THEN 'Build Final'::character varying
			WHEN d.leadsource::text = 'Client Source Batch'::character varying::text THEN 'Client Source Batch'::character varying
			WHEN d.leadsource::text = 'Client Source Final'::character varying::text THEN 'Client Source Final'::character varying
			WHEN d.leadsource::text = 'B2C-Individual Digital'::character varying::text THEN 'B2C-Individual Digital'::character varying
			WHEN d.leadsource::text = 'Corporate'::character varying::text THEN 'Corporate'::character varying
			WHEN d.leadsource::text = 'Registered'::character varying::text THEN 'Registered'::character varying
			WHEN d.leadsource::text = 'Sales Inside'::character varying::text THEN 'Sales Inside'::character varying
			WHEN d.leadsource::text = '2-9ers'::character varying::text THEN '2-9ers'::character varying
			WHEN d.leadsource::text = 'Agency'::character varying::text THEN 'Agency'::character varying
			WHEN d.leadsource::text = 'API Form'::character varying::text THEN 'API Form'::character varying
			WHEN d.leadsource::text = 'Bloomberg Leads'::character varying::text THEN 'Bloomberg'::character varying
			WHEN d.leadsource::text = 'Bloomberg Terminal'::character varying::text THEN 'Bloomberg'::character varying
			WHEN d.leadsource::text = 'Channel Partner'::character varying::text THEN 'Channel Partner'::character varying
			WHEN d.leadsource::text = 'Channel Referral'::character varying::text THEN 'Channel Referral'::character varying
			WHEN d.leadsource::text = 'Contact sales form'::character varying::text THEN 'Contact sales form'::character varying
			WHEN d.leadsource::text = 'Contact support form'::character varying::text THEN 'Contact support form'::character varying
			WHEN d.leadsource::text = 'Contact Us Form'::character varying::text THEN 'Contact Us Form'::character varying
			WHEN d.leadsource::text = 'Concurrency'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Copyright'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Email Forwarding'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Generic Email Address'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Overcopying'::character varying::text THEN 'Copyright'::character varying
			WHEN d.leadsource::text = 'Corporate Blog Subscriber'::character varying::text THEN 'Corporate Blog Subscriber'::character varying
			WHEN d.leadsource::text = 'Current Client'::character varying::text THEN 'Current Client'::character varying
			WHEN d.leadsource::text = 'Customer Referral'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Existing Client'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Existing Customer'::character varying::text THEN 'Customer Referral'::character varying
			WHEN d.leadsource::text = 'Case Study Download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'Document Download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'FTCorporate asset download'::character varying::text THEN 'Document Download'::character varying
			WHEN d.leadsource::text = 'Email Enquiry'::character varying::text THEN 'Email Enquiry'::character varying
			WHEN d.leadsource::text = 'Event'::character varying::text THEN 'Event'::character varying
			WHEN d.leadsource::text = 'FT Event'::character varying::text THEN 'Event'::character varying
			WHEN d.leadsource::text = 'Free Trial Form'::character varying::text THEN 'Free Trial Form'::character varying
			WHEN d.leadsource::text = 'FT Confidential Research'::character varying::text THEN 'FT Confidential Research'::character varying
			WHEN d.leadsource::text = 'FT Content'::character varying::text THEN 'FT Content'::character varying
			WHEN d.leadsource::text = 'FT Dept Referral'::character varying::text THEN 'FT Dept Referral'::character varying
			WHEN d.leadsource::text = 'FT Referral'::character varying::text THEN 'FT Referral'::character varying
			WHEN d.leadsource::text = 'FT.com'::character varying::text THEN 'FT.com'::character varying
			WHEN d.leadsource::text = 'Google Research'::character varying::text THEN 'Google Research'::character varying
			WHEN d.leadsource::text = 'Telephone Research'::character varying::text THEN 'Google Research'::character varying
			WHEN d.leadsource::text = 'Industry Contacts'::character varying::text THEN 'Industry Contacts'::character varying
			WHEN d.leadsource::text = 'Lighthouse'::character varying::text THEN 'Lighthouse'::character varying
			WHEN d.leadsource::text = 'Salesforce'::character varying::text THEN 'Lighthouse'::character varying
			WHEN d.leadsource::text = 'Linkedin Ads'::character varying::text THEN 'LinkedIn Ads'::character varying
			WHEN d.leadsource::text = 'LinkedIn Research'::character varying::text THEN 'LinkedIn Research'::character varying
			WHEN d.leadsource::text = 'Linkedin Search'::character varying::text THEN 'LinkedIn Research'::character varying
			WHEN d.leadsource::text = 'Manila'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Reseach'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Reseacrh'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Manila Research'::character varying::text THEN 'Manila Research'::character varying
			WHEN d.leadsource::text = 'Phone Enquiry'::character varying::text THEN 'Phone Enquiry'::character varying
			WHEN d.leadsource::text = 'Print Customer'::character varying::text THEN 'Print Customer'::character varying
			WHEN d.leadsource::text = 'Secondary Schools'::character varying::text THEN 'Secondary Schools'::character varying
			WHEN d.leadsource::text = 'Syndication Sales Plan'::character varying::text THEN 'Syndication'::character varying
			WHEN d.leadsource::text = 'Telephone Prospecting'::character varying::text THEN 'Telephone Prospecting'::character varying
			WHEN d.leadsource::text = 'List Research (Company)'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Marketing/Third Party List'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Merit Data'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Merit Research'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Scout'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party Data'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party List'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Third Party Research'::character varying::text THEN 'Third Party'::character varying
			WHEN d.leadsource::text = 'Default - Please update'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Government Intelligence Digest'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'http://thefinlab.com/'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Other'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Republishing Africa'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Restoring Client Trust Report'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'SFDC-IN|Financial Times News Feed'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Unknown'::character varying::text THEN 'Unknown'::character varying
			WHEN d.leadsource::text = 'Web chat'::character varying::text THEN 'Web Chat'::character varying
			ELSE 'Unknown'::character varying
		END,
		d.industry_sector,
		d.segment_id,
		de.marketing_campaign__r_name,
		d.spoor_id,
		d.createdbyid,
		d.ownerid,
		(e.firstname::text || ' '::character varying::text) || e.lastname::text,
		e.team,
		r.b2b_sales_region,
		r.b2b_sales_subregion,
		d.country,
		d.gclid,
		d.cpccampaign,
		s.opportunity_c,
		c.ownerid,
		(ee.firstname::text || ' '::character varying::text) || ee.lastname::text,
		ee.team,
		vo.gbpamount,
		c.closed_lost_reason,
		c.closedate,
		c."type",
		vc.gbpamount,
		h.startdate,
		h.total_core_readers,
		h.total_licenced_readers,
		h.licencetype,
		h.licencee_name,
		h.licence_solution,
		h."type",
		h.ownerid,
		(f.firstname::text || ' '::character varying::text) || f.lastname::text,
		f.team,
		h.client_type,
		h.contractnumber,
		h.contractnumber_c) b ON
	a.id::text = b.lead_id::text
LEFT JOIN (
	SELECT
		df.spoor_id,
		v.campaign_id AS visit_segment_id,
		"max"(cs.marketing_campaign__r_name::text) AS visit_marketing_campaign_name
	FROM -- TODO From statement 46
		ftsfdb.view_sfdc_leads df
	LEFT JOIN biteam.conversion_visit c ON
		df.spoor_id::text = c.device_spoor_id::text
		AND c.system_action::text = 'b2b-confirmed'::character varying::text
	LEFT JOIN ftspoordb.visits v ON
		c.conversion_visit_id = v.visit_id
		AND v.start_dtm >= '2018-01-01 00:00:00'::timestamp without time zone
	LEFT JOIN ftsfdb.sfdc_campaign_segments_cdc cs ON
		v.campaign_id::text = cs.segmentid__c::text
	GROUP BY
		df.spoor_id,
		v.campaign_id) c ON
	b.lead_spoor_id::text = c.spoor_id::text
WHERE original_lead_source NOT IN ('Secondary Schools', 'API Form', 'Agency', 'Unknown')
AND original_lead_source IN ('Channel Referral', 'Contact Us Form'
                              , 'Customer Referral', 'Email Enquiry'
                              , 'Free Trial Request Form', 'FT Dept Referral'
                              , 'Online Order Form', 'Phone Enquiry', 'Web chat')
AND lead_owner_name IN (
                        'Alexander Anderson',
                        'Sadie Lee',
                        'Hannah Grace Llapitan',
                        'Pippa Langan',
                        'Gavin Crangle',
                        'Matthew Xia',
                        'Mckenna Sweazey',
                        'Sue Cassidy',
                        'Daisy Simpson-Crew',
                        'Tamsin Grosvenor',
                        'Mary Jane Guzman',
                        'Philippa Payne',
                        'Gemma Watts',
                        'Paula Zimmer',
                        'Alex Isiguen',
                        'Emily Benson',
                        'Laura Serrato'
)
GROUP BY
	a.id,
	a.current_max_stage_timestamp,
	a.current_max_stage_name,
	a.current_max_stage_number,
	a.last_live_stage_timestamp,
	a.last_live_stage_name,
	a.last_live_stage_number,
	a.lead_status,
	a.lead_status_stage_name,
	a.one_marketing_ready_lead_pre,
	a.two_marketing_qualified_lead_pre,
	a.three_sales_ready_lead_pre,
	a.four_converted_to_opp_pre,
	a.five_discover_pre,
	a.six_develop_and_prove_pre,
	a.seven_proposal_negotiation_pre,
	a.eight_agree_and_close_contract_pre,
	a.nine_closed_won_pre,
	a.one_marketing_ready_lead,
	a.two_marketing_qualified_lead,
	a.three_sales_ready_lead,
	a.four_converted_to_opp,
	a.five_discover,
	a.six_develop_and_prove,
	a.seven_proposal_negotiation,
	a.eight_agree_and_close_contract,
	a.nine_closed_won,
	a.one_marketing_ready_lead_pre_timestamp,
	a.two_marketing_qualified_lead_pre_timestamp,
	a.three_sales_ready_lead_pre_timestamp,
	a.four_converted_to_opp_pre_timestamp,
	a.five_discover_pre_timestamp,
	a.six_develop_and_prove_pre_timestamp,
	a.seven_proposal_negotiation_pre_timestamp,
	a.eight_agree_and_close_contract_pre_timestamp,
	a.nine_closed_won_pre_timestamp,
	a._closed_lost,
	a._no_opportunity,
	a.one_marketing_ready_lead_add,
	a.two_marketing_qualified_lead_add,
	a.three_sales_ready_lead_add,
	a.four_converted_to_opp_add,
	a.five_discover_add,
	a.six_develop_and_prove_add,
	a.seven_proposal_negotiation_add,
	a.eight_agree_and_close_contract_add,
	a.nine_closed_won_add,
	b.lead_id,
	b.original_lead_source,
	b.adjusted_lead_source,
	b.lead_industry_sector,
	b.salesforce_lead_segment_id,
	b.salesforce_lead_segment_id_name,
	b.lead_spoor_id,
	b.createdbyid,
	b.lead_owner_id,
	b.lead_owner_name,
	b.lead_owner_team,
	b.lead_region,
	b.lead_subregion,
	b.lead_country,
	b.lead_gclid,
	b.lead_cpc,
	b.oppo_id,
	b.oppo_owner_id,
	b.oppo_owner_name,
	b.oppo_owner_team,
	b.oppo_amount_gbp,
	b.oppo_closed_lost_reason,
	b.oppo_closed_date,
	b.oppo_product_name,
	b.contract_amount_gbp,
	b.contract_start_date,
	b.contract_total_core_readers,
	b.contract_total_licenced_readers,
	b.contract_licence_type,
	b.contract_licence_name,
	b.contract_licence_solution,
	b.contract_type,
	b.contract_owner_id,
	b.contract_owner_name,
	b.contract_owner_team,
	b.client_type,
	b.contractnumber,
	b.sf_contract_number,
	c.spoor_id,
	c.visit_segment_id,
	c.visit_marketing_campaign_name;

--CALL bilayer.sp_give_to_schema_owner('biteam', 'funnels_b2b_nnb_2021');
GRANT ALL ON biteam.funnels_b2b_nnb_2021 to group biteam;