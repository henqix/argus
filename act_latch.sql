rem ********************************************************************
rem * Filename          : act_latch.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : IXORA
rem * Last Update       : 27-sep-2001 
rem * Update            : Adapted for Argus Toolbox
rem * Description       : Report actual latches
rem * Usage             : start act_latch.sql
rem ********************************************************************

set lines 128
set pages 60

set recsep off
column name format a30 heading "LATCH TYPE"
column location format a40 heading "CODE LOCATION and [LABEL]"
column sleeps format 999999 heading "SLEEPS"

select /*+ ordered use_merge(b) */
  b.name,
  b.location,
  b.sleeps - a.sleeps  sleeps
from
  (
    select /*+ no_merge */
      wsc.ksllasnam  name,
      rpad(lw.ksllwnam, 40) ||
      decode(lw.ksllwlbl, null, null, '[' || lw.ksllwlbl || ']')  location,
      wsc.kslsleep  sleeps
    from
      sys.x$kslwsc wsc,
      sys.x$ksllw lw
    where
      wsc.inst_id = userenv('Instance') and
      lw.inst_id = userenv('Instance') and
      lw.indx = wsc.indx
  )  a,
  (
    select /*+ no_merge */
      wsc.ksllasnam  name,
      rpad(lw.ksllwnam, 40) ||
      decode(lw.ksllwlbl, null, null, '[' || lw.ksllwlbl || ']')  location,
      wsc.kslsleep  sleeps
    from
      ( select min(indx) zero from sys.x$ksmmem where rownum < 1000000 ) delay,
      sys.x$kslwsc wsc,
      sys.x$ksllw lw
    where
      wsc.inst_id = userenv('Instance') and
      lw.inst_id = userenv('Instance') and
      wsc.kslsleep > delay.zero and
      lw.indx = wsc.indx
  )  b
where
  b.name = a.name and
  b.location = a.location and
  b.sleeps > a.sleeps
order by
  3 desc
/
