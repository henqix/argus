rem ********************************************************************
rem * Filename          : db_products.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 14-AUG-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report database registered products
rem ********************************************************************

set lines 132
set pages 60

column schema  format a20
column product format a40
column version format a15

select schema, substr(comp_name,1,40) "PRODUCT", version, modified, status
from dba_registry
order by 1
/

