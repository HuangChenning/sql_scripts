set echo off
set lines 200
set pages 40
set heading on
col log_id for 999999
col log_date for a13 heading 'LOG_DATE'
col owner for a15
col job_name for a30
col job_subname for a20
col status for a15
col req_act for a18 heading 'REQ_START_DATE|ACTUAL_START'
col i_s_s for a25 heading 'INSTANCE_ID|SESSION_ID|SLAVE_PID'
col cpu_used for a20
select log_id,
       to_char(log_date, 'dd hh24:mi:ss') log_date,
       owner,
       job_name,
       job_subname,
       status,
       error#,
       to_char(req_start_date, 'dd hh24:mi:ss') || '-' ||
       to_char(actual_start_date, 'mi:ss') req_act,
       instance_id||'.'||session_id||'.'||slave_pid i_s_s,
       cpu_used
  from dba_scheduler_job_run_details
 where log_date > trunc(sysdate - nvl('&day', 0))
 order by log_id;
undefine day;
set lines 80