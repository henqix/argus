rem ********************************************************************
rem * Filename          : act_tmpusg.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 05-SEP-02
rem * Last Update       :  
rem * Update            :  
rem * Description       : Monitor database temporary tablespace(s)
rem ********************************************************************

set lines 132
set pages 60

select substr(TABLESPACE_NAME,1,10) "TABLESPACE",
       TOTAL_EXTENTS,
       USED_EXTENTS,
       FREE_EXTENTS,
       TOTAL_BLOCKS,
       USED_BLOCKS,
       FREE_BLOCKS,
       EXTENT_SIZE
from v$sort_segment
/

column username    format a15
column osuser      format a20
column ext         format 999
column blck        format 999

select s.sid, s.serial#, s.username, s.osuser, u.extents ext, u.blocks blck, u.sqladdr, u.segrfno#
from   v$session s,
       v$sort_usage u
where  s.SADDR = u.SESSION_ADDR
order by u.extents desc
/

