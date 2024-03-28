rem ********************************************************************
rem * Filename          : dsk_writes.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-OCT-99
rem * Last Update       : 03-JAN-02
rem * Update            : Value for DISK WRITES added.
rem * Description       : Monitor database big disk writers
rem * Usage             : start dsk_writes.sql
rem ********************************************************************

set lines 255
set pages 60

column executes format 9,999,999
column dwrites  format 999,999,999,999 heading "DISK WRITES"
column load     format a10
column address  format a16

break on load on executes on dwrites on address on sql_id on plan_hash_value 

select
  substr(
    to_char(
      100 * s.DIRECT_WRITES / t.total_disk_writes,
      '99.00'
    ),
    2
  ) ||
  '%'  load,
  s.DIRECT_WRITES dwrites,
  s.executions executes,
  p.sql_text,
  s.address,
  s.sql_id,
  s.plan_hash_value
from
  ( select sum(direct_writes) total_disk_writes from sys.v_$sql )  t,
  sys.v_$sql  s,
  sys.v_$sqltext  p
where
  100 * s.direct_writes / t.total_disk_writes > 1 and
--  s.direct_writes > 50 * s.executions and
  p.address = s.address
order by
  1, s.address, p.piece
/

start rf_clea
