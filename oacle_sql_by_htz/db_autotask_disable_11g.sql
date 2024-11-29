set echo off
set lines 200
set pages 40
set verify off
col client_name for a40
col status for a10
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
SELECT client_name, status FROM DBA_AUTOTASK_CLIENT;
col window_name for a19
col window_next_time for a35
col window_active for a10 heading 'WINDOW|ACTIVE'
col autotask_status      for a10 heading 'AUTOTASK|STATUS';
col optimizer_stats      for a10 heading 'OPTIMIZER|STATS';
col segment_advisor      for a10 heading 'SEGEMENT|ADVISOR';
col sql_tune_advisor     for a10 heading 'SQL_TUNE|ADVISOR';
col health_monitor       for a10 heading 'HEALTH|MONITOR';
SELECT window_name,
       window_next_time,
       window_active,
       autotask_status,
       optimizer_stats,
       segment_advisor,
       sql_tune_advisor,
       health_monitor
  FROM DBA_AUTOTASK_WINDOW_CLIENTS;
  
BEGIN
   DBMS_AUTO_TASK_ADMIN.disable (
      client_name   => '&client_name',
      operation     => NULL,
      window_name   => NVL (UPPER ('&window_name'), NULL));
END;
/

SELECT client_name, status FROM DBA_AUTOTASK_CLIENT;

SELECT window_name,
       window_next_time,
       window_active,
       autotask_status,
       optimizer_stats,
       segment_advisor,
       sql_tune_advisor,
       health_monitor
  FROM DBA_AUTOTASK_WINDOW_CLIENTS;
