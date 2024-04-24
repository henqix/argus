rem ********************************************************************
rem * Filename          : db_shpool.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 20-NOV-91
rem * Last Update       : 24/11/00  (HU)
rem * Update            : Type CURSOR added
rem * Description       : Report shared pool caching
rem ********************************************************************

set lines 132
set pages 60

col loads  format 99999
col pins   format 99999
col locks  format 99999
col memory format 999,999,999
col sharable_mem format 999,999,999

compute sum of sharable_mem on report
compute sum of memory on report
break on report

select type "Type",
       count(*) "Count",
       sum(sharable_mem) "Memory"
from v$db_object_cache
group by type
order by sum(sharable_mem) desc
/

select substr(owner,1,10) "Owner", 
       substr(name,1,10)||' - '||substr(type,1,15) "Name", 
       loads,
       pins,
       locks, 
       sharable_mem
from v$db_object_cache
where loads > 5
and type in ('PACKAGE','PACKAGE BODY','FUNCTION','PROCEDURE','TRIGGER')
order by 1,2
/

start rf_clea
