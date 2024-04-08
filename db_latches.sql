rem ********************************************************************
rem * Filename          : db_latches.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 20-NOV-00
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database latches
rem ********************************************************************

set lines 132
set pages 60

col naam    format            a30 justify c heading 'Latchname'
col normal  format 99,999,999,990 justify c heading 'Normal|gets'
col nrate   format         999.90 justify c heading 'Normal|Ratio'
col spin    format    999,999,990 justify c heading 'Spin|gets'
col srate   format         999.90 justify c heading 'Spin|Ratio'
col sleeps  format    999,999,990 justify c heading 'Sleeps|gets'
col lrate   format         999.90 justify c heading 'Sleep|Ratio'

select
  substr(name,1,30) naam,
  gets - misses normal,
  100 * (gets - misses) / gets nrate,
  spin_gets spin,
  100 * spin_gets / gets srate,
  misses - spin_gets sleeps,
  100 * (misses - spin_gets) / gets lrate
from
  v$latch
where
  gets > 0
and
  100 * (gets - misses)/gets < 99.9
order by
  name
/

