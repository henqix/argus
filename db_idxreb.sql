rem ********************************************************************
rem * Filename          : db_idxreb.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 27-JAN-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Report indexes to be rebuild
rem ********************************************************************


column index_name format a40

select /*+ ordered */
  'alter index '||u.name ||'.'|| o.name||' rebuild;'
from
  sys.ind$  i,
  sys.icol$  ic,
  sys.hist_head$  h,
  ( select
      kvisval  value
    from
      sys.x$kvis
    where
      kvistag = 'kcbbkl' )  p,
  sys.obj$  o,
  sys.user$  u
where
  i.leafcnt > 1 and
  i.type# in (1,4,6) and		-- exclude special types
  ic.obj# = i.obj# and
  h.obj# = i.bo# and
  h.intcol# = ic.intcol# and
  o.obj# = i.obj# and
  o.owner# != 0 and
  u.user# = o.owner#
group by
  u.name,
  o.name,
  i.rowcnt,
  i.leafcnt,
  i.initrans, 
  i.pctfree$,
  p.value
having
  50 * i.rowcnt * (sum(h.avgcln) + 11) 
  < (i.leafcnt * (p.value - 66 - i.initrans * 24)) * (50 - i.pctfree$) and
  floor((1 - i.pctfree$/100) * i.leafcnt -
    i.rowcnt * (sum(h.avgcln) + 11) / (p.value - 66 - i.initrans * 24)
  ) > 1000
order by
  3 desc, 2
/

