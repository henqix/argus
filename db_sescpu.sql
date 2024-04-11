rem ********************************************************************
rem * Filename          : db_sescpu.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show CPU usage per session
rem ********************************************************************

set lines 132
set pages 60

column  SIDSER format a10 heading "Sid/Ser"
column  OS_USER format a20
column  USER_MACHINE format a25 
column  SCHEMA format a10
column  PROGRAM format a15
column  STATUS format a3 

SELECT 	u.sid||':'||u.serial# SIDSER,
        u.osuser OS_USER,
       	u.machine USER_MACHINE,
	    SUBSTR(u.username,1,12) SCHEMA,
	    (s.cpu_time/1000000) "CPU_Seconds",
	    s.module "Program",
	    substr(u.status,1,3) STATUS
--      s.sql_text
FROM    v$sql s,
        v$session u
WHERE   s.hash_value = u.sql_hash_value
--AND     sql_text NOT LIKE '%from v$sql s, v$session u%'
AND     u.terminal IS NOT NULL
AND     u.username IS NOT NULL
ORDER BY cpu_time DESC nulls last
/
