rem ********************************************************************
rem * Filename          : act_transx.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 06-JAN-06
rem * Last Update       : 12-JUL-06
rem * Update            : Use # extents info from v$rollstat
rem *                   : 
rem * Description       : Monitor Transaction Information
rem ********************************************************************

set lines 132
set pages 60

column SID      format 9999
column User     format a15
column hrt      format 999.99

select s.sid "SID", 
       substr(s.osuser,1,15) "User", 
       substr(t.status,1,3) "Sta",
       t.xidusn "RBS#", 
       t.used_ublk "RBS blcks",
       q.extents "RBS Exts", 
       substr(r.name,1,10) "Segment", 
       t.log_io "LOG IO", 
rem ********************************************************************
rem * Filename          : act_transx.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 06-JAN-06
rem * Last Update       : 12-JUL-06
rem * Update            : Use # extents info from v$rollstat
rem *                   : 
rem * Description       : Monitor Transaction Information
rem ********************************************************************

set lines 132
set pages 60

column SID      format 9999
column User     format a15
column hrt      format 999.99

select s.sid "SID", 
       substr(s.osuser,1,15) "User", 
       substr(t.status,1,3) "Sta",
       t.xidusn "RBS#", 
       t.used_ublk "RBS blcks",
       q.extents "RBS Exts", 
       substr(r.name,1,10) "Segment", 
       t.log_io "LOG IO", 
	   t.cr_get "CR_GET",
       t.phy_io "PHY IO"
--       100 * (1 - (t.log_io + t.cr_get) / t.phy_io) "HRT" 
from   v$session s,
       v$transaction t,
       v$rollname r,
       v$rollstat q      
where  s.saddr = t.ses_addr
and    t.xidusn = r.usn
and    t.xidusn = q.usn
/
