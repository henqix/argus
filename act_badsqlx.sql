rem ********************************************************************
rem * Filename          : act_badsqlx.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-mar-06
rem * Update            : 
rem * Description       : Monitor database bad sql (extended)
rem * Usage             : start act_badsqlx.sql
rem ********************************************************************

set lines 132
set pages 60

accept dr number prompt 'Disk reads (100000) '

break on disk_reads on buffer_gets on executions on hitratio skip 1

col logical  format 9,999,999,999 heading "Lg. reads"
col physical format 9,999,999,999 heading "Ph. reads"
col hitratio format 99.99 heading "Hrt"
col exec     format 9,999,999 heading "Exec"
col rowproc  format 9,999,999 heading "Rows proc."
col expphy   format 9,999.99 heading "Phr/Exec"
col explog   format 9,999.99 heading "Lgr/Exec"

select address,
       disk_reads physical, 
       buffer_gets logical,
       executions exec,
       rows_processed rowproc,
       disk_reads / executions expphy,
       buffer_gets / executions explog,
       (1 - (disk_reads / buffer_gets)) * 100 hitratio
from v$sqlarea
where disk_reads > decode(&&dr,0,100000,&&dr)
order by hitratio desc
/

