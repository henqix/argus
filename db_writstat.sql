rem ********************************************************************
rem * Filename          : db_writstat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 02-FEB-01
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database writer (DBWR) statistics
rem ********************************************************************

set heading off
set feedback off

col nl1 newline
col nl2 newline
col sc1 format 99.9999
col sc2 format 9999999

select 'Number of database writers : ' ,
       '----------------------------' nl1,
       to_number(value) nl2
from   v$parameter
where  name like '%writer%';

select 'Buffer wait statistics : ',
       '------------------------' nl1,
       substr(s.name,1,54) nl2,
       s.value, 
       substr(e.event,1,50) nl2,
       e.total_timeouts,
       rpad('Score',56) nl2,
       (e.total_timeouts / s.value) * 100 sc
from   v$sysstat s,
       v$system_event e
where  e.event = 'free buffer waits'
and    s.name = 'free buffer requested';

select 'Buffer free statistics : ',
       '------------------------' nl1,
       substr(s.name,1,54) nl2,
       s.value, 
       substr(e.name,1,54) nl2,
       e.value,
       rpad('Score',56) nl2,
       (e.value / s.value) * 100 sc
from   v$sysstat s,
       v$sysstat e
where  e.name = 'free buffer inspected'
and    s.name = 'free buffer requested';

select 'Write complete statistics : ',
       '---------------------------' nl1,
       substr(s.name,1,54) nl2,
       s.value, 
       substr(e.event,1,50) nl2,
       e.total_timeouts,
       rpad('Score',56) nl2,
       (e.total_timeouts / s.value) * 100 sc
from   v$sysstat s,
       v$system_event e
where  e.event = 'write complete waits'
and    s.name = 'DBWR buffers scanned';

set heading on
set feedback on

