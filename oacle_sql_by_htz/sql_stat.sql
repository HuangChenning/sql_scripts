set echo off
set verify off heading on serveroutput on feedback off lines 300 pages 1000 

col i_mem for 999999 heading 'SHARED|Mem KB'
col sorts for 99999999
col version_count for 999 heading 'VER|NUM'
col loaded_versions for 999 heading 'Loaded|NUM'
col open_versions for 999 heading 'Open|NUM'
col executions for 999999999 heading 'EXEC|NUM'
col parse_calls for 999999999 heading 'PARSE|CALLS'
col disk_reads for 999999999 heading 'DISK|READ'
col direct_writes for 999999 heading 'DIRECT|WRITE'
col buffer_gets for 99999999999999
col avg_disk_read for 99999 heading 'AVG|DISK|READ'
col avg_direct_write for 99999 heading 'AVG|DIRECT|WRITE'
col avg_buffer_get for 9999999 heading 'AVG|BUFFER|GET'
col sql_profile for a30
col ROWS_PROCESSED for 999999999 heading 'ROW|PROC'
col avg_row_proc for 99999999 heading 'AVG|ROW|PROC'
COL F_L_TIME          heading 'FIRST_LAST|LOAD_TIME'   FOR a23
undefine sqlid
define _VERSION_11  = "--"
define _VERSION_10  = "--"

col version11  noprint new_value _VERSION_11
col version10  noprint new_value _VERSION_10

select /*+ no_parallel */case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '10.2' and
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '11.2' then
          '  '
         else
          '--'
       end  version10,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '11.2' then
          '  '
         else
          '--'
       end  version11
  from v$version
 where banner like 'Oracle Database%';
select sql_fulltext from v$sqlarea where sql_id='&&sqlid';
set pages 40
SELECT round(sharable_mem / 1024, 2) i_mem,
       sorts,
       version_count,
       loaded_versions,
       OPEN_VERSIONS,
       executions,
       PARSE_CALLS,
       disk_reads,
       trunc(disk_reads / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_disk_read,
       direct_writes,
       trunc(direct_writes / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_direct_write,
       buffer_gets,
       trunc(buffer_gets / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_buffer_get,
       ROWS_PROCESSED,
       trunc(ROWS_PROCESSED / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_row_proc,
       sql_profile
  FROM v$sqlarea
 where sql_id = '&&sqlid'
/
col c_p for a16 heading 'CHILD_NUMBER|PLAN_HASH_VALUE'
col PARSING_SCHEMA_NAME for a15 heading 'USER_NAME'
col USERS_OPENING for 9999 heading 'USER|DOING'
col time for a15 heading 'AVG|TIME(S)'
SELECT PARSING_SCHEMA_NAME,
       CHILD_NUMBER || ':' || plan_hash_value c_p,
       ROUND (sharable_mem / 1024, 2) i_mem,
       sorts,
       USERS_OPENING,
       executions,
       --       PARSE_CALLS,
       --       disk_reads,
       TRUNC (disk_reads / DECODE (EXECUTIONS, 0, 1, EXECUTIONS))
          avg_disk_read,
       --       direct_writes,
       --       trunc(direct_writes / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_direct_write,
       --       buffer_gets,
       TRUNC (buffer_gets / DECODE (EXECUTIONS, 0, 1, EXECUTIONS))
          avg_buffer_get,
       ROWS_PROCESSED,
       TRUNC (ROWS_PROCESSED / DECODE (EXECUTIONS, 0, 1, EXECUTIONS))
          avg_row_proc,
          TRUNC ((CPU_TIME / DECODE (EXECUTIONS, 0, 1, EXECUTIONS))/1000000)
       || ':'
       || TRUNC ((ELAPSED_TIME / DECODE (EXECUTIONS, 0, 1, EXECUTIONS))/1000000)
          time,
&_VERSION_11       CASE
&_VERSION_11          WHEN sql_profile IS NULL AND SQL_PLAN_BASELINE IS NULL
&_VERSION_11          THEN
&_VERSION_11             ''
&_VERSION_11          WHEN sql_profile IS NULL AND sql_plan_baseline IS NOT NULL
&_VERSION_11          THEN
&_VERSION_11             'B.' || sql_plan_baseline
&_VERSION_11          WHEN sql_profile IS NOT NULL AND sql_plan_baseline IS NOT NULL
&_VERSION_11          THEN
&_VERSION_11             'A.' || sql_plan_baseline
&_VERSION_11          WHEN sql_profile IS NOT NULL AND sql_plan_baseline IS NULL
&_VERSION_11          THEN
&_VERSION_11              sql_profile
&_VERSION_11        END
&_VERSION_11        sql_profile,
&_VERSION_10        sql_profile,
          SUBSTR (FIRST_LOAD_TIME, 6, 11)
       || ':'
       || SUBSTR (LAST_LOAD_TIME, 6, 11)
          f_l_time
  FROM v$sql
 WHERE sql_id = '&&sqlid'
/
undefine sqlid