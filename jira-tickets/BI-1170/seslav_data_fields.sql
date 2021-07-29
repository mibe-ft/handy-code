, email as email_address
, initcap(to_char(date_, 'month')) as step_up_month
, to_offer_main_product_name as subs_product
, to_offer_main_product_code as product
--, last_display_price
--, next_display_price
--, last_system_price
--, next_system_price
, product_term_adjusted as subs_term
--, creative_code
--, batch_week
, title
, first_name as firstname
, last_name as surname
--, username
, country_code as current_country_name
--, current_price_offer_code
--, next_price_offer_code
--, next_display_price_weekly
--, 6am_cut_subs_price
, campaigns_region as campaign_region
, industry_name as industry
--, erights_id
--, ft_user_guid
--, new_offer_id -- step up