create or replace type stats_line as object
 ( snapid number(10),
 name varchar2(66),
 value int );
/

create or replace type stats_array as
 table of stats_line;
/

create or replace
 type run_stats_line as object (
 tag varchar2(66),
 run1 int,
 run2 int,
 diff2 int,
 pct2 int,
 run3 int,
 diff3 int,
 pct3 int,
 run4 int,
 diff4 int,
 pct4 int,
 run5 int,
 diff5 int,
 pct5 int,
 run6 int,
 diff6 int,
 pct6 int);
/


create or replace type run_stats_output
 as table of run_stats_line;
/



create or replace package rs as
 procedure snap(reset boolean default false);
 function display return run_stats_output ;
 function the_stats return stats_array;
 s stats_array := stats_array();
 v_snapid integer := 0;
end;
/

create or replace package body rs as

 procedure snap(reset boolean default false) is
 begin
 if reset then
 s := stats_array();
 v_snapid := 0;
 end if;
 v_snapid := v_snapid + 1;
for i in ( select * from stats) loop
s.extend;
s(s.count) := stats_line(v_snapid, i.name,i.value );
end loop;
end;

function display return run_stats_output is
output run_stats_line :=
run_stats_line(null,
null,null,null,null,
null,null,null,null,
null,null,null,null,
null,null,null,null);
ret run_stats_output := run_stats_output();
base_val number;
begin
for i in ( select hi.snapid, lo.name, lo.value, hi.value-lo.value amt
from ( select * from table(the_stats) ) lo,
( select * from table(the_stats) ) hi
where lo.name = hi.name
and lo.snapid = hi.snapid -1
order by 2,1) loop
case i.snapid
when 2 then
if output.tag is not null then
ret.extend;
ret(ret.count) := output;
end if;
base_val := i.amt;
output.tag := i.name;
output.run1 := i.amt;
when 3 then
output.run2 := i.amt;
output.diff2 := i.amt - base_val;
output.pct2 := i.amt / greatest(base_val,1) * 100;
when 4 then
output.run3 := i.amt;
output.diff3 := i.amt - base_val;
output.pct3 := i.amt / greatest(base_val,1) * 100;
when 5 then
output.run4 := i.amt;
output.diff4 := i.amt - base_val;
output.pct4 := i.amt / greatest(base_val,1) * 100;
when 6 then
output.run5 := i.amt;
output.diff5 := i.amt - base_val;
output.pct5 := i.amt / greatest(base_val,1) * 100;
when 7 then
output.run6 := i.amt;
output.diff6 := i.amt - base_val;
output.pct6 := i.amt / greatest(base_val,1) * 100;
end case;
end loop;
ret.extend;
ret(ret.count) := output;
return ret;
end;

function the_stats return stats_array is
begin
return s;
end;

end;
/