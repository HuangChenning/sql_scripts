set echo off;
set lines 300 pages 1000 
col sql_text for a40
col username for a15
col status for a7
col sql_id for a15
col last_time for a11
col buffer_get for 9999999 heading 'BUFFER(M)'
col disk_reads for 9999999 heading 'DISK(M)'
col px_server# for 99 heading 'PX'
col SQL_PLAN_HASH_VALUE for 9999999999 heading 'PLAN|HASH_VALUE'
col time for 999999999 heading 'TIME(S)'
col fetches for 99999 heading 'FECTH'
select a.key,
       substr(a.status,1,7) status,
       a.username,
       to_char(a.LAST_REFRESH_TIME, 'dd hh24:mi:ss') last_time,
       a.SID,
       a.SQL_ID,
       a.SQL_PLAN_HASH_VALUE,
       trunc(a.ELAPSED_TIME/1000000) time,
       trunc(a.BUFFER_GETS * 8192 / 1024 / 1024) buffer_get,
       trunc(a.DISK_READS * 81924 / 1024 / 1024) disk_reads,
       px_server#,
       a.fetches,
       substr(a.PROGRAM, 30) program,
       a.sql_text
  from v$sql_monitor a order by 4,8;
