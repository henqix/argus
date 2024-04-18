rem ********************************************************************
rem * Filename          : db_filerds.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 16-MAY-98
rem * Last Update       : 18-APR-24
rem * Update            : 
rem * Description       : Report datafile reads
rem ********************************************************************

set pages 60
set lines 132

break on report

col name      format           a30 justify c heading 'Datafile name'
col phrds     format 9,999,999,990 justify c heading 'Phys. reads'
col blkrd     format 9,999,999,990 justify c heading 'Phys. blk.rd|Single block'
col sngblkrds format 9,999,999,990 justify c heading 'Single Block|Reads Total'
col readtim   format 9,999,999,990 justify c heading 'Read time|Total'
col sbrt      format       999,990 justify c heading 'Read time|Single Block'
col avgiot    format       999,990 justify c heading 'Read time|Average'

select substr(file_name,instr(file_name,'/',-1)+1,30) "Name",
       phyrds "Phrds",
	   phyblkrd "Blkrd",
	   singleblkrds "Sngblkrds",
       READTIM "Readtim",
	   SINGLEBLKRDTIM "Sbrt",
	   AVGIOTIM "Avgiot"
from v$filestat, sys.dba_data_files
where file# = file_id
order by file_name;

