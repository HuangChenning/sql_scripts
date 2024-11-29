set echo off;
set lines 2000 pages 4000 verify off heading on serveroutput on;
undefine p2
select FLOOR(&&p2 / POWER(2, 4 * ws)) blocking_sid,
       MOD(&&p2, POWER(2, 4 * ws)) shared_refcount
  from dual,
       (SELECT DECODE(INSTR(banner, '64'), 0, '4', '8') ws
          FROM v$version
         WHERE ROWNUM = 1) wordsize;
undefine p2;
