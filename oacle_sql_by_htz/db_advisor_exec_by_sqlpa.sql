set echo off
set lines 2000 pages 400 verify off heading on
col owner for a15
col task_name for a30
col EXECUTION_NAME for a30
col description for a50
col execution_type for a15
col  start_end for a20
col status for a10
 SELECT owner,
         task_name,
         A.EXECUTION_NAME,
         execution_type,
            TO_CHAR (execution_start, 'dd hh24:mi')
         || '~'
         || TO_CHAR (execution_end, 'hh24:mi')
            start_end,
         status,
         description
    FROM dba_advisor_executions a
   WHERE a.advisor_name = 'SQL Performance Analyzer'
ORDER BY A.EXECUTION_ID;