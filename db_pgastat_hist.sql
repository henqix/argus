rem ********************************************************************
rem * Filename          : db_pgastat_hist.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show PGA status history
rem ********************************************************************

set lines 132
set pages 60

column processes format a30
column total_pga format a30

select a.snap_id, 
       a.name "Processes", 
	   a.value "#Procs", 
	   b.name "Total_PGA", 
	   b.value/1024/1024 "Mbytes"
from   DBA_HIST_PGASTAT a,
       DBA_HIST_PGASTAT b
where  a.snap_id = b.snap_id
and    a.name = 'process count'
and    b.name = 'total PGA allocated'
order by 1
/
