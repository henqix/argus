rem ********************************************************************
rem * Filename          : db_compcons.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 31-JUL-00
rem * Last Update       : 
rem * Update            : 
rem * Description       : Compare differences in referential constraints
rem ********************************************************************

set pages 60
set lines 132

accept u1 char prompt 'Schema owner 1 '
accept u2 char prompt 'Schema owner 2 '

select a.table_name, a.constraint_name
from dba_constraints a
where a.owner = '&&u1'
and   a.constraint_type = 'R'
and not exists (select 1
                from dba_constraints b
                where a.table_name = b.table_name
                and   a.constraint_name = b.constraint_name
                and   b.owner = '&&u2')
/
