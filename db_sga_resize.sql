rem ********************************************************************
rem * Filename          : db_sga_resize.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 06-may-24
rem * Update            : 
rem * Description       : Show SGA resize operations
rem ********************************************************************

set lines 132
set pages 60

column  component format a35
column  oper_type format a4
column  oper_mode format a4

select  component,
        substr(oper_type,1,4) oper_type,
        substr(oper_mode,1,4) oper_mode,
        initial_size/1024/1024 "Init",
        TARGET_SIZE/1024/1024 "Target",
        FINAL_SIZE/1024/1024 "Final",
        substr(status,1,5) "Status",
		to_char(start_time,'YYMMDD HH24:MI')
from    v$sga_resize_ops
order by 1,8;
