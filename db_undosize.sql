rem ********************************************************************
rem * Filename          : db_undosize.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 10-jun-09
rem * Last Update       : 
rem * Update            : 
rem * Description       : Caculate used UNDO size
rem ********************************************************************

set lines 132
set pages 60

column aus format 999,999 heading "ACTUAL UNDO SIZE [MByte]"
column urs format 999,999 heading "UNDO RETENTION [Sec]"
column nus format 999,999 heading "NEEDED UNDO SIZE [MByte]"

SELECT d.undo_size/(1024*1024) aus,
       SUBSTR(e.value,1,25) urs,
       (TO_NUMBER(e.value) * TO_NUMBER(f.value) * g.undo_block_per_sec) / (1024*1024) nus
FROM (
       SELECT SUM(a.bytes) undo_size
         FROM v$datafile a,
              v$tablespace b,
              dba_tablespaces c
        WHERE c.contents = 'UNDO'
          AND c.status = 'ONLINE'
          AND b.name = c.tablespace_name
          AND a.ts# = b.ts#
       ) d,
v$parameter e,
v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
         undo_block_per_sec
         FROM v$undostat
       ) g
WHERE e.name = 'undo_retention'
AND f.name = 'db_block_size'
/
