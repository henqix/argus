rem ********************************************************************
rem * Filename          : db_dblinks.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 05-APR-01
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report database links
rem ********************************************************************

set pages 60
set lines 132

select substr(owner,1,15) "Owner",
       substr(db_link,1,25) "Link",
       substr(username,1,15) "User",
       substr(host,1,65) "Host"
from dba_db_links
order by upper(host)
/

