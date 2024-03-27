rem ********************************************************************
rem * Filename          : dg_allstat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show status for DataGuard
rem * Usage             : start dg_allstat.sql
rem ********************************************************************

set lines 132
set pages 60

select THREAD#, SEQUENCE#, APPLIED, to_char(FIRST_TIME,'ddmmyy hh24:mi:ss') LOGSWITCH,
       to_char(COMPLETION_TIME,'ddmmyy hh24:mi:ss') COMPLETION
from v$archived_log
where STANDBY_DEST = 'YES'
and recid > (select max(recid) - 30 from v$archived_log)
order by 1,2
/

select ARCHIVED_SEQ#, APPLIED_SEQ#
from v$archive_dest_status
where DEST_ID = 2
/

select * from v$dataguard_status
where timestamp > sysdate - 7
and severity in ('Warning','Error')
/
