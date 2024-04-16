rem ********************************************************************
rem * Filename          : db_comptab.sql - Version 1.1
rem * Author              Henk Uiterwijk
rem * Original          : 31-JUL-2000
rem * Last Update       : 05-SEP-2000
rem * Update            : Column position added.
rem * Description       : Compare schema's (tables) of two owners
rem ********************************************************************

set serveroutput on size 1000000
set lines 132
set pages 60


accept u1 char prompt 'Schema owner 1 '
accept u2 char prompt 'Schema owner 2 '

declare

p_table_name	varchar2(30);
p_column_name	varchar2(30);

cursor c1 is
select
 OWNER,
 TABLE_NAME,
 COLUMN_NAME,
 DATA_TYPE,
 DATA_LENGTH,
 DATA_PRECISION,
 DATA_SCALE,
 NULLABLE,
 COLUMN_ID
from dba_tab_columns
where owner = upper('&&u1');

r1    c1%rowtype;

cursor c2 (p_table_name varchar2, p_column_name varchar2) is
select
 OWNER,
 TABLE_NAME,
 COLUMN_NAME,
 DATA_TYPE,
 DATA_LENGTH,
 DATA_PRECISION,
 DATA_SCALE,
 NULLABLE,
 COLUMN_ID
from dba_tab_columns
where table_name = p_table_name
and   column_name = p_column_name
and   owner = upper('&&u2');

r2    c2%rowtype;

begin
  open c1;
  loop
  fetch c1 into r1;
    exit when c1%notfound;
  begin
--    dbms_output.put_line(r1.table_name);
--    dbms_output.put_line(r1.column_name);
    open c2 (r1.table_name, r1.column_name);
--    dbms_output.put_line(r2.table_name);
--    dbms_output.put_line(r2.column_name);
    fetch c2 into r2;
    if c2%NOTFOUND then
      dbms_output.put_line('Table or column missing');
      dbms_output.put_line('--'||r1.table_name);
      dbms_output.put_line('--'||r1.column_name);
      dbms_output.put_line('--'||r1.data_type||'  '||r1.data_length||'   '||r1.data_precision||'   '||r1.data_scale);
      if r1.nullable = 'N' then
        dbms_output.put_line('--NOT NULL');
      else
        dbms_output.put_line('--NULL');
      end if;
      dbms_output.put_line('*');
    else
      if nvl(r1.data_type,'NULL') <> nvl(r2.data_type,'NULL') then
        dbms_output.put_line('Different datatype');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||r1.data_type);
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||r2.data_type);
        dbms_output.put_line('*');
      end if;
      if nvl(r1.data_length,99) <> nvl(r2.data_length,99) then
        dbms_output.put_line('Different data length');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||r1.data_length);
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||r2.data_length);
        dbms_output.put_line('*');
      end if;
      if nvl(r1.data_precision,99) <> nvl(r2.data_precision,99) then
        dbms_output.put_line('Different data precision');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||to_char(r1.data_precision));
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||to_char(r2.data_precision));
        dbms_output.put_line('*');
      end if;
      if nvl(r1.data_scale,99) <> nvl(r2.data_scale,99) then
        dbms_output.put_line('Different datascale');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||to_char(r1.data_scale));
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||to_char(r2.data_scale));
        dbms_output.put_line('*');
      end if;
      if nvl(r1.nullable,'NULL') <> nvl(r2.nullable,'NULL') then
        dbms_output.put_line('Different null constraint');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||r1.nullable);
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||r2.nullable);
        dbms_output.put_line('*');
      end if;
      if r1.column_id <> r2.column_id then
        dbms_output.put_line('Different column id');
        dbms_output.put_line('--'||r1.table_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||to_char(r1.column_id));
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.table_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||to_char(r2.column_id));
        dbms_output.put_line('*');
      end if;
    end if;
  end;
  close c2;
  end loop;
  close c1;
end;
/
