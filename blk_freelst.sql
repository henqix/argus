rem ********************************************************************
rem * Filename          : blk_freelst.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 20-may-99
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor data block free list contention
rem * Usage             : start blk_freelst.sql
rem ********************************************************************

set lines 80
set pages 60

select substr(e.segment_name,1,25) "Segment name", 
       e.segment_type, 
       s.freelists
from dba_extents e, 
     dba_segments s
where  e.segment_name = s.segment_name
and    e.segment_type = s.segment_type
and    e.file_id = (select p1
                    from v$session_wait
                    where p1text = 'file#'
                    and p2 between e.block_id and e.block_id + e.blocks)
/
