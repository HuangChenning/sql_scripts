set echo off
set heading on
set lines 2000
set verify off
set pagesize 999
col username format a13
col prog format a22
col sqltext format a190
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col etime format 9,999,999.99
undefine sql_handle;
SELECT sql_id,
       child_number,
       hash_value,
       plan_hash_value plan_hash,
       executions execs,
       elapsed_time / 1000000 etime,
         (elapsed_time / 1000000)
       / DECODE (NVL (executions, 0), 0, 1, executions)
          avg_etime,
       sql_text sqltext
  FROM v$sql s
 WHERE S.SQL_PLAN_BASELINE IN
          (SELECT b.plan_name
             FROM dba_sql_plan_baselines b
            WHERE B.SQL_HANDLE = NVL ('&sql_handle', b.sql_handle));
/
undefine sql_handle;