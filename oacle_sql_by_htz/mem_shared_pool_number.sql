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
AND    a.ksppinm='_kghdsidx_count'
ORDER BY a.ksppinm
/


select addr, name, gets, misses, waiters_woken
  from v$latch_children
 where name = 'shared pool'
 /
