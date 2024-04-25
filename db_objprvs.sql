rem ********************************************************************
rem * Filename          : db_objprvs.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 11-JAN-99
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report synonyms and object privileges count
rem ********************************************************************

set pages 60
set lines 132

column owner        format a25
column synonym_name format a25
column table_owner  format a25
column table_name   format a25

select owner, 
       synonym_name,
       table_owner,
	   table_name
from   dba_synonyms
where  owner like '%&&prv_owner%'
order by 1,2;

column grantee     format a25
column owner       format a25
column table_name  format a25
column privilege   format a25

select grantee,
       owner,
       table_name,
       privilege
from   dba_tab_privs
where  grantee like '%&&prv_owner%'
order by 1,2,4;

undefine prv_owner