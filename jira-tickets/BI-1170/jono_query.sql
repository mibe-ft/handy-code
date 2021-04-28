-- get latest status per arrangement per day
-- person may have multiple changes in one day, we want to filter for the latest change 

-- this is in bigquery
SELECT
    DATE(ae.arrangementevent_dtm) AS day,
    ae.arrangement_id_dd,
    ae.arrangementevent_dtm,
    ROW_NUMBER() OVER(PARTITION BY ae.arrangement_id_dd, DATE(ae.arrangementevent_dtm) ORDER BY ae.event_seq_no DESC, ae.arrangementevent_dtm DESC) AS row_num
FROM
    `ft-data.dwpresentation.vw_nopii_dn_arrangementevent_all` ae