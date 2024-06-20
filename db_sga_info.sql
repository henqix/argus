rem ********************************************************************
rem * Filename          : db_sgainfo.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show current SGA values
rem ********************************************************************

set lines 132
set pages 60

select * from v$sgainfo;
