rem ******************************************************************************************
rem * Filename          : act_pwritx.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 04-jan-2000
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database actual physical writes (executable icw act_phwrit)
rem *******************************************************************************************

set feedback off
set serveroutput on

create table phy_writs (
 SEQNO             NUMBER,
 SID               NUMBER,
 USERNAME          VARCHAR2(30),
 OSUSER            VARCHAR2(30),
 PHYSICAL_WRITES   NUMBER);

@act_phwrit
execute dbms_lock.sleep(5)
@act_phwrit
execute dbms_lock.sleep(5)
@act_phwrit
execute dbms_lock.sleep(5)
@act_phwrit
execute dbms_lock.sleep(5)
@act_phwrit

drop table phy_writs;
