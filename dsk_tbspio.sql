rem ********************************************************************
rem * Filename          : dsk_tbspio.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 28-NOV-05
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor tablespace I/O
rem * Usage             : start dsk_tbspio.sql
rem ********************************************************************

set lines 255
set pages 60

break on report

column spr format 999,999,999,999 heading "Total reads"
column ppr format 90.99           heading "Perc. reads"
column spw format 999,999,999,999 heading "Total writes"
column ppw format 90.99           heading "Perc. writes"


select tablespace_name, 
       sum(PHYRDS) spr, 
       (sum(PHYRDS)/TOTRDS * 100) ppr, 
       sum(PHYWRTS) spw, 
       (sum(PHYWRTS)/TOTWRTS * 100) ppw
from v$filestat,
     (select sum(PHYRDS) as TOTRDS,
        sum(PHYWRTS) as TOTWRTS
     from v$filestat),
     dba_data_files
where file_id = file#
group by tablespace_name, TOTRDS, TOTWRTS  
order by 2 desc
/
