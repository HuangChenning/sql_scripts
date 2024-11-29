set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col owner for a15
col job_name for a20
col program for a20
col job_type for a15
col job_action for a30
col running_instance for 99 heading 'RUN|INT'
col sess for a20 heading 'SESSION|SERIAL#|OSPID'
col t_date for a19 heading 'START_TIME'
col event for a30

select a.owner,
       a.job_name,
       d.program,
       b.job_type,
       b.job_action,
             a.running_instance,
       a.session_id||':'||d.serial#||':'||
       a.slave_os_process_id  sess,
       to_char(b.start_date) t_date,
       substr(d.event,1,30) event
  from dba_scheduler_running_jobs a, dba_scheduler_jobs b, v$session d
 where a.owner = b.owner
   and a.job_name = b.job_name
   and a.session_id = d.sid
  / 
   
   
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on