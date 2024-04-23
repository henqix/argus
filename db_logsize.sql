rem ********************************************************************
rem * Filename          : db_logsize.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-JUL-98
rem * Update            : 13-JAN-11
rem * Update            : Blocksize added
rem *                   :
rem * Description       : Report database archivelog size generated.
rem ********************************************************************

set lines 128
set pages 60
set verify off


select trunc(completion_time) rundate,
       count(*) logswitch,
       round((sum(blocks*512)/1024/1024)) "REDO PER DAY (MB)"
from   v$archived_log
where  trunc(completion_time) > trunc(sysdate - 30) 
group by trunc(completion_time)
order by 1
/
