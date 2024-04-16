rem ********************************************************************
rem * Filename          : act_redolog.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 08-FEB-06
rem * Last Update       :  
rem * Update            : 
rem * Description       : Monitor Redolog Usage 
rem ********************************************************************

set lines 132
set pages 60

select to_char(first_time,'DD-MON-YY HH24')||':00' , 
       count(*) * 25 "Mb"
from   v$loghist
where  trunc(first_time) > sysdate - 4
group by 
       to_char(first_time,'DD-MON-YY HH24')
/
