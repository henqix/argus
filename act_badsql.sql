rem ********************************************************************
rem * Filename          : avt_badsql.sql - Version 2.1
rem * Author            : Henk Uiterwijk
rem * Original          : 06-mar-00
rem * Update            : Information retrieved from v$sqlarea (05/01/01)
rem * Update            : Rows Processed and Optim. mode added (14/08/02)
rem * Description       : Monitor database bad sql
rem * Usage             : start act_badsql.sql
rem ********************************************************************

set lines 132
set pages 60

accept dr number prompt 'Disk reads (50000) '

break on disk_reads on buffer_gets on executions on hitratio skip 1

col logical format 9,999,999,999 heading "Lg. reads"
col physical format 9,999,999,999 heading "Ph. reads"
col hitratio format 99.99 heading "Hrt"
col exec format 9,999,999 heading "Exec"
col rowproc format 9,999,999 heading "Rows proc."
col sql_text format a40 heading "SQL Text"

select sql_text||'---'||optimizer_mode sql_text, 
       disk_reads physical, 
       buffer_gets logical,
       executions exec,
       rows_processed rowproc,
       address,
       (1 - (disk_reads / buffer_gets)) * 100 hitratio
from v$sqlarea
where disk_reads > decode(&&dr,0,500000,&&dr)
order by hitratio desc
/

