CREATE OR REPLACE PROCEDURE test()
AS $$
BEGIN
  EXECUTE ' SELECT 1 AS a';
END;
$$
LANGUAGE plpgsql
;

CALL test();

--use this to create stored procedure
with a as (
select 'stg_step_up_b2c_zuora_daily' as tbl_name
)
select t.table_schema as schema_name,
       t.table_name as view_name,
       c.column_name,
       case when data_type like '%character%' or data_type like '%text%' then 'String'
       	    when data_type = 'boolean' then 'Boolean'
       	    when data_type in ('integer', 'smallint') then 'Integer'
       	    when data_type in ('numeric') then 'Float'
       	    when data_type like '%timestamp%' then 'Timestamp'
       else 'change me' end AS data_type_adjusted,
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
where --table_type = 'VIEW'
       t.table_schema  not in ('information_schema', 'pg_catalog')
      and t.table_name in (select tbl_name from a ) -- CHANGE VIEW NAME
order by c.ordinal_position asc
;

-- this works!!!
DROP PROCEDURE get_region (region IN varchar, temptable IN varchar(256));


CREATE OR REPLACE PROCEDURE get_region (region IN varchar, temptable IN varchar(256))
AS $$
DECLARE
  sql_statement varchar(max);
BEGIN


  sql_statement := 'create table #' + temptable +  ' as (SELECT *
FROM biteam.stg_step_up_b2c_zuora_daily where region = ' + QUOTE_LITERAL(region) + ')';
  EXECUTE 'drop table if exists #' + temptable;
  EXECUTE sql_statement;

END;
$$ LANGUAGE plpgsql;

BEGIN;
	CALL get_region('APAC', 'mytemptable');
	SELECT * FROM #mytemptable;
END;