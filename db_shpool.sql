rem ********************************************************************
rem * Filename          : db_shpool.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 19-DEC-12
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor Database Shared Pools
rem ********************************************************************

set pages 60
set lines 132

select   s.buffer_pool,
         substr(o.object_name,1,30) object_name,
         s.blocks total_blocks,
         count(*) cached_blocks,
         avg(v.tch) touched
from     dba_objects o,
         dba_segments s,
         x$bh v
where    o.data_object_id = v.obj
and      o.owner = s.owner (+)
and      o.object_name = s.segment_name (+)
and      o.object_type = s.segment_type (+)
and      s.buffer_pool in ('KEEP','RECYCLED')
group by s.BUFFER_POOL, 
         o.object_name,
         s.blocks
order by o.object_name
/

