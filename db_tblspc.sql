rem ********************************************************************
rem * Filename          : db_tblspc.sql - Version 2.0
rem * Author              Henk Uiterwijk
rem * Original          : 20-NOV-91
rem * Last Update       : 14/09/98  (HU)
rem * Update            : No longer use of view, but use subselect
rem * Description       : Report tablespace space
rem ********************************************************************

set pages 60
set lines 132

comp sum of nfrags totsiz avasiz on report
break on report

col tsname  format        a25 justify c heading 'Tablespace'
col nfrags  format      9,990 justify c heading 'Free|Frags'
col mxfrag  format    999,990 justify c heading 'Largest|Frag (Gb)'
col totsiz  format 999,990.99 justify c heading 'Total|(Gb)'
col avasiz  format 999,990.99 justify c heading 'Available|(Gb)'
col pctusd  format     990.99 justify c heading 'Pct|Used'
col autext  format 999,990.99 justify c heading 'MaxExt|(Gb)'

select
  tname                                 tsname,
  fbytes                                nfrags,
  mbytes                                mxfrag,
  tbytes                                totsiz,
  abytes                                avasiz,
--  100 - ( 100 * abytes / exsb)          pctusd,
  decode(exsb,0,100 * (tbytes - abytes) / tbytes,( 100 * (tbytes - abytes) / exsb))     pctusd,
  exsb                                  autext
from
  (select tablespace_name               as tname,
   sum(bytes)/1024/1024/1024            as tbytes,
   sum(maxbytes)/1024/1024/1024         as exsb
   from dba_data_files
   group by tablespace_name
   union
   select tablespace_name               as tname,
   sum(bytes)/1024/1024/1024            as tbytes,
   sum(maxbytes)/1024/1024/1024         as exsb
   from dba_temp_files
   group by tablespace_name)
  ,
  (select tablespace_name               fname,
   count(bytes)                         as fbytes,
   max(bytes)/1024/1024/1024            as mbytes,
   sum(bytes)/1024/1024/1024            as abytes
   from dba_free_space
   group by tablespace_name)
where tname = fname (+)
   order by 1;

