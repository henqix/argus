rem ********************************************************************
rem * Filename          : db_indexcols.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 21-FEB-00
rem * Last Update       : 02-MAR-06
rem * Update            : Add three facultative parameters
rem * Description       : Report index columns
rem ********************************************************************

set pages 60
set lines 132

accept own    prompt 'Owner   : '
accept tname  prompt 'Table   : '
accept iname  prompt 'Index   : '

break on tbl on ind skip 1

col tbl       format      a30 heading 'Table'
col ind       format      a30 heading 'Index'
col col       format      a30 heading 'Column'
col seq       format      999 heading 'Pos'

select
  substr(table_name,1,30) tbl,
  substr(index_name,1,30) ind,
  substr(column_name,1,30) col,
  column_position seq
from
  sys.dba_ind_columns
where
  index_owner like nvl(upper('&own'),'%')
and
  table_name like nvl(upper('&tname'),'%')
and
  index_name like nvl(upper('&iname'),'%')
  order by 1,2,4
/

