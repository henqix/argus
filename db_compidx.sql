rem ********************************************************************
rem * Filename          : db_compidx.sql - Version 1.0
rem * Author              Henk Uiterwijk
rem * Original          : 31-JUL-2000
rem * Last Update       : 
rem * Update            : 
rem * Description       : Compare schema's (indexes) of two owners
rem ********************************************************************

set serveroutput on size 1000000
accept u1 char prompt 'Schema owner 1 '
accept u2 char prompt 'Schema owner 2 '

declare

p_index_name	varchar2(30);
p_column_name	varchar2(4000);

cursor c1 is
select
 INDEX_OWNER,
 INDEX_NAME,
 COLUMN_NAME,
 COLUMN_POSITION,
 COLUMN_LENGTH
from dba_ind_columns
where index_owner = upper('&&u1');

r1    c1%rowtype;

cursor c2 (p_index_name varchar2, p_column_name varchar2) is
select
 INDEX_OWNER,
 INDEX_NAME,
 COLUMN_NAME,
 COLUMN_POSITION,
 COLUMN_LENGTH
from dba_ind_columns
where index_name = p_index_name
and   column_name = p_column_name
and   index_owner = '&&u2';

r2    c2%rowtype;

begin
  open c1;
  loop
  fetch c1 into r1;
    exit when c1%notfound;
  begin
--    dbms_output.put_line(r1.index_name);
--    dbms_output.put_line(r1.column_name);
    open c2 (r1.index_name, r1.column_name);
--    dbms_output.put_line(r2.index_name);
--    dbms_output.put_line(r2.column_name);
    fetch c2 into r2;
    if c2%NOTFOUND then
      dbms_output.put_line('Index or column missing');
      dbms_output.put_line('--'||r1.index_name);
      dbms_output.put_line('--'||r1.column_name);
      dbms_output.put_line('*');
    else
      if nvl(r1.column_position,NULL) <> nvl(r2.column_position,NULL) then
        dbms_output.put_line('Different column position');
        dbms_output.put_line('--'||r1.index_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||to_char(r1.column_position));
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.index_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||to_char(r2.column_position));
        dbms_output.put_line('*');
      end if;
      if nvl(r1.column_length,99) <> nvl(r2.column_length,99) then
        dbms_output.put_line('Different column length');
        dbms_output.put_line('--'||r1.index_name);
        dbms_output.put_line('--'||r1.column_name);
        dbms_output.put_line('--'||to_char(r1.column_length));
        dbms_output.put_line('---');
        dbms_output.put_line('--'||r2.index_name);
        dbms_output.put_line('--'||r2.column_name);
        dbms_output.put_line('--'||to_char(r2.column_length));
        dbms_output.put_line('*');
      end if;
    end if;
  end;
  close c2;
  end loop;
  close c1;
end;
/
