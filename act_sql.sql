rem ********************************************************************
rem * Filename          : act_sql.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-OCT-2000
rem * Last Update       :  
rem * Update            : 
rem * Description       : Monitor database active SQL
rem * Usage             : start act_sql.sql
rem ********************************************************************

set lines 132
set pages 60

col sid      for a10  heading "Sid"
col username for a10
col sql_text for a64
col rpr      for 999,999,999
col exc      for 999,999
col adr      format a08

break on sid on username on rpr on exc on adr

select /*+ ORDERED */ to_char(s.sid)||':'||to_char(s.serial#) sid, 
       substr(s.username,1,10) username,
       t.address adr, 
       t.sql_text,
       a.rows_processed numrws,
       a.executions exc 
from   v$session s, 
       v$sqltext t,
       v$sqlarea a
where t.address = s.sql_address
and   t.address = a.address
and   s.username not like '%WEB%'
and s.sid in (select s.sid
              from v$session s, 
              v$process p
              where s.status = 'ACTIVE'
              and s.username is not null
              and s.paddr = p.addr)
order by s.sid, piece
/

set lines 80
