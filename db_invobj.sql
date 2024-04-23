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

column owner format a30
column object_type format a30 

select owner, object_type, status, count(*)
from dba_objects
where status <> 'VALID'
group by owner, object_type, status
order by 1,2
/
