rem ********************************************************************
rem * Filename          : db_pgstat.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 12-DEC-2011
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor PGA Memory Usage
rem ********************************************************************

set lines 132
set pages 66

select * from v$pgastat
where name in
('aggregate PGA target parameter',
 'maximum PGA allocated',
 'total PGA inuse',
 'total PGA used for auto workareas',
 'total PGA used for manual workareas',
 'over allocation count',
 'cache hit percentage')
/
