rem ********************************************************************
rem * Filename          : dg_dbstat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show status for DataGuard
rem ********************************************************************

set lines 132
set pages 60

column owner format a40
column object_type format a40

select owner, object_type, count(*)
from dba_objects
where owner not in ('SYS','SYSTEM')
group by owner, object_type
order by 1,2
/
