rem ********************************************************************
rem * Filename          : db_alllcks.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 10-AUG-94
rem * Last Update       : 27-FEB-02
rem * Description       : Monitor database locks (w/o waiters)
rem * Usage             : start db_alllcks.sql
rem ********************************************************************

set lines 132
set pages 60

col uname1 format a10 heading "Holding User"
col oname1 format a10 heading "OS User"
col ssid format 999 heading "Sid"
col mode_held format a4 heading "Held"
col object format a20 heading "Object"

break on id1 on sid

select substr(s.username,1,10) uname1,
       substr(s.osuser,1,8) oname1,
       h.sid ssid,
       decode(h.lmode, 
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'RwSh',           /* L */
		3, 'RwEx',           /* R */
		4, 'Shar',           /* S */
		5, 'SSX',            /* C */
		6, 'Excl',           /* X */
		to_char(h.lmode)) mode_held,
       substr(o.name,1,20) object
from   v$lock h,
       v$session s,
       sys.obj$ o
where  h.lmode != 0
--and    w.request != 0
--and    h.lmode = w.request
--and    w.id1 (+) = h.id1
--and    w.sid = s1.sid (+)
and    h.sid = s.sid (+)
and    o.obj# = h.id1
/
