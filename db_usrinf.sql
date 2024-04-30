rem ********************************************************************
rem * Filename          : db_usrinf.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 27-APR-98
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report tablespace space
rem ********************************************************************

set pages 60
set lines 132

select substr(u.username,1,20) "Name",
       substr(u.default_tablespace,1,15) "Default tbls",
       substr(u.temporary_tablespace,1,15) "Temporary tbls",
       u.created "Created",
       to_char(s.logon_time,'dd-mon-rrrr:HH24MI') "Logon"
from   dba_users u,
       v$session s
       where u.username = s.username (+)
order by u.username
/
