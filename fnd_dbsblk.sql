rem ********************************************************************
rem * Filename          : fnd_dbsblk.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 10-AUG-94
rem * Last Update       : 
rem * Description       : Monitor database show file/block info
rem * Usage             : start fnd_dbsblk.sql
rem ********************************************************************

set pages 60
set lines 132

SELECT  owner , segment_name , segment_type 
FROM  dba_extents
WHERE  file_id = &AFN
AND  &BLOCKNO BETWEEN block_id AND block_id + blocks - 1 
/

