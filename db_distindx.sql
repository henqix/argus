rem **********************************************************************************
rem * Filename          : db_distindx.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Check distinctness of index 
rem * Description       : run analyze index <index_name> validate structure in advance 
rem **********************************************************************************

set lines 132
set pages 60

column name format a25
column perc format 999.99

select name, LF_ROWS, distinct_keys, most_repeated_key, 
       DISTINCT_KEYS / LF_ROWS * 100 "PERC"
from   index_stats
where  lf_rows > 0
/
