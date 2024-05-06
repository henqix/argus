rem ********************************************************************
rem * Filename          : db_sga_cur_resize.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 06-may-24
rem * Update            : 
rem * Description       : Show SGA resize operations, V$SGA_RESIZE_OPS displays information 
rem *                     about the last 800 completed SGA resize operations. 
rem *                     This does not include in-progress operations. 
rem *					  All sizes are displayed in Mbytes.
rem ********************************************************************

set lines 132
set pages 60

column  parameter format a35
column  oper_type format a4
column  oper_mode format a4

select  parameter,
        substr(oper_type,1,4) oper_type,
        substr(oper_mode,1,4) oper_mode,
        initial_size/1024/1024 "Init",
		current_size/1024/1024 "Current",
        TARGET_SIZE/1024/1024 "Target",
		to_char(start_time,'YYMMDD HH24:MI')
from    v$sga_current_resize_ops
order by 1,7;
