-- to check individual users
SELECT
arrangementevent_dtm
, to_termstart_dtm
, to_end_dtm
, to_renewal_dtm
, arrangementevent_name
, to_arrangementtype_name
, to_arrangementlength_id
, to_arrangementproduct_name
, to_arrangementproduct_type -- print or digital or bundle
, to_offer_price
, to_priceinctax
--*
FROM dwabstraction.dn_arrangementevent_all
WHERE user_dkey = 389
ORDER BY arrangementevent_dtm

----
-- one line per customer per day

-- 001702c0-afb6-4c64-9779-94cd106d4884 - has two entries for 23-04-2021
-- checking for null values in specific 'important columns'