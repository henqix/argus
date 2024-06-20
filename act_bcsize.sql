rem ********************************************************************
rem * Filename          : act_bcsize.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show current used buffer cache
rem ********************************************************************

set lines 132
set pages 60

column cbc    format 999,999 heading "Cur BC (Mb)"
column pval   format a10     heading "Block size"
column bcnt   format 999,999 heading "# Buf"
column cbs    format 999,999 heading "BC Siz (Mb)"
column upct   format 999.99  heading "Pct used"

select sbytes / 1024 / 1024 cbc,
       pval,
	   bcnt,
	   bcnt* pval / 1024 / 1024 cbs,
	   bcnt * pval / sbytes * 100 upct
from
(select s.bytes as sbytes
 from   v$sgainfo s 
 where  s.name = 'Buffer Cache Size'),
( select value as pval 
  from v$parameter 
  where name = 'db_block_size'),
( select count(*) as bcnt
  from v$bh)
/
