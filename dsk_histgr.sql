rem ********************************************************************
rem * Filename          : dsk_histgr.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show histograms and events for datafiles
rem ********************************************************************

set lines 132
set pages 60

column DATAFILE   format a80
column AVGRDTIM   format 999.99
column AVGWAITTIM format 999.99

select d.file_name DATAFILE, 
       sum(f.singleblkrdtim_milli*f.singleblkrds) / sum(f.singleblkrds) AVGRDTIM,
       max(f.singleblkrdtim_milli) MAXRDTIM
from v$file_histogram f, dba_data_files d
where f.file# = d.file_id
group by d.file_name
/

select e.event,
       sum(e.wait_time_milli*e.wait_count) / sum(e.wait_count) AVGWAITTIM, 
       max(e.wait_time_milli) MAXWAITTIM
from v$event_histogram e
where e.event like 'db file%'
group by e.event
/
