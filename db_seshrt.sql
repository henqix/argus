rem ********************************************************************
rem * Filename          : db_seshrt.sql - Version 2.2
rem * Author            : Henk Uiterwijk
rem * Original          : 12-jan-98
rem * Last Update       : 21-sep-99
rem * Update            : Physical reads column added
rem * Description       : Monitor database session hitrate
rem * Usage             : start db_seshrt.sql
rem ********************************************************************

set lines 132
set pages 60

col sid heading 'SID' format 9999
col osuser heading 'OS|User' format a30
col username heading 'ORA|User' format a15
col terminal heading 'Term' format a20
col logical heading 'Logical|Reads' format 99999999
col physical heading 'Physical|Reads' format 99999999
col hit_ratio heading 'Hit|ratio' format 999.99

select  b.sid
,       b.osuser
,       b.username
,       substr(b.terminal,1,20) "Terminal"
,consistent_gets+ block_gets "Logical"
,       physical_reads "Physical" 
, ( 1 - physical_reads/decode(consistent_gets+block_gets,0,1,
        consistent_gets+block_gets)) * 100 hit_ratio
from v$sess_io a
, v$session b
where a.sid = b.sid
and     b.osuser is not null
and     b.username is not null
--and     consistent_gets+ block_gets > 2500
order by hit_ratio desc
/


