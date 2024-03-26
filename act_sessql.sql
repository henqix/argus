rem ********************************************************************
rem * Filename          : act_sessql.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-OCT-2000
rem * Last Update       :  
rem * Update            : 
rem * Description       : Monitor database active <sid> sql
rem * Usage             : start act_sessql.sql
rem ********************************************************************

set lines 132
set pages 60

col sid      for 999  heading "Sid"
col username for a10
col sql_text for a64
col rpr      for 9,999,999
col exc      for 9,999,999

break on sid on username on rpr on exc

select /*+ ORDERED */ s.sid, 
       substr(s.username,1,10) username, 
       t.sql_text,
       a.rows_processed rpr,
       a.executions exc 
from   v$session s, 
       v$sqltext t,
       v$sqlarea a
where t.address = s.sql_address
and   t.address = a.address
and   s.sid = 71
order by s.sid, piece
/
