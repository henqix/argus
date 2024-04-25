rem ********************************************************************
rem * Filename          : db_sysaux.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show SYSAUX occupants
rem ********************************************************************

set lines 132
set pages 60

COLUMN segment_name format a50
COLUMN Item         format a25  
COLUMN used_space   format 999.99  heading "Used space (Mb)"  
COLUMN schema_name  format a25  
COLUMN mvpr         format a40     heading "Move procedure" 
COLUMN bsize        format 999,999 heading "Size (Mb)"

select  segment_name, 
        bytes/1024/1024 bsize
from    dba_segments
where   tablespace_name = 'SYSAUX'
and     bytes/1024/1024 > 10
order by 2 desc
/

SELECT  occupant_name "Item",  
        space_usage_kbytes/1024/1024 used_space,  
        schema_name,  
        move_procedure mvpr 
FROM    v$sysaux_occupants  
ORDER BY 1  
/ 
       