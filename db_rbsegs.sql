rem ********************************************************************
rem * Filename          : db_rbsegs.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 19-JUN-98
rem * Last Update       : 08-FEB-06 
rem * Update            : Add wrap around time per RBS
rem * Description       : Rollback segment storage 
rem * When a next extent is created always a multiple of 5 blocks is used.
rem ********************************************************************

set pages 60
set lines 132

col rbs     format         a10 justify c heading 'Rollback|segment'
col initext format     999,990 justify c heading 'Init|Ext(Kb)'
col nextext format     999,990 justify c heading 'Next|Ext(Kb)'
col minext  format         990 justify c heading 'Min|Ext'
col maxext  format         990 justify c heading 'Max|Ext'
col optimal format     999,990 justify c heading 'Optimal|Kb' 
col hwm     format     999,990 justify c heading 'Hwmsize|Mb'
col extents format         990 justify c heading 'Ext'        
col shrinks format         990 justify c heading 'Shr'        
col gets    format  99,999,990 justify c heading 'Gets'       
col waits   format       9,990 justify c heading 'Waits'
col writes  format 999,999,990 justify c heading 'Writes (*1000)'       
col hours   format   9,999,999 justify c heading 'Wrap'
col stat    format          a3 justify c heading 'Sta'

select
  substr(segment_name,1,10)          rbs,  
  initial_extent/1024                initext,
  next_extent/1024                   nextext,
  min_extents                        minext,
  decode(max_extents,32765,999,
         max_extents)                maxext,
  optsize/1024                       optimal,
  hwmsize/1024/1024                  hwm,
  extents                            extents,
  shrinks                            shrinks,
  gets                               gets,
  waits                              waits,
  writes/1000                        writes,
  round(24 * (sysdate - i.startup_time) / (writes / rssize), 1) hours,  
  substr(v$rollstat.status,1,3)      stat
from
  sys.dba_rollback_segs,
  v$rollstat,
  v$instance i
where usn = segment_id
and   v$rollstat.status <> 'OFFLINE'
order by segment_name
/
