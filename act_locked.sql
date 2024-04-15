rem ********************************************************************
rem * Filename          : act_locked.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 10-AUG-94
rem * Last Update       : 27-FEB-02
rem * Description       : Monitor database locks
rem * Usage             : start db_locked.sql
rem ********************************************************************

set lines 132
set pages 60

col uname1 format a10 heading "Waiting User"
col oname1 format a15 heading "OS User"
col uname2 format a15 heading "Holding User"
col oname2 format a20 heading "OS User"
col ssid format 999 heading "Sid"
col mode_held format a4 heading "Held"
col mode_req format a4 heading "Req."
col object format a20 heading "Object"

break on id1 on sid

select substr(s1.username,1,15) uname1,
       substr(s1.osuser,1,15) oname1,
       w.sid ssid,
       decode(w.request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'RwSh',           /* L */
		3, 'RwEx',           /* R */
		4, 'Shar',           /* S */
		5, 'SSX ',           /* C */
		6, 'Excl',           /* X */
		to_char(w.request)) mode_req,
       substr(s2.username,1,10) uname2,
       substr(s2.osuser,1,16) oname2,
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
from   v$lock w,
       v$lock h,
       v$session s1,
       v$session s2,
       sys.obj$ o
where  h.lmode != 0
and    w.request != 0
and    h.lmode = w.request
and    w.id1 (+) = h.id1
and    w.sid = s1.sid (+)
and    h.sid = s2.sid (+)
and    o.obj# in (select l.id1
                 from v$lock l
                 where l.sid = w.sid
                 and l.id2 = 0
                 and l.lmode <> 0)
/

