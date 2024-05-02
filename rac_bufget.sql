rem ********************************************************************
rem * Filename          : rac_bufget.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 20-NOV-99
rem * Last Update       : 10-JUL-02
rem * Update            : Buffer gets and disk reads added
rem * Description       : Monitor database buffer gets for RAC
rem ********************************************************************

set pagers 60
set lines  132

column executes       format 9,999,999
column buffer_gets    format 99,999,999,999
column disk_reads     format 999,999,999
column rows_processed format 999,999
column load           format a6
column id             format 99

break on buffer_gets on disk_reads on load on rows_processed on executes on address on id 

select
  s.inst_id id,
  s.buffer_gets,
  s.disk_reads,
  substr(
    to_char(
      100 * s.buffer_gets / t.total_buffer_gets,
      '99.00'
    ),
    2
  ) ||
  '%'  load,
  s.executions executes,
  s.rows_processed,
  p.address,
  p.sql_text
from
  ( select sum(buffer_gets) total_buffer_gets from sys.v_$sql )  t,
  sys.gv_$sql  s,
  sys.gv_$sqltext  p
where
  100 * s.buffer_gets / t.total_buffer_gets > 1 and
  s.buffer_gets > 50 * s.executions and
  p.address = s.address
order by
  4, s.address, p.piece
/

