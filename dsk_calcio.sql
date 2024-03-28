rem ********************************************************************
rem * Filename          : dsk_calcio.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 17-oct-07
rem * Update            : 
rem * Description       : Caculate time for table creation, selection and updating
rem * Usage             : start dsk_calcio.sql
rem ********************************************************************

set lines 132
set pages 60


-- Create Table with same structure as ALL_TABLES from Oracle Dictionary
create table bigtab
as
select rownum id, a.*
  from all_objects a
 where 1=0;

select to_char(sysdate,'hh24:mi:ss') from dual;
-- Fill 1'000'000 Rows into the Table
declare
    l_cnt  number;
    l_rows number := 100000;
begin
    -- Copy ALL_OBJECTS
    insert /*+ append */
    into bigtab
    select rownum, a.*
      from all_objects a;
    l_cnt := sql%rowcount;
    commit;

    -- Generate Rows
    while (l_cnt < l_rows)
    loop
        insert /*+ APPEND */ into bigtab
        select rownum+l_cnt,
               OWNER, OBJECT_NAME, SUBOBJECT_NAME,
               OBJECT_ID, DATA_OBJECT_ID,
               OBJECT_TYPE, CREATED, LAST_DDL_TIME,
               TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY, NAMESPACE, EDITION_NAME
          from bigtab
         where rownum <= l_rows-l_cnt;
        l_cnt := l_cnt + sql%rowcount;
        commit;
    end loop;
end;
/
select to_char(sysdate,'hh24:mi:ss') from dual;


set autotrace on
set timing on
select count(*) from bigtab, bigtab;
--update bigtab set object_name = lower(object_name);
set autotrace off
set timing off

drop table bigtab;

