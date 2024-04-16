rem ********************************************************************
rem * Filename          : db_audopts.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 27-FEB-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report audit options
rem ********************************************************************

set pages 60
set lines 132

column username  format a20
column object    format a20 

select substr(owner,1,20) username,
       substr(object_name,1,20) object, 
       alt, aud, com, del, gra, ind, ins, loc, ren, sel, upd, ref, exe, cre, rea, wri
from   dba_obj_audit_opts
where  owner like '%&own%'
and    object_name like '%&obj%'
order by 1,2
/

