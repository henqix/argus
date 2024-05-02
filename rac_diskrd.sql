rem ********************************************************************
rem * Filename          : rac_diskrd.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 03-OCT-99
rem * Last Update       : 03-JAN-02
rem * Update            : Value for DISK READS added.
rem * Description       : Monitor database big disk reads spenders
rem ********************************************************************

set lines 132
set pages 60

column executes format 9,999,999
column dreads   format 999,999,999,999 heading "DISK READS"
column load     format a10

break on load on executes on dreads on address on id 

select
  s.inst_id id,
  substr(
    to_char(
      100 * s.disk_reads / t.total_disk_reads,
      '99.00'
    ),
    2
  ) ||
  '%'  load,
  s.disk_reads dreads,
  s.executions executes,
  p.sql_text,
  s.address
from
  ( select sum(disk_reads) total_disk_reads from sys.v_$sql )  t,
  sys.gv_$sql  s,
  sys.gv_$sqltext  p
where
  100 * s.disk_reads / t.total_disk_reads > 1 and
  s.disk_reads > 50 * s.executions and
  p.address = s.address and
  p.inst_id = s.inst_id
order by
  2, s.address, p.piece
/

