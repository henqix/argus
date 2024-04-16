rem ********************************************************************
rem * Filename          : db_sqlplan.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show SQL plan baselines for statement
rem ********************************************************************

set lines 132
set pages 60

set feedback off

select SQL_ID, HASH_VALUE, PLAN_HASH_VALUE, SQL_TEXT, EXECUTIONS
from v$sql
where sql_text like '%&&sql_string%'
/
 
select
   s.sql_id,
   s.plan_hash_value,
   s.sql_text,
   b.plan_name,
   b.origin,
   b.accepted
from
   dba_sql_plan_baselines b,
   v$sql s
where
   s.exact_matching_signature = b.signature
and
   s.sql_plan_baseline = b.plan_name
and
   s.sql_text like '%&&sql_string%'
/

select lpad(' ',2*level)||operation||' '||options||' '||object_name
       ||'      --cost '||cost||'   --bytes '||bytes||'   --cardinality '||cardinality query_plan
from (select *
      from DBA_ADVISOR_SQLPLANS
where SQL_ID = (select s.sql_id
from
   dba_sql_plan_baselines b,
   v$sql s
where
   s.exact_matching_signature = b.signature
and
   s.sql_plan_baseline = b.plan_name
and
   s.sql_text like '%&&sql_string%'))
connect by prior id = parent_id
start with id = 0
order by id
/

select * from v$sql_cs_histogram
where sql_id = (select s.sql_id
from
   dba_sql_plan_baselines b,
   v$sql s
where
   s.exact_matching_signature = b.signature
and
   s.sql_plan_baseline = b.plan_name
and
   s.sql_text like '%&&sql_string%')
/

select * from v$sql_cs_statistics
where sql_id = (select s.sql_id
from
   dba_sql_plan_baselines b,
   v$sql s
where
   s.exact_matching_signature = b.signature
and
   s.sql_plan_baseline = b.plan_name
and
   s.sql_text like '%&&sql_string%')
/

undefine sql_string

