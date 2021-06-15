with a as (
select 'vw_step_up_b2c_zuora' as tbl_name
)
select t.table_schema as schema_name,
       t.table_name as view_name,
       c.column_name,
       c.data_type,
       c.ordinal_position,
       case when c.character_maximum_length is not null
            then c.character_maximum_length
            else c.numeric_precision end as max_length,
       is_nullable
from information_schema.tables t
join information_schema.columns c
              on t.table_schema = c.table_schema
              and t.table_name = c.table_name
where table_type = 'VIEW'
      and t.table_schema  not in ('information_schema', 'pg_catalog')
      and t.table_name in (select tbl_name from a ) -- CHANGE VIEW NAME
order by c.ordinal_position asc
;
