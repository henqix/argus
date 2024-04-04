rem ********************************************************************
rem * Filename          : db_jobque.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 30-mar-2000
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database job queue
rem * Usage             : start db_jobque.sql
rem ********************************************************************

set pages 60
set liones 132
ttitle off

col what        format a50
col job_user    format a20
col job         format 9999
col next_exec   format a08
col own         format a15
col run_date    format a20
col run_status  format a12
col next_run    format a20
col duration    format a15

set heading off
select 'All Jobs' from sys.dual; 
set heading on

select job,what,
       substr(log_user,1,20) JOB_USER, 
       last_date,
       next_date,
       substr(next_sec,1,8) next_exec,
       total_time,
       failures,
       broken 
from   dba_jobs
order by 1
/

set heading off
select 'All Running Jobs' from sys.dual; 
set heading on

select sid,
       r.job,
       log_user,
       r.this_date,
       r.this_sec
from   dba_jobs_running r,
       dba_jobs j
where  r.job=j.job
order by 1
/

set heading off
select 'All Scheduled Jobs' from sys.dual; 
set heading on

select substr(s.owner,1,15) own, 
       s.job_name, 
       to_char(d.log_date,'DD-MON-YY HH24:MI:SS') run_date, 
       substr(d.status,1,20) run_status, 
       to_char(s.next_run_date,'DD-MON-YY HH24:MI:SS') next_run,
       d.run_duration duration
from   dba_scheduler_jobs s, 
       dba_scheduler_job_run_details d
where  s.job_name = d.job_name
and    s.enabled = 'TRUE'
and    d.log_date = (select max(d2.log_date)
                     from    dba_scheduler_job_run_details d2
                     where   d.job_name = d2.job_name)
order by 1,2
/

column ELAPSED_TIME format a20
column CPU_USED     format a20

set heading off
select 'All Scheduled Jobs Running' from sys.dual; 
set heading on

select OWNER, 
       JOB_NAME, 
       ELAPSED_TIME, 
       CPU_USED 
from   dba_SCHEDULER_RUNNING_JOBS
order by 1,2
/

