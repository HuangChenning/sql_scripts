set echo off
set lines 2000 pages 400 verify off heading on
select  KGLSTDSC,KGLSTIDN from x$kglst where kglsttyp = 'NAMESPACE'
/