set echo off;
set lines 2000 pages 4000 verify off heading on serveroutput on;
undefine p2raw
select FLOOR(to_number(&&p2raw,'XXXXXXXXXXXXXXXXX') / POWER(2, 4 * ws)) blocking_sid,
       MOD(to_number(&&p2raw,'XXXXXXXXXXXXXXXXX'), POWER(2, 4 * ws)) shared_refcount
  from dual,
       (SELECT DECODE(INSTR(banner, '64'), 0, '4', '8') ws
          FROM v$version
         WHERE ROWNUM = 1) wordsize;
undefine p2raw;
