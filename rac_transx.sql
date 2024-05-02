rem ********************************************************************
rem * Filename          : rac_transx.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 06-JAN-06
rem * Last Update       : 12-JUL-06
rem * Update            : Use # extents info from v$rollstat
rem *                   : 
rem * Description       : Monitor Cluster Transaction Information
rem ********************************************************************

set pages 60
set lines 132

column SID      format 9999
column User     format a15
column hrt      format 99.99


select s.inst_id "INST",
       s.sid "SID", 
       substr(s.osuser,1,15) "User", 
       substr(t.status,1,3) "Sta",
       t.xidusn "RBS", 
       t.used_ublk "RBS blcks",
       q.extents "RBS Exts", 
       substr(r.name,1,10) "RBS", 
       t.log_io "LOG IO", 
       t.phy_io "PHY IO",
       100 * (1 - t.phy_io / t.log_io) "HRT" 
from   gv$session s,
       gv$transaction t,
       v$rollname r,
       gv$rollstat q      
where  s.saddr = t.ses_addr
and    s.inst_id = t.inst_id
and    t.xidusn = r.usn
and    t.xidusn = q.usn
and    t.inst_id = q.inst_id
/

