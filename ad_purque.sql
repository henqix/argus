rem ********************************************************************
rem * Filename          : ad_purque.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 17-nov-07
rem * Last Update       : 
rem * Update            : 
rem * Description       : Purge AQ Queues
rem ********************************************************************

set pages 999

DECLARE
po dbms_aqadm.aq$_purge_options_t;

BEGIN
dbms_aqadm.purge_queue_table(queue_table => 'SYS.ALERT_QT',purge_condition => null, purge_options => po);
end;
/

