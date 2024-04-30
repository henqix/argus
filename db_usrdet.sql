rem ********************************************************************
rem * Filename          : db_usrdet.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 11-JUL-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report user details
rem ********************************************************************

set pages 60
set lines 132
set verify off

column uname     format a20 heading "Username"
column deftbls   format a15 heading "Dflt tablespace"
column tmptbls   format a15 heading "Temp tablespace"
column accstat   format a03 heading "Sta"
column prfl      format a20 heading "Profile"
column prvlg     format a20 heading "Privilege"

select substr(username,1,20) uname,
       substr(default_tablespace,1,15) deftbls,
       substr(temporary_tablespace,1,15) tmptbls,
       substr(account_status,1,3) accstat,
       substr(profile,1,20) prfl,
       created "Created"
from   dba_users
where  username like upper('&&uname')
order by username
/

column grantee format a40
select * from dba_sys_privs
where  grantee like upper('&&uname')
/

column granted_role format a25
column grantee      format a30

select * from dba_role_privs
where  grantee like upper('&&uname')
/


undefine uname
