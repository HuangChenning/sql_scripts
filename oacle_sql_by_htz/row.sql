set echo off
set lines 200
col i_snap for a10 heading 'INSTANCE|SNAP_NUM'
col end_data for a8 heading 'SNAP|END_TIME'
col plan_hash_value for a20 heading 'PLAN|HASH_VALUE'
col optimizer_cost for 9999999 heading 'OPTIMIZER|COST'
col optimizer_mode for a10 heading 'OPTIMIZER|MODE'
col parsing_schema_name for a12 heading 'PARSING|SCHEMA_NAME'
col exec_total for 99999999 
col load_per_exec for 999999 heading 'PER_EXEC|LOAD'
col parse_call_per_exec for 999999 heading 'PER_EXEC|PARSE_CALL'
col disk_read_per_exec for 999999999 heading 'PER_EXEC|DISK_READ'
col buffer_get_per_exec for 999999999 heading 'PER_EXEC|BUFFER_GET'
col rows_process_per_exec for 999999 heading 'PER_EXEC|ROWS_PRO'
col cpu_time_per_exec for 99999999 heading 'PER_EXEC|CPU_TIME'
col elapsed_time_per_exec for 9999999999 heading 'PER_EXEC|ELAP|TIME'
ACCEPT sqlid prompt 'Enter Search Sql_id (i.e. 2) : ' default ''
ACCEPT days prompt 'Enter Search Day(i.e. 2 default 1) : ' default 1


SELECT h.instance_number || ':' || h.snap_id i_snap,
       to_char(s.end_interval_time, 'mm-dd hh24') end_date,
       h.plan_hash_value,
       h.optimizer_cost,
       h.optimizer_mode,
       h.version_count,     
       h.parsing_schema_name,
       h.executions_DELTA exec_total,
       round(h.loads_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) load_per_exec,
       round(h.parse_calls_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) parse_call_per_exec,
       round(h.disk_reads_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) disk_read_per_exec,
       round(h.buffer_gets_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) buffer_get_per_exec,
       round(h.rows_processed_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) rows_process_per_exec,
       round(h.cpu_time_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) cpu_time_per_exec,
       round(h.elapsed_time_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) elapsed_time_per_exec,
       round(h.iowait_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) iowait_per_exec,
       round(h.clwait_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) clwait_per_exec,
       round(h.apwait_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) apwait_per_exec,
       round(h.ccwait_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) ccwait_per_exec,
       round(h.direct_writes_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) direct_writes_per_exec,
       round(h.plsexec_time_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) plsexec_time_per_exec,
       round(h.javexec_time_DELTA /
             decode(executions_DELTA, 0, 1, executions_DELTA),
             2) javaexec_time_per_exec,
       h.sql_profile
  FROM dba_hist_sqlstat h, dba_hist_snapshot s
 WHERE h.sql_id = nvl('&sqlid', h.sql_id)
   AND h.snap_id = s.snap_id
   AND h.dbid = s.dbid
   AND h.instance_number = s.instance_number
   and s.end_interval_time > sysdate - nvl('&days', 1)
 ORDER BY s.end_interval_time, h.instance_number, h.plan_hash_value
 /
