rem ********************************************************************
rem * Filename          : db_filewrt.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-MAY-98
rem * Last Update       : 18-APR-24
rem * Update            : 
rem * Description       : Report datafile writes
rem ********************************************************************

set pages 60
set lines 132

break on report

col name      format           a30 justify c heading 'Datafile name'
col phywrt    format 9,999,999,990 justify c heading 'Physical|writes'
col blkwrt    format 9,999,999,990 justify c heading 'Phys. blk.wr|Single block'
col writetim  format 9,999,999,990 justify c heading 'Write time|Total'
col maxiowt   format       999,990 justify c heading 'Write time|Maximal'

select substr(file_name,instr(file_name,'/',-1)+1,30) "Name",
       phywrts "Phywrt",
	   phyblkwrt "Blkwrt",
       WRITETIM "Writetim",
	   MAXIOWTM "Maxiowt"
from v$filestat, sys.dba_data_files
where file# = file_id
order by file_name;

