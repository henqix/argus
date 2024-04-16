rem ********************************************************************
rem * Filename          : act_bcache.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 20-NOV-00
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor buffer cache
rem * Usage             : start act_bcache.sql
rem ********************************************************************

set lines 132
set pages 60

column dblocks format 999,999 heading "Table|blocks"
column cblocks format 999,999 heading "Cached|blocks"
column cb      format 999,999 heading "Clear|blcks"
column db      format   9,999 heading "Dirty|blcks"

select substr(o.owner,1,15) "Owner",
       substr(o.object_name,1,25) "Object Name",
       t.blocks dblocks,
       decode(b.state,0,'FR',1,'XC',3,'CR','XX') "St",
       sum(decode(bitand(flag,1),1,0,1)) Cb, 
       sum(decode(bitand(flag,1),1,1,0)) Db, 
       count(b.obj) cblocks
from dba_objects o,
     dba_segments t,
     sys.x$bh b
where o.object_id (+) = b.obj
and   o.object_name = t.segment_name (+)
--and   o.object_type = 'TABLE'
and   o.owner <> 'SYS'
and   t.blocks > 100
group by 
      substr(o.owner,1,15),
      substr(o.object_name,1,25),
      t.blocks,
      b.state
order by 1,2
/

