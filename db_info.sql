rem ********************************************************************
rem * Filename          : db_info.sql - Version 1.0
rem * Author            : Henk Uiterwijk, Xerxes Consultancy BV
rem * Original          : 17-may-2000
rem * Description       : Database startup/create information (Oracle8)
rem * Usage             : sqlplus @db_info
rem ********************************************************************

set feedback off
set pages 66
set lines 132

set heading off

select name "Database",
       created "Created",
       log_mode "Status"
from v$database;

select 'Database startup time : '
       ||to_char(startup_time,'dd-MON-yyyy') 
       ||'  '
       ||to_char(startup_time,'hh24:mi:ss')
from v$instance a;

select banner "Current versions"
from v$version;

set heading on
