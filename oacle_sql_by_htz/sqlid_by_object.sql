set echo off
set lines 200 pages 40
set heading on
set verify off
col hash_value for 9999999999999 heading 'SQL_HASH_VALUE'
col plan_hash_value for 999999999999 heading 'PLAN_HASH_VALUE'
col sql_id for a19
col CPU_PRE_EXEC for 9999999999 heading 'CPU_PRE_EXEC'

SELECT DISTINCT
       b.hash_value,
       a.plan_hash_value,
       b.sql_id,
       b.child_number,
       a.CPU_TIME / DECODE (a.EXECUTIONS, 0, 1, a.EXECUTIONS) CPU_PRE_EXEC,
       a.ELAPSED_TIME / DECODE (a.EXECUTIONS, 0, 1, a.EXECUTIONS)
          ELA_PRE_EXEC,
       a.DISK_READS / DECODE (a.EXECUTIONS, 0, 1, a.EXECUTIONS) DISK_PRE_EXEC,
       a.BUFFER_GETS / DECODE (a.EXECUTIONS, 0, 1, a.EXECUTIONS) GET_PRE_EXEC,
       a.ROWS_PROCESSED / DECODE (a.EXECUTIONS, 0, 1, a.EXECUTIONS)
          ROWS_PRE_EXEC,
       a.ROWS_PROCESSED / DECODE (a.FETCHES, 0, 1, a.FETCHES)
          ROWS_PRE_FETCHES,
       a.EXECUTIONS
  FROM v$sql a, v$sql_plan b
 WHERE     b.object_owner = NVL (UPPER ('&object_owner'), b.object_owner)
       AND b.object_name = UPPER ('&object_name')
       AND a.sql_id = b.sql_id
       AND a.child_number = b.child_number
order by GET_PRE_EXEC
/
set echo on