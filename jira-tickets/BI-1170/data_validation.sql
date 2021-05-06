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
-- one line per ft-user per arrangement id per day
SELECT ft_user_guid
, arrangement_id_dd
, date_
, COUNT(DISTINCT date_) count_of_date
FROM dataset
GROUP BY 1,2,3
HAVING count_of_date > 1
-- limit 1 -- if 1st row > 1 then fail check

-- 001702c0-afb6-4c64-9779-94cd106d4884 - has two entries for 23-04-2021
-- checking for null values in specific 'important columns'

--todo create count of unique users and unique arrangements
select count(distinct ft_user_id) count_users, count(distinct arrangement_id_dd) count_arrangements
from final_tbl
-- 209,529 users, 210,255 - 20210423
-- 208,340 users, 209,059 - 20210505

-- check final data set has no dupes
SELECT 
arrangement_id_dd
, count(arrangement_id_dd)
FROM final_tbl
group by 1 
having count(arrangement_id_dd) > 1