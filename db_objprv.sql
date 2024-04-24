rem ********************************************************************
rem * Filename          : db_objprv.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 26-SEP-96
rem * Last Update       : 
rem * Description       : Report object privilieges occupation
rem ********************************************************************

set pages 60
set lines 132

break on gr skip 1

col gr format      a20 justify c heading 'Grantee'
col ow format      a20 justify c heading 'Object owner'
col pr format      a20 justify c heading 'Privilege'
col gt format      a04 justify c heading 'Grnt'
col nb format      999 justify c heading ' # '

select substr(grantee,1,20) gr,
       substr(owner,1,20) ow,
       substr(privilege,1,20) pr,
       grantable gt,
       count(*) nb
from dba_tab_privs
group by grantee, owner, privilege, grantable
order by 1,2,3
/

