rem ********************************************************************
rem * Filename          : db_libcache.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 20-MEI-97
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report library cache tenants
rem ********************************************************************

def aps_prog    = 'rd_libcac.sql'
def aps_title   = 'Report Library Cache Information'
start rh_ttlp

compute sum of parsed_size on report
compute sum of code_size on report
break on report

select substr(a.owner,1,15) "Owner",
       substr(a.name,1,20) "Object",
       b.parsed_size ,
       b.code_size,
       decode(a.type,'PACKAGE','HEA','PACKAGE BODY','BOD','UNK')
from v$db_object_cache a,
     dba_object_size b
where a.owner = b.owner
and   a.name  = b.name
and   a.type  = b.type
and   a.type in ('PACKAGE','PACKAGE BODY')
order by a.owner, a.name
/
