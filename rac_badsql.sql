rem ********************************************************************
rem * Filename          : rac_badsql.sql - Version 2.1
rem * Author            : Henk Uiterwijk
rem * Original          : 06-mar-00
rem * Update            : Information retrieved from v$sqlarea (05/01/01)
rem * Update            : Rows Processed and Optim. mode added (14/08/02)
rem * Description       : Monitor database bad sql in RAC cluster
rem ********************************************************************

set pages 60
set lines 132

accept dr number prompt 'Disk reads (1000000) '

break on disk_reads on buffer_gets on executions on hitratio skip 1

col logical format 9,999,999,999 heading "Lg. reads"
col physical format 9,999,999,999 heading "Ph. reads"
col hitratio format 99.99 heading "Hrt"
col exec format 9,999,999 heading "Exec"
col rowproc format 9,999,999 heading "Rows proc."
col sql_text format a40 heading "SQL Text"
col instid format a02

select substr(inst_id,1,2) instid,
       sql_text||'---'||optimizer_mode sql_text, 
       disk_reads physical, 
       buffer_gets logical,
       executions exec,
       rows_processed rowproc,
       address,
       (1 - (disk_reads / buffer_gets)) * 100 hitratio
from   gv$sqlarea
where  disk_reads > decode(&&dr,0,1000000,&&dr)
order by hitratio desc
/

