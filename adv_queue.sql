rem ********************************************************************
rem * Filename          : adv_queue.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show message status for Advanced Queueing
rem * Usage             : start adv_queue.sql
rem ********************************************************************

set lined 132
set pages 60

column owner format a30
column name  format a40

select v.QID, d.OWNER, d.NAME, v.WAITING, v.READY, v.EXPIRED
from v$aq v,
     dba_queues d
where d.qid = v.qid
/

