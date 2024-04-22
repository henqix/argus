rem ********************************************************************
rem * Filename          : db_fra_usage.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show usage of Flashback Recovery Area
rem ********************************************************************

set lines 132
set pages 60

column fra_name format a30

select substr(name,1,30) FRA_NAME, SPACE_LIMIT / 1024 / 1024 MAX_LIMIT, SPACE_USED/1024/1024 SPACE_USED, SPACE_RECLAIMABLE/1024/1024 SPACE_RECLAIMABLE
from  V$RECOVERY_FILE_DEST
/

select * from V$FLASH_RECOVERY_AREA_USAGE
/
