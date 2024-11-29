set echo off
set lines 200
set pages 40
col mult for a15 heading 'T/0/1/N'
col l_size for 9999999999999 heading 'LOW_SIZE|OPTIMAL(KB)'
col h_size for 9999999999999 heading 'HIGH_SIZE|OPTIMAL(KB)'
SELECT TRUNC (LOW_OPTIMAL_SIZE / 1024) l_size,
       TRUNC (HIGH_OPTIMAL_SIZE / 1024) h_size,
          total_executions
       || ':'
       || optimal_executions
       || ':'
       || onepass_executions
       || ':'
       || multipasses_executions
          AS mult
  FROM V$SQL_WORKAREA_HISTOGRAM;