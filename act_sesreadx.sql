rem *************************************************************************
rem * Filename          : db_sesreadx.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 07-jan-2002
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database start executable (session reads)
rem **************************************************************************

set feedback off
set serveroutput on

create table ses_reads (
 SEQNO             NUMBER,
 NAME              VARCHAR2(50),
 VALUE             NUMBER);

@act_sesread
execute dbms_lock.sleep(5)
@act_sesread
execute dbms_lock.sleep(5)
@act_sesread
execute dbms_lock.sleep(5)
@act_sesread
execute dbms_lock.sleep(5)
@act_sesread

drop table ses_reads;
