rem ********************************************************************
rem * Filename          : db_matvws.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show status for DataGuard
rem ********************************************************************

set lines 132
set pages 60

column MVIEW_NAME format a30

select MVIEW_NAME, LAST_REFRESH_TYPE, LAST_REFRESH_DATE, COMPILE_STATE
from dba_mviews
/
