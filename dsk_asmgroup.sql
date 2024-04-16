rem ********************************************************************
rem * Filename          : dsk_amsgroup.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-JUL-08
rem * Last Update       :  
rem * Update            : 
rem *                   : 
rem * Description       : Monitor ASM Disk Information
rem ********************************************************************

set lines 132
set pages 60

column gid format a02
column did format a02
column group_name format a15
column red format a03

select to_char(g.GROUP_NUMBER) GID, 
       substr(g.NAME,1,15) GROUP_NAME, 
       to_char(d.DISK_NUMBER) DID, 
       d. NAME, 
       d.FAILGROUP,
       substr(d.REDUNDANCY,1,3) RED,
       g.TOTAL_MB,
       g.FREE_MB
from   v$asm_disk d, 
       v$asm_diskgroup g
where  d.GROUP_NUMBER = g.GROUP_NUMBER
order by 1
/


