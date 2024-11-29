set echo off
set lines 300
set verify off
set serveroutput on
set feedback off
set lines 300
set pages 10000
set long 100000
@awr_snapshot_info.sql
set lines 300
set echo off
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
col avg_rows_processed for 99999999 heading 'AVG|ROW|PROC'
col  avg_fetches for 999999 heading 'AVG|FETCH'
col AVG_ELAPSED_TIME  for 9999999 heading 'AVG|ELAPSED|TIME'
col AVG_CPU_TIME for 9999999 heading 'AVG|CPU_TIME'
PROMPT "SORT_TYPE elapsed_time,cpu_time,buffer_gets,disk_reads,direct_writes,rows_processed,fetches,executions"
SELECT sql_id,COUNT (*) version_count,
         SUM (executions) executions,
         SUM (elapsed_time) elapsed_time,
         TRUNC (
              SUM (elapsed_time)
            / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_elapsed_time,
         SUM (cpu_time) cpu_time,
         TRUNC (
            SUM (cpu_time) / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_cpu_time,
         SUM (buffer_gets) buffer_gets,
         TRUNC (
              SUM (buffer_gets)
            / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_buffer_gets,
         SUM (disk_reads) disk_reads,
         TRUNC (
              SUM (disk_reads)
            / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_disk_reads,
         SUM (direct_writes) direct_writes,
         TRUNC (
              SUM (direct_writes)
            / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_direct_writes,
         SUM (rows_processed) rows_processed,
         TRUNC (
              SUM (rows_processed)
            / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_rows_processed,
         SUM (fetches) fetches,
         TRUNC (
            SUM (fetches) / DECODE (SUM (executions), 0, 1, SUM (executions)))
            avg_fetches
    FROM TABLE (DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY (
                   begin_snap         => &begin_snap,
                   end_snap           => &end_snap,
                   basic_filter       => NULL,
                   object_filter      => NULL,
                   ranking_measure1   => NVL ('&sort_type', NULL),
                   result_limit       => NVL ('&topn', null)))
GROUP BY sql_id;
undefine begin_snap;
undefine end_snap;
undefine sort_type;
undefine topn;

