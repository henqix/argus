rem ********************************************************************
rem * Filename          : rac_hitrat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 19-nov-07
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database system hitrate (RAC)
rem ********************************************************************

set pages 60
set lines 132

column timestamp format a20 heading "Date/Startup time"
column hitrate format 99.9999
column "Logical reads" format 999,999,999,999
column "Physical reads" format 999,999,999,999
column "Physical writes" format 999,999,999


select a.inst_id "nn",
       to_char(sysdate,'dd-mm-yy hh24:mi') "Timestamp",
       c.value "Logical reads",
       (a.value - b.value) "Physical reads",
       d.value "Physical writes",
       100 * (1 - (a.value - b.value) / c.value) "Hitrate"
from   gv$sysstat a,
       gv$sysstat b,
       gv$sysstat c,
       gv$sysstat d
where
     a.name = 'physical reads'
and  b.name = 'physical reads direct'
and  c.name = 'session logical reads'
and  d.name = 'physical writes'
and  a.inst_id = 1
and  b.inst_id = 1
and  c.inst_id = 1
and  d.inst_id = 1
union
select a.inst_id "nn",
       to_char(stime,'dd-mm-yy hh24:mi')  "Timestamp",
       c.value / numsec "Logical reads",
       (a.value - b.value) / numsec "Physical reads",
       d.value / numsec "Physical writes",
       0 "Hitrate"
from   gv$sysstat a,
       gv$sysstat b,
       gv$sysstat c,
       gv$sysstat d,
       (select startup_time as stime,
       (sysdate - startup_time) * 24 * 3600 as numsec
       from gv$instance
       where inst_id = 1)
where
       a.name = 'physical reads'
and    b.name = 'physical reads direct'
and    c.name = 'session logical reads'
and    d.name = 'physical writes'
and  a.inst_id = 1
and  b.inst_id = 1
and  c.inst_id = 1
and  d.inst_id = 1
union
select a.inst_id "nn",
       to_char(sysdate,'dd-mm-yy hh24:mi') "Timestamp",
       c.value "Logical reads",
       (a.value - b.value) "Physical reads",
       d.value "Physical writes",
       100 * (1 - (a.value - b.value) / c.value) "Hitrate"
from   gv$sysstat a,
       gv$sysstat b,
       gv$sysstat c,
       gv$sysstat d
where
     a.name = 'physical reads'
and  b.name = 'physical reads direct'
and  c.name = 'session logical reads'
and  d.name = 'physical writes'
and  a.inst_id = 2
and  b.inst_id = 2
and  c.inst_id = 2
and  d.inst_id = 2
union
select a.inst_id "nn",
       to_char(stime,'dd-mm-yy hh24:mi')  "Timestamp",
       c.value / numsec "Logical reads",
       (a.value - b.value) / numsec "Physical reads",
       d.value / numsec "Physical writes",
       0 "Hitrate"
from   gv$sysstat a,
       gv$sysstat b,
       gv$sysstat c,
       gv$sysstat d,
       (select startup_time as stime,
       (sysdate - startup_time) * 24 * 3600 as numsec
       from gv$instance
       where inst_id = 2)
where
       a.name = 'physical reads'
and    b.name = 'physical reads direct'
and    c.name = 'session logical reads'
and    d.name = 'physical writes'
and  a.inst_id = 2
and  b.inst_id = 2
and  c.inst_id = 2
and  d.inst_id = 2
order by 1,2 asc
/
