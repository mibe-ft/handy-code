--DROP TABLE IF EXISTS biteam.step_up_b2c_zuora_daily;-- TODO Uncomment if necessary
CREATE TABLE biteam.step_up_b2c_zuora_daily (
	  ft_user_id CHAR(36) NOT NULL
	, arrangement_id INTEGER
	, date_ TIMESTAMP
	, print_or_digital VARCHAR
	, current_price NUMERIC(20,4)
	, current_offer VARCHAR
	, current_offer_id VARCHAR
	, region VARCHAR
	, currency_code CHAR(3)
	, product_name VARCHAR
	, product_name_adjusted VARCHAR
	, product_term_adjusted VARCHAR
	, step_up_price NUMERIC(20,4)
	, step_up_offer_id VARCHAR
	, step_up_percent_discount NUMERIC(10,2)
	, is_standard_plus BOOLEAN
	, is_cancelled BOOLEAN
	, has_cancel_request BOOLEAN
	, is_renewal BOOLEAN
	, is_eligible_for_step_up BOOLEAN
	, days_until_anniversary SMALLINT
	, is_control BOOLEAN
	, renewal_step_up VARCHAR
	, email_id SMALLINT
	, email_type_description VARCHAR
	, send_comms BOOLEAN

);

--DROP TABLE IF EXISTS biteam.stg_step_up_b2c_zuora_daily; -- TODO Uncomment if necessary
CREATE TABLE biteam.stg_step_up_b2c_zuora_daily (
	  ft_user_id CHAR(36) NOT NULL
	, arrangement_id INTEGER
	, date_ TIMESTAMP
	, print_or_digital VARCHAR
	, current_price NUMERIC(20,4)
	, current_offer VARCHAR
	, current_offer_id VARCHAR
	, region VARCHAR
	, currency_code CHAR(3)
	, product_name VARCHAR
	, product_name_adjusted VARCHAR
	, product_term_adjusted VARCHAR
	, step_up_price NUMERIC(20,4)
	, step_up_offer_id VARCHAR
	, step_up_percent_discount NUMERIC(10,2)
	, is_standard_plus BOOLEAN
	, is_cancelled BOOLEAN
	, has_cancel_request BOOLEAN
	, is_renewal BOOLEAN
	, is_eligible_for_step_up BOOLEAN
	, days_until_anniversary SMALLINT
	, is_control BOOLEAN
	, renewal_step_up VARCHAR
	, email_id SMALLINT
	, email_type_description VARCHAR
	, send_comms BOOLEAN

);

DROP TABLE IF EXISTS biteam.step_up_b2c_zuora_daily_control_group;
CREATE TABLE biteam.step_up_b2c_zuora_daily_control_group (
      ft_user_id CHAR(36) NOT NULL
    , arrangement_id INTEGER
    , date_ TIMESTAMP
    , step_up_month VARCHAR
    , print_or_digital VARCHAR
    , current_price NUMERIC(20,4)
    , current_offer VARCHAR
    , current_offer_id VARCHAR
    , marketing_region VARCHAR
    , currency_code CHAR(3)
    , product_name VARCHAR
    , product_name_adjusted VARCHAR
    , product_term_adjusted VARCHAR
    , step_up_price NUMERIC(20,4)
    , step_up_offer_id VARCHAR
    , step_up_percent_discount NUMERIC(10,2)
    , is_standard_plus BOOLEAN
    , is_cancelled BOOLEAN
    , has_cancel_request BOOLEAN
    , is_renewal BOOLEAN
    , is_eligible_for_step_up BOOLEAN
    , days_until_anniversary SMALLINT
    , email_address VARCHAR
    , subs_product VARCHAR
    , product VARCHAR
    , title VARCHAR
    , firstname VARCHAR
    , surname VARCHAR
    , current_country_name VARCHAR
    , campaign_region VARCHAR
    , industry VARCHAR
    , subs_term VARCHAR
);

DROP TABLE IF EXISTS biteam.stg_step_up_b2c_zuora_daily_control_group;
CREATE TABLE biteam.stg_step_up_b2c_zuora_daily_control_group (
      ft_user_id CHAR(36) NOT NULL
    , arrangement_id INTEGER
    , date_ TIMESTAMP
    , step_up_month VARCHAR
    , print_or_digital VARCHAR
    , current_price NUMERIC(20,4)
    , current_offer VARCHAR
    , current_offer_id VARCHAR
    , marketing_region VARCHAR
    , currency_code CHAR(3)
    , product_name VARCHAR
    , product_name_adjusted VARCHAR
    , product_term_adjusted VARCHAR
    , step_up_price NUMERIC(20,4)
    , step_up_offer_id VARCHAR
    , step_up_percent_discount NUMERIC(10,2)
    , is_standard_plus BOOLEAN
    , is_cancelled BOOLEAN
    , has_cancel_request BOOLEAN
    , is_renewal BOOLEAN
    , is_eligible_for_step_up BOOLEAN
    , days_until_anniversary SMALLINT
    , email_address VARCHAR
    , subs_product VARCHAR
    , product VARCHAR
    , title VARCHAR
    , firstname VARCHAR
    , surname VARCHAR
    , current_country_name VARCHAR
    , campaign_region VARCHAR
    , industry VARCHAR
    , subs_term VARCHAR
);