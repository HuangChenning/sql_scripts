set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
col parameter for a40
col session_value for a20
col instance_value for a20
col description for a60

ACCEPT par prompt 'Enter Search Parameter (i.e. max|all) : '

SELECT a.ksppinm AS parameter,
       b.ksppstvl AS session_value,
       c.ksppstvl AS instance_value,
       a.ksppdesc AS description
FROM   x$ksppi a,
       x$ksppcv b,
       x$ksppsv c
WHERE  a.indx = b.indx
AND    a.indx = c.indx
AND    a.ksppinm LIKE '/_%' ESCAPE '/'
AND    (a.ksppinm = DECODE('&par', 'all', a.ksppinm, '&par') or a.ksppinm LIKE '%&par%')
ORDER BY a.ksppinm
/

clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
undefine par
SET SERVEROUTPUT off
set echo on
