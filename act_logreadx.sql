rem ********************************************************************
rem * Filename          : db_logreadx.sql - Version 1.1
rem * Author            : Henk Uiterwijk
rem * Original          : 14-apr-2000
rem * Last Update       : 04-jan-2001
rem * Update            : 
rem * Description       : Monitor database start executable (logical reads) uses db_logread
rem ********************************************************************

set feedback off
set serveroutput on

create table log_reads (
 SEQNO             NUMBER,
 SID               NUMBER,
 USERNAME          VARCHAR2(30),
 OSUSER            VARCHAR2(30),
 LOGICAL_READS     NUMBER);

@db_logread
execute dbms_lock.sleep(5)
@db_logread
execute dbms_lock.sleep(5)
@db_logread
execute dbms_lock.sleep(5)
@db_logread
execute dbms_lock.sleep(5)
@db_logread

drop table log_reads;
