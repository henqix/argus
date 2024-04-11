rem *************************************************************************
rem * Filename          : act_phwrit.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 24-jan-2001
rem * Last Update       : 
rem * Update            : 
rem * Description       : Monitor physical writes (start with md_pwritx)
rem *************************************************************************

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
 SID,
 USERNAME,
 OSUSER,
 PHYSICAL_WRITES
from phy_writs
where seqno = 1
order by seqno asc, 
         physical_writes desc;

cursor c2 (psid number) is
select
  PHYSICAL_WRITES
from  phy_writs
where sid = psid
and   seqno = 2;

r1    c1%rowtype;
r2    c2%rowtype;


begin
 t1 := 0;
 t2 := 0;
 loop
  insert into phy_writs
  select
    1, 
    s.sid, 
    s.username,
    s.osuser,
    s1.value
  from 
    v$session s,
    v$sesstat s1
  where s.sid = s1.sid
  and   s1.statistic# = 40;
  open c1;
  loop
    fetch c1 into r1;
      exit when c1%notfound;
    open c2(r1.sid);
    fetch c2 into r2;
    d1  := r1.physical_writes - r2.physical_writes;
    st2 := lpad(to_char(r1.sid),3,'.') || ' ' ||
           rpad(substr(nvl(r1.username,' '),1,20),20) || ' ' ||
           rpad(substr(nvl(r1.osuser,' '),1,20),20) || ' ' ||
           lpad(to_char(r1.physical_writes),15,' ')|| ' ' ||
           lpad(to_char(d1),10,' ');
    dbms_output.put_line(st2);
    close c2;
    t2 := t2 + 1;
    if t2 = 5 then
      t2 := 0; 
      dbms_output.put_line('---');
      exit;
    end if;
  end loop;  
  close c1;
  update phy_writs
  set seqno = seqno + 1;
  t1 := t1 + 1;
  if t1 > 0 then 
    exit;
  end if;
 end loop;
end;
/
