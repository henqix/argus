rem ********************************************************************
rem * Filename          : db_reslim.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 02-APR-2012
rem * Last Update       :
rem * Update            :
rem * Description       : Monitor Resource Limits
rem ********************************************************************

set lines 132
set pages 66

select * from v$resource_limit;

