rem ********************************************************************
rem * Filename          : dsk_ftscan.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 24-jun-98
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database full table scan
rem * Usage             : start dsk_ftscan.sql
rem ********************************************************************


set lines 255
set pages 60

col sid heading 'SID' format 999
col osuser heading 'ORA|User' format a12
col logical_Reads format 999,999,999
col hitrate heading 'Hitrate' format 999.99
col tfbr heading 'Fetch|Rowid' format 999,999,999
col tfcr heading 'Fetch|chain' format 99,999,999
col tcbg heading 'Scan|short' format 999,999,999
col tcrg heading 'Scan|long' format 999,999,999
col tslt heading 'Scan|blck' format 99,999,999

select  b.sid
,       substr(b.osuser,1,12) osuser
,       consistent_gets+ block_gets "log reads" 
,       ( 1 - physical_reads/decode(consistent_gets+block_gets,0,1,
        consistent_gets+block_gets)) * 100 hitrate 
,       c.value tfbr
,       d.value tfcr
,       e.value tcbg
,       g.value tcrg
,       (f.value - (e.value*4)) tslt
from v$sess_io a
, v$session b
, v$sesstat c
, v$sysstat cc
, v$sesstat d
, v$sysstat dd
, v$sesstat e
, v$sysstat ee
, v$sesstat f
, v$sysstat ff
, v$sesstat g
, v$sysstat gg
where a.sid = b.sid
and     b.osuser is not null
and     b.username is not null
and     b.sid = c.sid
and     c.statistic# = cc.statistic#
and     cc.name like '%table fetch by rowid%'
and     b.sid = d.sid
and     d.statistic# = dd.statistic#
and     dd.name like '%table fetch continued%'
and     b.sid = e.sid
and     e.statistic# = ee.statistic#
and     ee.name like '%table scans (short%'
and     b.sid = f.sid
and     f.statistic# = ff.statistic#
and     ff.name like '%table scan blocks%'
and     b.sid = g.sid
and     g.statistic# = gg.statistic#
and     gg.name like '%table scans (long%'
order by hitrate desc
/

