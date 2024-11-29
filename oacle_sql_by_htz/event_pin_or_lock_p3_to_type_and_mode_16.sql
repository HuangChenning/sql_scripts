set echo off
set lines 3000 pages 5000 verify off heading on
undefine p3
select KGLSTDSC,KGLSTIDN,mod(to_number(&&p3,'xxxxxxxxxxxxxxx'),65536) as "MODE"  from x$kglst where kglsttyp = 'NAMESPACE' and KGLSTIDN=trunc(to_number(&&p3,'xxxxxxxxxxxxxxx')/65536)
/
undefine p3
