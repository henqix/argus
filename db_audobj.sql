rem ********************************************************************
rem * Filename          : db_audobj.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 05-JAN-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report audited objects
rem ********************************************************************

set pages 60
set lines 132

column username  format a20
column priv_used format a20
column object    format a25 
column ses_actions format a13 heading 'AACDGIILRSURE|LUOERNNOEEPEX|TDMLADSCNLDFE'

select substr(obj_name,1,25) object, 
       priv_used, 
       substr(ses_actions,1,13) ses_actions, 
       username 
from   dba_audit_object
where  owner like '%&own%'
and    obj_name like '%&obj%'
and    priv_used not in ('AUDIT ANY', 'ANALYZE ANY')
order by 4,1
/

