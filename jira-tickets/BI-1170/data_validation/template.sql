INSERT INTO biteam.stg_step_up_b2c_zuora_daily VALUES
{%- for ft_user_id, arrangement_id,	date_,	print_or_digital,	current_price,	current_offer,	current_offer_id,	region,	currency_code,	product_name,	product_name_adjusted,	product_term_adjusted,	step_up_price,	step_up_offer_id,	step_up_percent_discount,	is_standard_plus,	is_cancelled,	has_cancel_request,	is_renewal,	is_eligible_for_step_up,	days_until_anniversary,	is_control,	renewal_step_up,	email_id,	email_type_description,	send_comms in test_data %}
    ('{{ft_user_id}}',	{{arrangement_id}},	'{{date_}}',	'{{print_or_digital}}',	{{current_price}},	'{{current_offer}}',	'{{current_offer_id}}',	'{{region}}',	'{{currency_code}}',	'{{product_name}}',	'{{product_name_adjusted}}',	'{{product_term_adjusted}}',	{{step_up_price}},	'{{step_up_offer_id}}',	{{step_up_percent_discount}},	{{is_standard_plus}},	{{is_cancelled}},	{{has_cancel_request}},	{{is_renewal}},	{{is_eligible_for_step_up}},	{{days_until_anniversary}},	{{is_control}},	'{{renewal_step_up}}',	{{email_id}},	'{{email_type_description}}',	{{send_comms}})
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;
