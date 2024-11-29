set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col ename format          a2    heading 'Eq';
col reqs  format 999,999,990    heading 'Requests';
col sreq  format 999,999,990    heading 'Succ Gets';
col freq  format  99,999,990    heading 'Failed Gets';
col waits format  99,999,990    heading 'Waits';
col awttm format   9,999,999.99 heading 'Avg Wt|Time (ms)' just c;
col wttm  format 999,999,999    heading 'Wait|Time (s)'    just c;

  SELECT e.eq_type ename,
         e.total_req# reqs,
         e.succ_req# sreq,
         e.failed_req# freq,
         e.total_wait# waits,
         e.total_wait#/e.total_wait# awttm,
         e.cum_wait_time / 1000 wttm
    FROM v$enqueue_stat e
   WHERE e.total_wait# > 0
ORDER BY wttm DESC, waits DESC
/
clear    breaks
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
