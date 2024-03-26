rem ********************************************************************
rem * Filename          : dg_apllog.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 14-AUG-06
rem * Last Update       :
rem * Update            :
rem * Description       : Monitor database applied logfiles (standby)
rem * Usage             : start dg_apllog.sql
rem ********************************************************************

set lines 132
set pages 60

select RECID, SEQUENCE#, dest_id,
       to_char(FIRST_TIME,'dd-mon-yy hh24:mi:ss') "FIRST",
       to_char(NEXT_TIME,'dd-mon-yy hh24:mi:ss') "NEXT",
       applied
from   V$ARCHIVED_LOG
where  recid > (select max(recid) - 12 from V$ARCHIVED_LOG)
order by 2,3
/
