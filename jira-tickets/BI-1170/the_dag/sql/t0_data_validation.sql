WITH checks_ AS(
SELECT CASE WHEN MAX(DATE(dw_inserted_date)) = DATE(CURRENT_DATE) THEN 1 ELSE 0 END AS check_
FROM dwabstraction.dn_arrangementevent_all

UNION ALL

SELECT CASE WHEN MAX(DATE(dw_inserted_date)) = DATE(CURRENT_DATE) THEN 1 ELSE 0 END AS check_
FROM dwabstraction.fact_userstatus
)

SELECT MIN(check_)
FROM checks_
