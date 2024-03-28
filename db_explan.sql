rem ********************************************************************
rem * Filename          : db_explan.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 21-feb-94
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database explain plan
rem * Usage             : start db_explan.sql
rem ********************************************************************

set lines 132
set pages 60

select lpad(' ',2*level)||operation||' '||options||' '||object_name 
       ||'      --cost '||cost||'   --bytes '||bytes||'   --cardinality '||cardinality query_plan
--     ||'-- cpu '||cpu_cost||'-- i/o '||io_cost query_plan
from plan_table
connect by prior id = parent_id
start with id = 1
/

