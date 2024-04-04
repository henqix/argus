rem ********************************************************************
rem * Filename          : db_sidinf.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 20-mei-96
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor Logon Information for sid
rem * Usage             : start db_sidinf.sql
rem ********************************************************************

set pages 60
set lines 255
set verify off

accept  orasid char prompt 'LOGON Information for sid : '

col osuser format a7 heading 'Client|User'
col process format a6 heading 'Clnt|PID'
col spid format a7 heading 'Srvr|PID'
col username format a7 heading 'Oracle|User'
col serial# format 99999 heading 'Srl|#'
col sid format 999 heading 'Sid' new_value sid 
col pid format 99999 heading 'Ora|PID'
col lockwait format a7 heading 'Lock|Address'
col status format a5 heading 'Status' trunc
col terminal format a5 heading 'Term'
col logical_reads format 99,999,999 heading 'Log|Reads'
col physical_reads format 99,999,999 heading 'Phy|Reads'
col block_changes format 99,999,999 heading 'Blk|Changes'
col hit_ratio format 999.99 heading 'Hit|Rate'
col saddr new_value saddr noprint
select  a.osuser 
,       a.process
,       b.spid
,       a.terminal
,       a.username
,       a.serial#
,       a.sid
,       b.pid
,       a.lockwait
,       a.status
,       a.saddr
,       c.block_gets + c.consistent_gets logical_reads
,       c.physical_reads physical_reads
,       c.block_changes block_changes
,       100* ( 1 - c.physical_reads / (c.block_gets + c.consistent_gets )) hit_ratio
from
        v$session a
,       v$process b
,       v$sess_io c
where   a.paddr = b.addr
and     a.sid = c.sid
and     a.sid = &&orasid
/


col username for a10
col sql_text for a64
col rpr      for 999,999,999
col exc      for 999,999
col adr      format a15

break on sid on username on rpr on exc on adr

select /*+ ORDERED */ substr(s.username,1,10) username,
       t.address adr, 
       t.sql_text,
       a.rows_processed rpr,
       a.executions exc 
from   v$session s, 
       v$sqltext t,
       v$sqlarea a
where t.address = s.sql_address
and   t.address = a.address
and   s.sid = &&orasid
/

column hld format a15 heading "Hold"
column req format a15 heading "Request"

select type, 
       decode(id1,null,'',name) "Object", id2,
       DECODE(lmode, 0, 'None', 1, 'Null', 2, 'Row Share', 3, 'RowExcl.', 4, 'Share', 
       5, 'S/Row Excl.', 6, 'Exclusive') hld,
       DECODE(request, 0, 'None', 1, 'Null', 2, 'Row Share', 3, 'RowExcl.', 4, 'Share', 
       5, 'S/Row Excl.', 6, 'Exclusive') req,
       v$lock.ctime "Time/sec"
from   v$lock,
       sys.obj$
where  sid = &&orasid
and    id1 = obj#
/

select substr(event,1,30) ev,
       sid,
       total_waits tw,
       total_timeouts tt,
       time_waited / 100 ti,
       average_wait / 100 av
from   v$session_event
where  sid = &&orasid
and    event not like 'SQL%'
and    event not in ('rdbms ipc message','pmon timer','smon timer')
and    total_timeouts <> 0
and    average_wait > 50
order by
       substr(event,1,30),
       sid
/
