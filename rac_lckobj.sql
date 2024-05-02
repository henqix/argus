rem ********************************************************************
rem * Filename          : rac_lckobj.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show locked objects for RAC
rem ********************************************************************

set lines 132
set pages 60

select l.INST_ID, l.SESSION_ID, l.ORACLE_USERNAME, l.OS_USER_NAME, o.NAME
from   gv$locked_object l, obj$ o
where  l.OBJECT_ID = o.obj#
/
