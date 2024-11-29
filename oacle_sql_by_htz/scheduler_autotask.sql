set echo off
set lines 200
set pages 40
col WINDOW_NAME for a20
col WINDOW_NEXT_TIME for a19
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
col client_name for a50
select client_name,status from dba_autotask_client;
col window_active  heading 'WINDOW|ACTIOVE'
col autotask_status HEADING 'AUTOTASK|STATUS'
col optimizer_stats HEADING 'OPTIMIZER_STATS'
col segment_advisor HEADING 'SEGMENT|ADVISOR'
col sql_tune_advisor HEADING 'SQL_TUNE|ADVISOR'
col health_monitor HEADING 'HEALTH_MONITOR'
SELECT window_name,
       TO_CHAR (window_next_time, 'yyyy-mm-dd hh24:mi:ss') as "WINDOW_NEXT_TIME",
       window_active,
       autotask_status,
       optimizer_stats,
       segment_advisor,
       sql_tune_advisor,
       health_monitor
  FROM DBA_AUTOTASK_WINDOW_CLIENTS;


col window_active                 clear;
col autotask_status               clear;
col optimizer_stats               clear;
col segment_advisor               clear;
col sql_tune_advisor              clear;
col health_monitor                clear;