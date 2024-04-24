rem ********************************************************************
rem * Filename          : db_nlspar.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 01-SEP-96
rem * Last Update       : 
rem * Update            : 
rem * Description       : Overview of NLS parameters
rem ********************************************************************

set lines 132
set pages 60

select substr(parameter,1,30) "Parameter", 
       substr(value,1,40) "Value"
from   v$nls_parameters
/
