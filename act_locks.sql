rem ********************************************************************
rem * Filename          : act_locks.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 10-AUG-94
rem * Last Update       : 17-DEC-99
rem * Description       : Monitor database locks
rem ********************************************************************

set pages 60
set lines 132

col ssid format A6 heading "Sid"
col mode_held format a10 heading "Mode Held"
col mode_req format a10 heading "Mode Req."
col name format A25 heading "Object"
col uname format a10 heading "User"
col id1 format 9999999999 heading "Id"
break on id1 on sid
select b.type,
        lpad(' ',decode(a.request,0,0,3))||a.sid ssid,
        d.username uname,
	decode(a.lmode, 
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-Share',      /* L */
		3, 'Row-ExclX',      /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(a.lmode)) mode_held,
         decode(a.request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-Share',      /* L */
		3, 'Row-Excl',       /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(a.request)) mode_req,
        c.name,
        b.id1
 from sys.obj$ c,v$lock b,v$lock a, v$session d
  where a.sid = b.sid
  and   a.sid = d.sid
  and   c.obj# = b.id1
  and   a.request <> 0
order by a.sid,a.request,c.name
/

