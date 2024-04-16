rem ********************************************************************
rem * Filename          : dsk_asminfo.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show all ASM information
rem ********************************************************************

set lines 132
set pages 60
set MARKUP HTML ON
set echo on

SPOOL ASM_FIRST_ASM1.HTML

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

select 'THIS ASM REPORT WAS GENERATED AT: ==)> ' , sysdate " " from dual;


select 'HOSTNAME ASSOCIATED WITH THIS ASM INSTANCE: ==)> ' , MACHINE " " from v$session where program like '%SMON%';

select * from v$asm_diskgroup;

SELECT * FROM V$ASM_DISK ORDER BY GROUP_NUMBER,DISK_NUMBER;

SELECT * FROM V$ASM_CLIENT;

select * from V$ASM_ATTRIBUTE;

select * from v$asm_operation;
select * from gv$asm_operation;


select * from v$version;

show parameter asm
show parameter cluster
show parameter instance_type
show parameter instance_name
show parameter spfile

show sga

spool off


 