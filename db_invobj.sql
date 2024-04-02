rem ********************************************************************
rem * Filename          : db_invobj.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-jun-1997
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report invalid objects
rem * Usage             : start db_invobj.sql
rem ********************************************************************

set lines 132
set pages 60

select object_type, status, count(*)
from dba_objects
where status <> 'VALID'
group by object_type, status
/
