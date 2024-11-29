set echo off
set lines 300
set verify off
set serveroutput on
set feedback off
set lines 300
set pages 10000
set long 100000
set lines 300
set echo off
set verify off
col sql_id for a13
col executions for 999999 heading 'EXEC|NUM'
col parse_calls for 999999 heading 'PARSE|CALLS'
col disk_reads for 9999 heading 'DISK|READ(K)'
col direct_writes for 999999 heading 'DIRECT|WRITE'
col buffer_gets for 9999999 heading 'BUFFER|GET(K)'
col avg_disk_reads for 99999 heading 'AVG|DISK|READ'
col avg_direct_writes for 99999 heading 'AVG|DIRECT|WRITE'
col avg_buffer_gets for 999999 heading 'AVG|BUFFER|GET'
col sql_profile for a14
col ROWS_PROCESSED for 9999999 heading 'ROW|PROC(K)'
col avg_rows_processed for 99999 heading 'AVG|ROW|PROC'
col avg_fetches for 99999 heading 'AVG|FETCH'
col fetches for 9999999 heading 'FETCH|(K)'
col AVG_ELAPSED_TIME  for 999999 heading 'AVG|ELAPSED|TIME(US)'
col AVG_CPU_TIME for 9999999 heading 'AVG|CPU_TIME(US)'
col PARSING_SCHEMA_NAME  for a12 heading 'PARSING|SCHEMA_NAME'
col plan_hash_value for 9999999999 heading 'PLAN|HASH_VALUE'
col elapsed_time for 9999999 heading 'ELAPSED|TIME(MS)'
col cpu_time for 9999999 heading 'CPU|TIME(MS)'


col name for a30
col owner for a15
col description for a50
col sqlset_name for a20
SELECT a.id,
       a.name,
       a.owner,
       a.description,
       to_char(a.created,'yy-mm-dd') created,
       to_char(a.last_modified,'yy-mm-dd hh24:mi') last_modified,
       a.statement_count sql_count
  FROM dba_sqlset a
order by a.id

/
break on sqlset_name on parsing_schema_name on sql_id
SELECT sqlset_name,substr(parsing_schema_name,1,12) parsing_schema_name,
       sql_id,
       plan_hash_value,  
       (executions) executions,
       trunc(elapsed_time/1000) elapsed_time,
       TRUNC ( (elapsed_time) / DECODE ( (executions), 0, 1, (executions)))
          avg_elapsed_time,
       trunc(cpu_time/1000) cpu_time,
       TRUNC ( (cpu_time) / DECODE ( (executions), 0, 1, (executions)))
          avg_cpu_time,
       trunc(buffer_gets/1000) buffer_gets,
       TRUNC ( (buffer_gets) / DECODE ( (executions), 0, 1, (executions)))
          avg_buffer_gets,
       trunc(disk_reads/1000) disk_reads,
       TRUNC ( (disk_reads) / DECODE ( (executions), 0, 1, (executions)))
          avg_disk_reads,
       (direct_writes) direct_writes,
       TRUNC ( (direct_writes) / DECODE ( (executions), 0, 1, (executions)))
          avg_direct_writes,
       trunc(rows_processed/1000) rows_processed,
       TRUNC ( (rows_processed) / DECODE ( (executions), 0, 1, (executions)))
          avg_rows_processed,
       trunc(fetches/1000) fetches,
       TRUNC ( (fetches) / DECODE ( (executions), 0, 1, (executions)))
          avg_fetches
  FROM DBA_SQLSET_STATEMENTS
 WHERE     upper(sqlset_name) = NVL (UPPER ('&sqlset_name'), upper(sqlset_name))
       AND sql_id = NVL ('&sql_id', sql_id) order by sqlset_name,parsing_schema_name,sql_id;
undefine begin_snap;
undefine sql_id;
undefine end_snap;
undefine sort_type;
undefine topn;

