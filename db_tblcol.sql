rem ********************************************************************
rem * Filename          : db_tblcol.sql - Version 2.0
rem * Author              Henk Uiterwijk
rem * Original          : 13-JAN-00
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report table columns
rem ********************************************************************

set pages 60
set lines 132

break on owner skip page

col owner     format         a20 justify c heading 'Owner'
col table     format         a25 justify c heading 'Table name'
col column    format         a25 justify c heading 'Column Name'
col column_id format         999 justify c heading 'Col#'
col datatyp   format          a9 justify c heading 'Datatype'
col length    format         a10 justify c heading 'Length'

select substr(owner,1,20),
       substr(table_name,1,25),
       substr(column_name,1,25),
	   column_id, 
       data_type "Datatyp",
decode(data_type,'NUMBER',
       decode(nvl(data_scale,0),0,to_char(nvl(data_precision,22)),
             '('||to_char(data_precision)||','||to_char(data_scale)||')'),
              to_char(data_length)) "Length"
from   dba_tab_columns
where  owner like upper('%&table_owner%')
order by owner, table_name, column_id
/
