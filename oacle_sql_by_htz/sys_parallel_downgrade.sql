set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40

SELECT name,
       VALUE,
       ROUND (
          DECODE (VALUE * 100, 0, NULL, VALUE * 100) / SUM (VALUE) OVER (),
          2)
          pct
  FROM v$sysstat
 WHERE name LIKE 'Parallel operations %'
/
clear    breaks  
@sqlplusset

