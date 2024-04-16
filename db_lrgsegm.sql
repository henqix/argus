rem ********************************************************************
rem * Filename          : db_lrgsegm.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 18-AUG-91
rem * Last Update       :  
rem * Update            :  
rem * Description       : Report large database segments
rem ********************************************************************

set pages 60
set lines 132

col own  format         a15 justify c heading 'Owner'
col seg  format         a30 justify c heading 'Segment Name'
col typ  format         a05 justify c heading 'Type'
col siz  format     999,990 justify c heading 'Size|(Gb)'
col ext  format     999,990 justify c heading 'Extents'

select substr(owner,1,15) own,
       substr(segment_name,1,30) seg,
       substr(segment_type,1,5) typ,
       round(bytes/1024/1024/1024) siz,
       extents ext
from   dba_segments
where  round(bytes/1024/1024/1024) > 1
/

