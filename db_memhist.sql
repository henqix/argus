rem ********************************************************************
rem * Filename          : db_memhist.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show memory cache and pool actions history
rem ********************************************************************

set lines 132
set pages 60

column PARAMETER format a25

set lines 132

select substr(PARAMETER,1,25) PARAMETER, 
       OPER_TYPE, 
       OPER_MODE, 
       to_char(START_TIME,'DD-MM-YY HH24:MI:SS') START_TIME, 
       INITIAL_SIZE, 
       TARGET_SIZE, 
       FINAL_SIZE, 
       STATUS
from v$memory_resize_ops
where OPER_MODE <> 'STATIC'
order by START_TIME
/
