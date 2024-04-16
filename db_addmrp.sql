rem ********************************************************************
rem * Filename          : db_addmrp.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Report Database ADDM
rem ********************************************************************

set pages 60
set lines 132

column dbnam new_value dbnam noprint
column rpdat new_value rpdat noprint

select substr(value,1,10) dbnam,
       to_char(sysdate,'DDMMYY') rpdat
from   v$parameter
where  name = 'db_name';

set long 1000000
set pages 50000
column get_clob format a80

select dbms_advisor.get_task_report(task_name, 'TEXT', 'ALL')
as ADDM_report
from dba_advisor_tasks
where task_id = (select max(t.task_id)
                 from dba_advisor_tasks t, dba_advisor_log l
                 where t.task_id = l.task_id
                 and t.advisor_name = 'ADDM'
                 and l.status = 'COMPLETED');


