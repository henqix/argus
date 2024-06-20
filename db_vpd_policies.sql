rem ********************************************************************
rem * Filename          : db_vpd_policies.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Show all policies for a Virtual Private Database 
rem ********************************************************************

set lines 132
set pages 60

select OBJECT_NAME, 
       POLICY_NAME, 
	   ENABLE 
from dba_policies
order by 1,2;