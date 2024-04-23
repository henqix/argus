rem ********************************************************************
rem * Filename          : db_dfhwm.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 05-APR-13
rem * Update            : 
rem *                   :
rem * Description       : Report database high watermark for datafiles
rem ********************************************************************

set lines 255
set pages 60

column tablespace_name format a15
column file_name       format a35
column used_blk        format a30
column size            format 999.99
column hwm             format 999.99
 
select ts1 tablespace_name,
       substr(file_name,instr(file_name,'/',-1)+1,30) "Name", 
	   used_blk,
       blocks,
       hwm_max_blk,
       bytes/1024/1024/1024 "SIZE", 
       hwm_max_blk * 16384 / 1024 / 1024 / 1024 "HWM"
from 
(select d.tablespace_name as ts1,
        d.file_name file_name,
        d.bytes,
        d.blocks
 from   dba_data_files d),
(select e.tablespace_name as ts2,
        e.segment_name as used_blk,
        e.block_id     as hwm_max_blk
 from   dba_extents e
 where  e.block_id = (select max(ex.block_id)
                      from   dba_extents ex
					  where  ex.tablespace_name = e.tablespace_name))
 where  ts1 = ts2
 order by 1,2
/

