rem ********************************************************************
rem * Filename          : act_latch.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : IXORA
rem * Last Update       : 27-sep-2001 
rem * Update            : Adapted for Argus Toolbox
rem * Description       : Report actual latches
rem * Usage             : start md_actlat.sql
rem ********************************************************************

set lines 128
set pages 60

set recsep off

column name format a30 heading "Latch type"
column location format a40 heading "Code location and [Label]"
column sleeps format 999999 heading "Sleeps"

select
  b.name,
  b.location,
  b.sleeps - a.sleeps  sleeps
from
  (
    select
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
      wsc.kslsleep > 0 and
      lw.indx = wsc.indx
  )  a,
  (
    select
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
      wsc.kslsleep > 0 and
      lw.indx = wsc.indx
  )  b
where
  b.name = a.name (+) and
  b.location = a.location (+) and
  b.sleeps > a.sleeps
order by
  3 desc
/

set lines 80
