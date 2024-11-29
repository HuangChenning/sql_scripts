set serveroutput on
set linesize 120
--
-- This anonymous PL/SQL block must be executed as INTERNAL or SYS
-- Execute from : SQL*PLUS
-- CAUTION:
-- This sample program has been tested on Oracle Server - Enterprise Edition
-- However, there is no guarantee of effectiveness because of the possibility
-- of error in transmitting or implementing it. It is meant to be used as a
-- template, and it may require modification.
--
declare
b_myadr VARCHAR2(20);
b_myadr1 VARCHAR2(20);
qstring VARCHAR2(100);
b_anybind NUMBER;

cursor my_statement is
select address from v$sql
group by address;

cursor getsqlcode is
select substr(sql_text,1,60)
from v$sql
where address = b_myadr;

cursor kglcur is
select kglhdadr from x$kglcursor
where kglhdpar = b_myadr
and kglhdpar != kglhdadr
and kglobt09 = 0;

cursor isthisliteral is
select kkscbndt
from x$kksbv
where kglhdadr = b_myadr1;

begin

dbms_output.enable(10000000);

open my_statement;
loop
Fetch my_statement into b_myadr;
open kglcur;
fetch kglcur into b_myadr1;
if kglcur%FOUND Then
open isthisliteral;
fetch isthisliteral into b_anybind;
if isthisliteral%NOTFOUND Then
open getsqlcode;
fetch getsqlcode into qstring;
dbms_output.put_line('Literal:'||qstring||' address: '||b_myadr);
close getsqlcode;
end if;
close isthisliteral;
end if;
close kglcur;
Exit When my_statement%NOTFOUND;
End loop;
close my_statement;
end;
/
