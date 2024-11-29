set echo off;
set lines 250 pages 1000 heading on verify off
col src_con_name for a10 heading 'CON_NAME'
col event_time for a16 
col EVENT for a50
col status for a80
select src_con_name,
       to_char(event_time,'mm-dd hh24:mi:ss') event_time,
       start_scn,
       current_scn,
       commit_scn,
       substr(event,1,50) event,
       status
  from cdb_logstdby_events a
 where a.event_time > (sysdate - &hours / 24)
 order by EVENT_TIMESTAMP, COMMIT_SCN, CURRENT_SCN
/
set lines 78