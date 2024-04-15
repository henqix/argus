rem ********************************************************************
rem * Filename          : db_sqlarea.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 12-OCT-1998
rem * Last Update       : 
rem * Update            : 
rem * Description       : Show all sql statements in sqlarea
rem ********************************************************************

set lines 120
set pages 60
set wrap on

column sql format a60

break on orauser on osuser on sid skip 1

select substr(username,1,8) "OraUser", 
       substr(osuser,1,8) "OsUser", 
       substr(to_char(s.sid),1,2) "SID", 
       t.sql_text "SQL"
from   v$session s, 
       v$sqlarea t
where  s.sql_address = t.address
and    s.sql_hash_value = t.hash_value
order 
  by   s.sid asc
/
