rem ********************************************************************
rem * Filename          : db_patches.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-17
rem * Update            : 
rem * Description       : List Oracle patches
rem ********************************************************************

set lines 132
set pages 60

column comments 	format a25
column namespace    format a20
column action       format a15

select trunc(ACTION_TIME) "DATE", 
       ACTION, 
       NAMESPACE, 
       VERSION, 
       substr(COMMENTS,1,25) "COMMENTS"
from   sys.registry$history
/
