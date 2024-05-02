rem ********************************************************************
rem * Filename          : cre_copy_user.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 07-oct-08
rem * Last Update       : 
rem * Update            : 
rem * Description       : Create script for copying users 
rem ********************************************************************

set pages 0
set lines 132
set feedback off
set verify off

col un newline
col dt newline
col tt newline
col dq newline
col pr newline
col gr newline

accept newusr prompt 'New username '
accept newpwd prompt 'New password '
accept cpyusr prompt 'Org username '

spool cre_cp_user.sql

select 'create user &&newusr identified by &&newpwd' un,
       ' default tablespace '||u.default_tablespace dt,
       ' temporary tablespace '||u.temporary_tablespace tt,
       ' profile '||profile||';' pr
from   dba_users u
where  u.username = upper('&&cpyusr');
 
select 'alter user &&newusr quota unlimited on '
       ||q.tablespace_name||';' dq
from   dba_ts_quotas q
where  q.username = upper('&&cpyusr'); 

select 'grant '||r.granted_role||' to &&newusr;' 
from   dba_role_privs r
where  r.grantee = upper('&&cpyusr');
       
select 'grant '||s.privilege||' to &&newusr;' 
from   dba_sys_privs s
where  s.grantee = upper('&&cpyusr');
       
select 'grant '||t.privilege||' on '||t.table_name||' to &&newusr;'
from   dba_tab_privs t
where  t.grantee = upper('&&cpyusr');

spool off

undefine newusr
undefine newpwd

