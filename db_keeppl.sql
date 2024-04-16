rem ********************************************************************
rem * Filename          : db_keeppl.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 19-DEC-R12
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor Database Keep Pool
rem * Usage             : start db_keeppl.sql
rem ********************************************************************

set pages 60
set lines 132

column avg_touches   format 999
column owner         format a15
column object_name   format a30
column object_type   format a12
column blocks        format 99,999,999
column buffers       format 99,999,999
column cprc          format 999.99

select
   a.obj,
   substr(o.owner,1,15) owner, 
   substr(o.object_name,1,30) object_name,
   o.object_type,
   s.blocks,
   COUNT(1) buffers,
   AVG(a.tch) avg_touches,
   (COUNT(1) / s.blocks *100) cprc,
   s.buffer_pool
from 
   sys.x$bh a,
   dba_objects o,
   dba_segments s
WHERE
   a.obj = o.data_object_id
and
   o.object_name = s.segment_name
and
   o.owner = s.owner
and
   o.owner not in ('SYS','SYSTEM')
GROUP BY 
   a.obj,
   substr(o.owner,1,15),
   substr(o.object_name,1,30),
   o.object_type,
   s.blocks,
   s.buffer_pool
HAVING 
   AVG(a.tch) > 5
AND 
   COUNT(1) > 20
ORDER BY
   avg_touches desc
/

