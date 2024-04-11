rem ********************************************************************
rem * Filename          : db_sesmem.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 13-JAN-06
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor PGA/UGA usage
rem ********************************************************************

set pages 60
set lines 132

COLUMN sid                     FORMAT 9999           HEADING 'SID'
COLUMN os_username             FORMAT a15            HEADING 'O/S User'  
COLUMN session_program         FORMAT a18            HEADING 'Session Program' TRUNC
COLUMN session_machine         FORMAT a15            HEADING 'Machine' TRUNC
COLUMN session_pga_memory      FORMAT 9,999,999      HEADING 'PGA Memory'
COLUMN session_pga_memory_max  FORMAT 9,999,999      HEADING 'PGA Memory Max'
COLUMN session_uga_memory      FORMAT 9,999,999      HEADING 'UGA Memory'
COLUMN session_uga_memory_max  FORMAT 9,999,999      HEADING 'UGA Memory MAX'

compute sum of session_pga_memory on report
compute sum of session_pga_memory_max on report
compute sum of session_uga_memory on report
compute sum of session_uga_memory_max on report

break on report


SELECT
    s.sid                sid
  , substr(s.osuser,1,15)   os_username
  , s.program            session_program
  , substr(s.machine,1,15)    session_machine
  , (select ss.value/1024 from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session pga memory')        session_pga_memory
  , (select ss.value/1024 from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session pga memory max')    session_pga_memory_max
  , (select ss.value/1024 from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session uga memory')        session_uga_memory
  , (select ss.value/1024 from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session uga memory max')    session_uga_memory_max
FROM 
    v$session  s
WHERE s.type <> 'BACKGROUND'
ORDER BY session_pga_memory DESC
/
