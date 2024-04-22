rem ********************************************************************
rem * Filename          : db_forkey.sql - Version 1.1
rem * Author              Henk Uiterwijk
rem * Original          : 04-FEB-98
rem * Last Update       : 
rem * Description       : Report foreign key constraints 
rem ********************************************************************

set pages 60
set lines 132

col ct  format         a30 heading 'Child Table'
col cc  format         a12 heading 'Constraint'
col co  format         a20 heading 'Child Column'
col dr  format         a05 heading 'Delete Rule'
col pt  format         a20 heading 'Parent Table'
col pc  format         a20 heading 'Parent Column'

select substr(a.table_name,1,30) ct,
       substr(a.constraint_name,1,12) cc,
       substr(b.column_name,1,20) co,
       substr(a.delete_rule,1,5) dr,
       substr(c.table_name,1,20) pt,
       substr(c.column_name,1,20) pc
from   dba_constraints a,
       dba_cons_columns b,
       dba_ind_columns c
where  a.owner = upper('&OWN')
and    a.owner = b.owner
and    b.owner = c.index_owner
and    a.constraint_type = 'R'
and    a.constraint_name = b.constraint_name
and    a.r_constraint_name = c.index_name
order by a.table_name
/
