rem ********************************************************************
rem * Filename          : db_logicrd.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 26-jun-01
rem * Last Update       :  
rem * Update            :  
rem * Description       : Monitor database expensive sql
rem * Usage             : start db_logicrd.sql
rem ********************************************************************

set lines 255
set pages 60

accept lr number prompt 'Logical reads (500000) '

break on buffer_gets on executions on rows_processed skip 1

col logical format 99,999,999 heading "Lg. reads"
col rowproc format 99,999,999 heading "Rows proc."
col exec format 9,999,999 heading "Exec"
col sql_text format a40 heading "SQL Text"

select sql_text, 
       rows_processed rowproc, 
       buffer_gets logical,
       executions exec
from v$sqlarea
where buffer_gets > decode(&&lr,0,50000,&&lr)
and   buffer_gets / decode(rows_processed,0,1,rows_processed) > 50
order by buffer_gets / decode(rows_processed,0,1,rows_processed) desc
/

