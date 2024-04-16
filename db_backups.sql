rem ********************************************************************
rem * Filename          : db_backups.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show all backups for the last 7 days
rem ********************************************************************

set lines 132
set pages 60

col STATUS format a5
col hrs    format 999.99
col MBYTES format 99,999

select d.SESSION_KEY, 
       d.SESSION_RECID, 
	   d.SESSION_STAMP,
	   d.INPUT_TYPE, 
	   substr(d.STATUS,1,5) STATUS,
       to_char(d.START_TIME,'mm/dd/yy hh24:mi') start_time,
       to_char(d.END_TIME,'mm/dd/yy hh24:mi')   end_time,
       d.elapsed_seconds/3600                   hrs,
	   v.MBYTES_PROCESSED MBYTES
from   V$RMAN_BACKUP_JOB_DETAILS d, v$rman_status v
where  d.SESSION_RECID = v.SESSION_RECID
and    d.SESSION_STAMP = v.SESSION_STAMP
and    trunc(d.start_time) > sysdate -30
order by d.session_key;
