set echo off
set lines 300 heading on verify off
col sql_id for a18
col i_mem for 999999 heading 'SHARED|Mem KB'
col sorts for 99999999
col version_count for 999 heading 'VER|NUM'
col executions for 999999 heading 'EXEC|NUM'
col parse_calls for 999999 heading 'PARSE|CALLS'
col disk_reads for 999999 heading 'DISK|READ'
col direct_writes for 999999 heading 'DIRECT|WRITE'
col buffer_gets for 99999999999999
col avg_disk_reads for 99999 heading 'AVG|DISK|READ'
col avg_direct_writes for 99999 heading 'AVG|DIRECT|WRITE'
col avg_buffer_gets for 9999999 heading 'AVG|BUFFER|GET'
col sql_profile for a14
col ROWS_PROCESSED for 999999999 heading 'ROW|PROC'
col avg_rows_processed for 999999 heading 'AVG|ROW|PROC'
col avg_fetches for 999999 heading 'AVG|FETCH'
col fetches     for 999999999 heading 'FETCHES'
col elapsed_time for 99999999999 heading 'elapsed_time'
col AVG_ELAPSED_TIME  for 9999999 heading 'AVG|ELAPSED|TIME'
col cpu_time for 99999999999 heading 'CPU_TIME'
col AVG_CPU_TIME for 9999999 heading 'AVG|CPU_TIME'
col PARSING_SCHEMA_NAME  for a15 heading 'PARSING|SCHEMA_NAME'
col snap_id for 999999 heading 'SNAP_ID'
col end_time for a5
col instance_number for 99 heading 'I'
undefine sqlid;
  SELECT TO_CHAR (END_INTERVAL_TIME, 'dd hh24') end_time,
         a.snap_id,
         a.instance_number,
         a.plan_hash_value,
         a.parsing_schema_name,
         (a.executions_delta) executions,
         (a.elapsed_time_delta) elapsed_time,
         TRUNC (
              (elapsed_time_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_elapsed_time,
         (cpu_time_delta) cpu_time,
         TRUNC (
              (cpu_time_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_cpu_time,
         (buffer_gets_delta) buffer_gets,
         TRUNC (
              (buffer_gets_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_buffer_gets,
         (disk_reads_delta) disk_reads,
         TRUNC (
              (disk_reads_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_disk_reads,
         (direct_writes_delta) direct_writes,
         TRUNC (
              (direct_writes_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_direct_writes,
         (rows_processed_delta) rows_processed,
         TRUNC (
              (rows_processed_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_rows_processed,
         (fetches_delta) fetches,
         TRUNC (
              (fetches_delta)
            / DECODE ( (executions_delta), 0, 1, (executions_delta)))
            avg_fetches
    FROM dba_hist_sqlstat a, dba_hist_snapshot b
   WHERE     a.sql_id = '&sqlid'
         AND a.snap_id = b.snap_id
         AND a.instance_number = b.instance_number
ORDER BY snap_id
/
undefine begin_snap;
undefine sqlid;
undefine end_snap;
undefine sort_type;
undefine topn;

