rem ********************************************************************
rem * Filename          : db_mem_adv.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 12-DEC-2011
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor Memory Usage
rem ********************************************************************

set lines 132
set pages 66

select * from v$memory_target_advice
/
