rem ********************************************************************
rem * Filename          : db_hispln.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 21-sep-12
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database explain plan (history)
rem * Usage             : start db_hispln.sql
rem ********************************************************************

set liones 132
set pages 60

select lpad(' ',2*level)||operation||' '||options||' '||object_name
       ||'      --cost '||cost||'   --bytes '||bytes||'   --cardinality '||cardinality query_plan
from (select *
      from DBA_HIST_SQL_PLAN
      where PLAN_HASH_VALUE = &plan_hash
      and SQL_ID = '&plan_id')
connect by prior id = parent_id
start with id = 0
order by id
/

