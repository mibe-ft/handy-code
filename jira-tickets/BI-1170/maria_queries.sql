-- query from Maria initial to join tables
-- this uses arrangementevent_all and not arrangement_all
select distinct fu.ft_user_id as user_guid
, userstatus_dtm
, arrangementeventdate_dkey
, case when is_print then 'Print' else 'Digital' end print_digital
, daa.b2c_marketing_region
, daa.to_arrangementtype_name
, daa.to_arrangementlength_id
from dwabstraction.fact_userstatus fu
join  dwabstraction.dn_arrangementevent_all daa
    on fu.user_dkey = daa.user_dkey
    and fu.userstatus_date_dkey >= daa.arrangementeventdate_dkey
WHERE  daa.to_datasource_dkey = 2 -- Zuora
    and fu.is_b2c is true

-- maria new query
with eventdates as
(
    select ft_user_id, arrangementeventdate_dkey fromdate,
        nvl(lead(arrangementeventdate_dkey) over (partition by ft_user_id order by arrangementevent_dtm asc),'99991231') todate,
        arrangementeventdate_dkey, b2c_marketing_region, to_arrangementproduct_name, to_arrangementlength_id, user_dkey
    from dwabstraction.dn_arrangementevent_all daa
    where arrangementeventdate_dkey >= 20170101  -- min date in fact user status. Have to ask about how long we want to
