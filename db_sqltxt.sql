rem ********************************************************************
rem * Filename          : db_sqltxt.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-oct-98
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report database v$sqltext
rem ********************************************************************

set pages 60
set lines 132
set verify off
set wrap on

column sqltxt format a75

break on sid on username on osuser
select substr(username,1,15) "USERNAME", 
       substr(osuser,1,15) "OSUSER", 
       substr(to_char(s.sid),1,3) "SID", 
	   t.sql_text sqltxt
from v$session s, v$sqltext t
where s.sql_address = t.address
and s.sql_hash_value = t.hash_value
order by s.sid,
         t.piece
/
