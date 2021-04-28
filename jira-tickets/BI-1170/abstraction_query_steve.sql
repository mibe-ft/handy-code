-- 767 records 1m 6s
-- 767 records in 1m 15s
SELECT distinct  s.name subscription_id,
      dwabstraction.dn_arrangementevent_all.ft_user_id,
      TRUNC(dwabstraction.dn_arrangementevent_all.start_dtm) maxstartdate,
      Case WHEN TRUNC(dwabstraction.dn_arrangementevent_all.to_cancel_dtm) IS NULL 
      THEN TRUNC(dwabstraction.dn_arrangementevent_all.to_end_dtm) 
      ELSE TRUNC(dwabstraction.dn_arrangementevent_all.to_cancel_dtm) end as last_end_date,
      TRUNC(dwabstraction.dn_arrangementevent_all.to_cancel_dtm) cancel_date,
      dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name subtype,
      dwabstraction.dn_arrangementevent_all.to_offer_name,
      dwabstraction.dn_arrangementevent_all.to_period_length,
      dwabstraction.dn_arrangementevent_all.to_number_of_periods,
      dwabstraction.dn_arrangementevent_all.to_priceinctax,
      dwabstraction.dn_arrangementevent_all.to_pricegbpinctax,
      dwabstraction.dn_arrangementevent_all.to_currency_code currency_code,
      case when dwabstraction.dim_country.b2c_marketing_region = 'Americas' then 'US'
        else dwabstraction.dim_country.b2c_marketing_region
        end as Region,
      dwabstraction.dn_arrangementevent_all.country_name,
      case when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Newspaper - Weekend Only' then 'Weekend Only'
             when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Newspaper - 6 Days a week' then 'Combination'
             when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Newspaper - 5 weekdays' then 'Weekday Only'
             when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Premium FT.com with Newspaper - 6 Days a week' then 'Combination'
             when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Premium FT.com with Newspaper - 5 weekdays' then 'Weekday Only'
             when dwabstraction.dn_arrangementevent_all.to_arrangementproduct_name = 'Premium FT.com with Newspaper - Weekend Only' then 'Weekend Only'
                 else 'None'
                 end as Delivery_Type,
                 
        case when dwabstraction.dn_arrangementevent_all.to_is_trial = 'TRUE' then 'Trial'
        when dwabstraction.dn_arrangementevent_all.to_is_trial_conversion = 'TRUE' then 'Trial Conversion'   
                 else 'Sub'
                 end as Sub_Trial

FROM dwabstraction.dn_arrangementevent_all
LEFT JOIN ftzuoradb.subscription_cdc s ON dwabstraction.dn_arrangementevent_all.to_source_id_dd = s.subscriptionid
LEFT JOIN ftzuoradb.account_cdc a ON s.accountid = a.accountid
LEFT JOIN ftzuoradb.paymentmethod_cdc p ON s.accountid = p.accountid
LEFT JOIN ftzuoradb.invoiceitem_cdc ON ftzuoradb.invoiceitem_cdc.subscriptionid = dwabstraction.dn_arrangementevent_all.to_source_id_dd
LEFT JOIN dwabstraction.lkp_arrangement l ON l.zuoraid = dwabstraction.dn_arrangementevent_all.to_source_id_dd
LEFT JOIN dwabstraction.dim_country ON dwabstraction.dim_country.country_code = dwabstraction.dn_arrangementevent_all.country_code
WHERE dwabstraction.dn_arrangementevent_all.to_arrangementproduct_type IN ('Digital')
  AND ftzuoradb.invoiceitem_cdc.dw_latest = true
  AND dwabstraction.dn_arrangementevent_all.is_latest_event = true
  AND a.dw_latest = true
  AND ftzuoradb.invoiceitem_cdc.dw_latest = true
  AND dwabstraction.dn_arrangementevent_all.to_end_dtm >= '01-jun-2020'
ORDER BY TRUNC(dwabstraction.dn_arrangementevent_all.to_termstart_dtm)
