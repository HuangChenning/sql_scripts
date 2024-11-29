set echo off     
set lines 200    
set pages 50     
set serveroutput  on
set verify off   
col  log_date for a9
col o_j for a40 heading 'OWNER:JOB_NAME'
col status for a10
col error# for 9999999
col r_a   for a17 heading 'DATA|REQUEST_RUN'
col instance_id for 99 heading 'I'
col session_id for a10
col cpu_used for a16
  SELECT TO_CHAR (log_date, 'dd hh24:mi') log_date,
         owner || '.' || job_name o_j,             
         status,                                   
         error#,                                   
            nvl(TO_CHAR (req_start_date, 'dd hh24:mi'),'MANUAL')
         ||'.'|| TO_CHAR (actual_start_date, 'hh24:mi') 
            r_a,                                   
         instance_id,                              
         session_id,                               
         cpu_used                                  
    FROM dba_scheduler_job_run_details             
   WHERE log_date > (SYSDATE - NVL ('&day', '1'))  
ORDER BY log_date;                                 