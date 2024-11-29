set SERVEROUTPUT on
undef p1
declare
    inst   varchar(20); 
    sender varchar(20);
begin
 select bitand(&&p1, 16711680) - 65535 as SNDRINST,
     decode(bitand(&&p1, 65535),65535, 'QC', 'P'||to_char(bitand(&&p1, 65535),'fm000') ) as SNDR
     into  inst , sender
  from dual
  where bitand(&&p1, 268435456) = 268435456;
      dbms_output.put_line('Instance = '||inst);
      dbms_output.put_line('Sender = '||sender );
end;
/ 
