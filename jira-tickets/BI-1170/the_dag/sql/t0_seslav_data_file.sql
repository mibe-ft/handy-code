SELECT
	  email_address
	, step_up_month
	, subs_product
	, product
	--, last_display_price
	--, next_display_price
	--, last_system_price
	--, next_system_price
	, subs_term
	--, creative_code
	--, batch_week
	, title
	, firstname
	, surname
	--, username
	, current_country_name
	--, current_price_offer_code
	--, next_price_offer_code
	--, next_display_price_weekly
	--, 6am_cut_subs_price
	, campaign_region
	, industry
	--, erights_id
	--, ft_user_guid
	--, new_offer_id -- step up
FROM biteam.vw_step_up_b2c_zuora
