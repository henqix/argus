rem ********************************************************************
rem * Filename          : act_sesread.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 07-JAN-2002
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor database session reads (executable)
rem ********************************************************************

declare

st1     	varchar2(80);
st2     	varchar2(80);
t1              number;
t2              number;
t3              number;
d1              number;

cursor c1 is
select
 SEQNO,
 NAME,
 VALUE
from ses_reads
where seqno = 1
order by name asc;

cursor c2 (pname varchar2) is
select
  VALUE
from  ses_reads
where name = pname
and   seqno = 2;

r1    c1%rowtype;
r2    c2%rowtype;


begin
 t1 := 0;
 t2 := 0;
 loop
  insert into ses_reads
  select
    1, 
    substr(s2.name,1,50),
    s1.value 
  from v$sesstat s1,
       v$statname s2
  where s1.statistic# = s2.statistic#
  and   s1.statistic# in (4,9,23,40,41,42,44,67,68,98,99,151)
  and   s1.sid = &&SID;
  open c1;
  loop
    fetch c1 into r1;
      exit when c1%notfound;
    open c2(r1.name);
    fetch c2 into r2;
    d1  := r1.value - r2.value;
    st2 := rpad(r1.name,50) || ' ' ||
           lpad(to_char(r1.value),15,' ')|| ' ' ||
           lpad(to_char(d1),10,' ');
    dbms_output.put_line(st2);
    close c2;
  end loop;  
  dbms_output.put_line('---');
  close c1;
  update ses_reads
  set seqno = seqno + 1;
  t1 := t1 + 1;
  if t1 > 0 then 
    exit;
  end if;
 end loop;
end;
/
