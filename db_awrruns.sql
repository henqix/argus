rem ********************************************************************
rem * Filename          : db_awrruns.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 22-AUG-12
rem * Last Update       :  
rem * Update            : 
rem *                   : 
rem * Description       : Report database AWR runs
rem ********************************************************************

set pages 60
set lines 132

column snap_id              format 999999
column startup_time         format a25
column begin_interval_time  format a25
column end_interval_time    format a25
column flush_elapsed        format a25
column error_count          format 999

select snap_id,
       begin_interval_time,
       flush_elapsed,
       status,
       error_count,
       snap_flag
       from wrm$_snapshot
where  dbid = (select dbid from v$database)
and    begin_interval_time > sysdate -1
order by snap_id asc
/

column snap_id              format 999999
column startup_time         format a25
column begin_interval_time  format a25
column end_interval_time    format a25
column flush_elapsed        format a25
column error_count          format 999

select snap_id,
       startup_time,
       begin_interval_time,
       end_interval_time,
       flush_elapsed,
       error_count
from   dba_hist_snapshot 
where  begin_interval_time > sysdate -1
order by snap_id asc
/

