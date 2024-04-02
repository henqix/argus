rem ********************************************************************
rem * Filename          : db_indcst.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Calculate costs for index usage and advise parameter 
rem * Usage             : start db_indcst.sql
rem ********************************************************************

set lines 132
set pages 60

col a1 head "avg. wait time|(db file sequential read)"
col a2 head "avg. wait time|(db file scattered read)"
col a3 head "new setting for|optimizer_index_cost_adj"

select a.average_wait a1,
       b.average_wait a2,
       round( ((a.average_wait/b.average_wait)*100) ) a3
from   v$system_event a,
       v$system_event b
where  a.event = 'db file sequential read'
and    b.event = 'db file scattered read';
