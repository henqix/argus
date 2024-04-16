rem **************************************************************************
rem * Filename          : db_allgrnts.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 04-JAN-95
rem * Last Update       : 
rem * Update            : 
rem * Description       : Reports all granted privileges, direct and via roles
rem **************************************************************************

set lines 132
set pages 60

col gr  format         a30 heading 'Grantee'
col pr  format         a40 heading 'System Privilege'
col rl  format         a20 heading 'Granted Role'

break on gr on rl

select s.grantee gr,
	   'DIRECT' rl,
	   s.privilege pr
from   dba_sys_privs s
where  s.grantee not in ('SYS' , 'SYSTEM' , 'DBA' )
union 
select r.grantee, 
       r.granted_role, 
	   s.privilege 
from   dba_sys_privs s, dba_role_privs r
where  s.grantee = r.granted_role
and    r.grantee not in ('SYS' , 'SYSTEM' , 'DBA' )
order by 1,2
/
