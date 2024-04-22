rem ********************************************************************
rem * Filename          : db_autoext.sql - Version 2.0
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

col tsname  format         a25 justify c heading 'Tablespace'
col nfrags  format       9,990 justify c heading 'Free|Frags'
col mxfrag  format 999,999,990 justify c heading 'Largest|Frag (Mb)'
col totsiz  format 999,999,990 justify c heading 'Total|(Mb)'
col avasiz  format 999,999,990 justify c heading 'Available|(Mb)'
col pctusd  format         990 justify c heading 'Pct|Used'
col autoext format         A03 justify c heading 'Ext'

select
  tname                                 tsname,
  fbytes                                nfrags,
  mbytes                                mxfrag,
  tbytes                                totsiz,
  abytes                                avasiz,
  100 - (100 * abytes / tbytes)         pctusd,
  aext                                  autoext
from
  (select d.tablespace_name             as tname,
   sum(d.bytes)/1024/1024               as tbytes,
   decode(f.maxextend,null,'N','Y')     as aext
   from dba_data_files d,
        sys.filext$ f
   where d.file_id = f.file# (+)
   group by d.tablespace_name,
            decode(f.maxextend,null,'N','Y')
   union
   select tablespace_name               as tname,
   sum(bytes)/1024/1024                 as tbytes,
   'N'
   from dba_temp_files
   group by tablespace_name)
  ,
  (select tablespace_name               fname,
   count(bytes)                         as fbytes,
   max(bytes)/1024/1024                 as mbytes,
   sum(bytes)/1024/1024                 as abytes
   from dba_free_space
   group by tablespace_name)
where tname = fname (+);

