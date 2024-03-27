rem ********************************************************************
rem * Filename          : db_sorts.sql - Version 1.0
rem * Author            : Henk Uiterwijk, Xerxes Consultancy BV
rem * Original          : 29-JAN-2001
rem * Description       : Monitor database sorting status
rem * Usage             : sqlplus &un/&pw @db_sorts
rem ********************************************************************

set lines 132
set pages 60

col sn      format           a40 heading "Sort status"
col val     format 9,999,999,999 heading "Value"

select substr(name,1,40) sn,
       value val
from v$sysstat
where name like '%sort%'
/




