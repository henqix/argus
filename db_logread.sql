rem ********************************************************************
rem * Filename          : db_logread.sql - Version 2.0
rem * Author            : Henk Uiterwijk
rem * Original          : 14-apr-2000
rem * Last Update       : 24-sep-2001
rem * Update            : Use session_logical_reads i.o. db_block_gets
rem *                     and consistent gets 
rem * Description       : Monitor database logical reads (executable) used by db_logreadx
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
 SID,
 USERNAME,
 OSUSER,
 LOGICAL_READS
from log_reads
where seqno = 1
order by seqno asc, 
         logical_reads desc;

cursor c2 (psid number) is
select
  LOGICAL_READS
from  log_reads
where sid = psid
and   seqno = 2;

r1    c1%rowtype;
r2    c2%rowtype;

begin
 t1 := 0;
 t2 := 0;
 loop
  insert into log_reads
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
  and   s1.statistic# = 9;
  open c1;
  loop
    fetch c1 into r1;
      exit when c1%notfound;
        open c2(r1.sid);
        fetch c2 into r2;
        d1  := r1.logical_reads - r2.logical_reads;
    st2 := lpad(to_char(r1.sid),3,'.') || ' ' ||
           rpad(substr(nvl(r1.username,' '),1,20),20) || ' ' ||
           rpad(substr(nvl(r1.osuser,' '),1,20),20) || ' ' ||
           lpad(to_char(r1.logical_reads),15,' ') || ' ' ||
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
  update log_reads
  set seqno = seqno + 1;
  t1 := t1 + 1;
  if t1 > 0 then 
    exit;
  end if;
 end loop;
end;
/
