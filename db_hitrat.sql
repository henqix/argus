rem ********************************************************************
rem * Filename          : db_hitrat.sql - Version 6.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-JUL-92
rem * Update            : 27-APR-06
rem * Update            : I/O per second added
rem * Update            : 14-SEP-11
rem * Update            : Reads and writes calculated in blocks
rem *                   :
rem * Description       : Monitor database system hitrate
rem * Usage             : start db_hitrat.sql
rem ********************************************************************

set lines 255
set pages 60

set verify off

column timestamp format a20 heading "Date/Startup time"
column hitrate format 99.9999
column "Logical reads" format 999,999,999,999
column "Memory reads (Gb)" format 999,999,999,999.99
column "Physical reads" format 999,999,999,999
column "Disk reads (Gb)" format 999,999,999,999.99
column "Physical writes" format 999,999,999,999
column "Disk writes (Gb)" format 999,999,999,999.99

col blocksize new_value bs noprint
select value blocksize
from v$parameter
where name = 'db_block_size';

select to_char(sysdate,'dd-mm-yy hh24:mi') "Timestamp",
       c.value "Logical reads",
       (c.value * &bs / 1024 / 1024 / 1024) "Memory reads (Gb)",
       (a.value - b.value) "Physical reads",
       ((a.value - b.value) * &bs / 1024 / 1024 / 1024) "Disk reads (Gb)",
       d.value "Physical writes",
       (d.value * &bs / 1024 / 1024 / 1024) "Disk writes (Gb)",
       100 * (1 - (a.value - b.value) / c.value) "Hitrate"
from v$sysstat a,
     v$sysstat b,
     v$sysstat c,
     v$sysstat d
where
     a.name = 'physical reads'
and  b.name = 'physical reads direct'
and  c.name = 'session logical reads'
and  d.name = 'physical writes'
union
select to_char(stime,'dd-mm-yy hh24:mi')  "Timestamp",
       c.value / numsec "Logical reads",
       ((c.value * &bs / 1024 / 1024 / 1024) / numsec) "Blocks reads (Gb)",
       (a.value - b.value) / numsec "Physical reads",
       (((a.value - b.value) * &bs / 1024 / 1024 / 1024) / numsec) "Disk reads (Gb)",
       d.value / numsec "Physical writes",
       ((d.value * &bs / 1024 / 1024 / 1024) / numsec) "Disk writes (Gb)",
       0 "Hitrate"
from v$sysstat a,
     v$sysstat b,
     v$sysstat c,
     v$sysstat d,
     (select startup_time as stime,
      (sysdate - startup_time) * 24 * 3600 as numsec
      from v$instance)
where
     a.name = 'physical reads'
and  b.name = 'physical reads direct'
and  c.name = 'session logical reads'
and  d.name = 'physical writes'
order by 1 desc
/

