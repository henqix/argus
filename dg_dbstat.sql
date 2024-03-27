rem ********************************************************************
rem * Filename          : dg_dbstat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show status for DataGuard
rem * Usage             : start dg_dbstat.sql
rem ********************************************************************

set lines 132
set pages 60

column PRIM_NAM       format a08
colum  DB_UNIQUE_NAME format a08


select PRIMARY_DB_UNIQUE_NAME PRIM_NAM, 
       DB_UNIQUE_NAME, 
       DATABASE_ROLE, 
       OPEN_MODE, 
       INSTANCE_NAME, 
       INSTANCE_ROLE, 
       STATUS,
       to_char(STARTUP_TIME,'DD-MON-YY HH24:MI:SS') STARTED
from v$database, v$instance
/
