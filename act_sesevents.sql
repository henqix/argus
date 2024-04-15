rem ********************************************************************
rem * Filename          : act_sesevents.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-JAN-2001
rem * Last Update       : 29-JAN-2001 
rem * Update            : Information from v$session_wait added
rem * Description       : Monitor database session waits
rem ********************************************************************

set pages 60
set lines 132

col ev   format         a30 heading "Event"
col sid  format       99999 heading "SID"
col tw   format   9,999,999 heading "Waits"
col tt   format   9,999,999 heading "Timeouts"
col ti   format   9,999,999 heading "Time"
col av   format    9,999.99 heading "Avg"

break on ev skip 1

select substr(event,1,30) ev,
       sid,
       total_waits tw,
       total_timeouts tt,
       time_waited / 100 ti,
       average_wait / 100 av
from   v$session_event
where  event not like 'SQL%'
and    event not in ('rdbms ipc message','pmon timer','smon timer')
and    total_timeouts <> 0
and    average_wait > 50
order by
       substr(event,1,30),
       sid
/

set lines 160

col wt   format       9,999 heading "Time"
col siw  format    9,999,999 heading "Secs"
col stat format         a03 heading "Sta"

select substr(event,1,30) ev,
       sid,
       substr(p1text,1,25) tekst,
       p1,
       p2,
       p3,
       wait_time wt,
       seconds_in_wait siw,
       decode(state,'WAITED SHORT TIME','WST','WAITING','WAI','MIS') stat
from   v$session_wait
where  event not like 'SQL%'
and    event not in ('rdbms ipc message','pmon timer','smon timer')
order by
       substr(event,1,30),
       sid
/       
       

col nv format 9,999,999,999 heading "Value"

select name "Event", 
       value nv
from   v$sysstat
where  name in ('free buffer requested')
/

column ins_ratio format 00.99
column dir_ratio format 00.99

prompt Buffer busy rate (should be < 1.00)

select requested,
       inspected,
       dirty,
       (inspected/requested) * 100 iratio,
       (dirty/requested) * 100 dratio
from
       (select value inspected from v$sysstat where name = 'free buffer inspected') a
       ,(select value requested from v$sysstat where name = 'free buffer requested') b
       ,(select value dirty from v$sysstat where name = 'dirty buffers inspected') c
/

col c1 heading 'Event'        format a35
col c2 heading 'Total waits'  format 99,999,999,999
col c3 heading 'Time waited'  format 99,999,999
 
select
   event                                         c1,
   sum(total_waits)                              c2,
   sum(time_waited)                              c3,
   sum(time_waited) / sum(total_waits)           c4
from
  v$session_event
where
   event in ('db file scattered read','db file sequential read')
group by 
   event;




