rem ********************************************************************
rem * Filename          : db_allparams.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 02-NOV-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report all database parameters
rem ********************************************************************

set lines 132
set pages 60

column KSPPINM format a40
column KSPPDESC format a75

select KSPPINM , KSPPDESC
FROM  X$KSPPI
ORDER BY KSPPINM
/

