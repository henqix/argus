rem ********************************************************************
rem * Filename          : dsk_expread.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 26-sep-01
rem * Last Update       :  
rem * Update            :  
rem * Description       : Monitor database expensive physical reads
rem * Usage             : start dsk_expread.sql
rem ********************************************************************

set lines 255
set pages 60

accept pr number prompt 'Physical reads (50000) '

break on disk_reads on executions on rows_processed skip 1

col physical format 99,999,999 heading "Ph. reads"
col rowproc format 99,999,999 heading "Rows proc."
col exec format 9,999,999 heading "Exec"
col sql_text format a40 heading "SQL Text"

select sql_text, 
       rows_processed rowproc, 
       disk_reads physical,
       executions exec
from v$sqlarea
where disk_reads > decode(&&lr,0,50000,&&lr)
and   disk_reads / decode(rows_processed,0,1,rows_processed) > 50
order by disk_reads / decode(rows_processed,0,1,rows_processed) desc
/

