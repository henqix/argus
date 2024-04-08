rem ********************************************************************
rem * Filename          : act_longops.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 13-jul-11
rem * Update            : 
rem * Description       : Monitor database long running operations
rem ********************************************************************

set lines 132
set pages 60

column target format a30
column elapsed format a6
column remaining format a6

select s.sid,
       s1.target,
       s1.totalwork,
       s1.sofar,
       trunc(s1.elapsed_seconds/60) || ':' || mod(s1.elapsed_seconds,60) elapsed,
       trunc(s1.time_remaining/60) || ':' || mod(s1.time_remaining,60) remaining,
       round(s1.sofar / s1.totalwork * 100, 2) progress_pct
from v$session s,
     v$session_longops s1
where s.sid = s1.sid
and   s.serial# = s1.serial#
and   s1.sofar <> s1.totalwork
/
