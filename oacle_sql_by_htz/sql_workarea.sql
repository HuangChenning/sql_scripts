set echo off
set lines 200
set pages 40
col sql_id for a17
col op for a15 heading 'OPERATION|TYPE'
col id for 99999 heading 'OPERA|ID'
col e_opt for 9999999 heading 'ESTI|OPTIMAL|SIZE(M)'
col e_one for 9999999 heading 'ESTI|ONEPASS|SIZE(M)'
col l_mem for 9999999 heading 'LAST|MEMORY|USED(M)'
col last for a10 heading 'LAST|EXECUTION'
col mult for a15 heading 'T/0/1/N'
col sec for 999999 heading 'ACTIVE|TIME'
col tmp_m for 999999 heading 'MAX_SIZE|TEMPSEG'
col tmp_L FOR 999999 heading 'LAST_SIZE|TEMPSEG'
SELECT sql_id,
         operation_type AS op,
         operation_id AS id,
         ROUND (estimated_optimal_size / 1024 / 1024, 2) AS e_opt,
         ROUND (estimated_onepass_size / 1024 / 1024, 2) AS e_one,
         ROUND (last_memory_used / 1024 / 1024, 2) AS l_mem,
         Last_execution AS LAST,
         total_executions||':'||
         optimal_executions||':'||
         onepass_executions||':'||
         multipasses_executions AS mult,
         ROUND (active_time / 1000000, 2) AS sec,
         ROUND (max_tempseg_size / 1024 / 1024, 2) AS tmp_m,
         ROUND (last_tempseg_size / 1024 / 1024, 2) AS tmp_L
    FROM v$sql_workarea
   WHERE   sql_id = NVL ('&sql_id', sql_id)
ORDER BY max_tempseg_size DESC;
