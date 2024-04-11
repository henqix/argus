rem ********************************************************************
rem * Filename          : db_sga_adv.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 12-DEC-2011
rem * Last Update       : 11-APR-2024
rem * Update            : New layout 
rem * Description       : Advice SGA Memory 
rem ********************************************************************

set lines 132
set pages 66

column SGA_SIZE format 99,999
column ESTD_BUFFER_CACHE_SIZE format 9,999,999 heading 'EST_BC_SIZE'
column ESTD_SHARED_POOL_SIZE  format 9,999,999 heading 'EST_SHPL_SIZE'
column SGA_SIZE_FACTOR format 999.999 heading 'SGA_SZ_FACT'
column ESTD_DB_TIME_FACTOR format 999.999 heading 'DB_TM_FACT'

select SGA_SIZE, SGA_SIZE_FACTOR, ESTD_DB_TIME, ESTD_DB_TIME_FACTOR, 
       ESTD_PHYSICAL_READS, ESTD_BUFFER_CACHE_SIZE, ESTD_SHARED_POOL_SIZE
from   v$sga_target_advice
/
