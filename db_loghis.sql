rem ********************************************************************
rem * Filename          : db_loghis.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 04-JAN-02
rem * Last Update       :  
rem * Update            :  
rem * Description       : Monitor Database Logfile History
rem ********************************************************************

set lines 132
set pages 60

col "0-2" for 999
col "2-4" for 999
col "4-6" for 999
col "6-8" for 999
col "8-10" for 999
col "10-12" for 999
col "12-14" for 999
col "14-16" for 999
col "16-18" for 999
col "18-20" for 999
col "20-22" for 999
col "22-24" for 999
col "DAY" for A5
col "Total" for 9999

SELECT  trunc(FIRST_TIME) "Date",
        to_char(FIRST_TIME, 'Dy') "Day",
        count(1) "Total",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'00',1,0)) + 
 SUM(decode(to_char(FIRST_TIME, 'hh24'),'01',1,0)) "0-2",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'02',1,0)) + 
 SUM(decode(to_char(FIRST_TIME, 'hh24'),'03',1,0)) "2-4",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'04',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'05',1,0)) "4-6",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'06',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'07',1,0)) "6-8",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'08',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'09',1,0)) "8-10",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'10',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'11',1,0)) "10-12",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'12',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'13',1,0)) "12-14",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'14',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'15',1,0)) "14-16",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'16',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'17',1,0)) "16-18",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'18',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'19',1,0)) "18-20",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'20',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'21',1,0)) "20-22",
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'22',1,0)) +
        SUM(decode(to_char(FIRST_TIME, 'hh24'),'23',1,0)) "22-24"
FROM    V$LOGHIST
where   FIRST_TIME > sysdate-30
group by trunc(FIRST_TIME), to_char(FIRST_TIME, 'Dy')
Order by 1
/
