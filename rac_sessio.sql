rem ********************************************************************
rem * Filename          : rac_sessio.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show session I/O for RAC
rem ********************************************************************

set lines 132
set pages 60

column username format a15
column program  format a25

select i.INST_ID,
       substr(s.username,1,15) "USERNAME",
       substr(s.program,1,25) "PROGRAM", 
       i.SID, 
       i.BLOCK_GETS,
       i.CONSISTENT_GETS, 
       i.PHYSICAL_READS, 
       i.BLOCK_CHANGES, 
       i.CONSISTENT_CHANGES
from   gv$sess_io i,
       gv$session s
where  i.inst_id = s.inst_id
and    i.sid = s.sid
order by 8 asc
/
