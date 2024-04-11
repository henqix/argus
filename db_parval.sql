rem ********************************************************************
rem * Filename          : db_parval.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show database parameters
rem ********************************************************************

set lines 132
set pages 60

column parameter format a40
column value     format a75

select substr(name,1,40) "Parameter",
       substr(value,1,75) "Value"
from v$parameter
order by 1
/
