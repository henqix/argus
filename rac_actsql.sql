rem ********************************************************************
rem * Filename          : rac_actsql.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-OCT-2000
rem * Last Update       :  
rem * Update            : 
rem * Description       : Monitor database active SQL for RAC
rem ********************************************************************

set pages 60
set lines 132

col sid      for a10  heading "Sid"
col username for a10
col sql_text for a64
col rpr      for 999,999,999
col exc      for 999,999
col adr      format a08
col instid   format a02

break on instid on sid on username on rpr on exc on adr

select /*+ ORDERED */ substr(to_char(s.inst_id),1,2) instid, 
       to_char(s.sid)||':'||to_char(s.serial#) sid, 
       substr(s.username,1,10) username,
       t.address adr, 
       t.sql_text,
       a.rows_processed rpr,
       a.executions exc 
from   gv$session s, 
       gv$sqltext t,
       gv$sqlarea a
where  t.address = s.sql_address
and    t.inst_id = s.inst_id
and    t.address = a.address
and    t.inst_id = a.inst_id
and    s.username not like '%WEB%'
and    s.sid in (select s.sid
                 from   gv$session s, 
                        gv$process p
                 where  s.status = 'ACTIVE'
                 and    s.username is not null
                 and    s.paddr = p.addr)
order by s.inst_id, s.sid, piece
/

