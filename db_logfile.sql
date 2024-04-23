rem ********************************************************************
rem * Filename          : db_logfiles.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-JUL-98
rem * Update            : 13-JAN-11
rem *                   :
rem * Description       : Report database archivelog files
rem * Usage             : start rd_logfil.sql
rem ********************************************************************

set lines 132
set verify off

column member  format a40
column group#  format 99
column status  format a8

 

select l1.GROUP#, 
       l2.MEMBER, 
	   l2.type, 
	   l1.status, 
	   l1.bytes, 
	   l1.ARCHIVED, 
	   l1.FIRST_CHANGE#, 
	   to_char(l1.FIRST_TIME,'DD-MM-YY HH24:MI:SS') "USED SINCE"
from   v$log l1,
       v$logfile l2
where  l1.GROUP# = l2.GROUP#
order by 1
/
