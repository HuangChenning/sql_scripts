
select * from v$sysstat where name like '%redo%';

set serveroutput on
declare
  l_start number;
  l_end   number;
begin
     select value into l_start from v$sysstat where name = 'redo size';
  dbms_lock.sleep(60);
  select value into l_end from v$sysstat where name = 'redo size';
  dbms_output.put_line('Redo Size  Hours:' ||
                       round(l_end / (l_end-l_start) / 60, 2));
end;
/


