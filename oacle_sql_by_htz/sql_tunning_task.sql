set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set heading on
set pages 40
col o_t for a40 heading 'OWNER|TASK_NAME'
col status for a15
col how_created for a8
col descr for a30 heading 'DESC'
col advisor_name for a20
col reco_count for 9999999 heading 'RECOMMEND|COUNT'
SELECT owner||':'||task_name o_t,
       status,
       how_created,
       substr(description,1,30) descr,
       advisor_name,
       TO_CHAR (created, 'yy-mm-dd hh24') created,
       TO_CHAR (last_modified, 'yy-mm-dd hh24') last_modified,
       TO_CHAR (execution_start, 'yy-mm-dd hh24') exec_start,
       TO_CHAR (execution_end, 'dd hh24') exec_end,
       recommendation_count reco_count
  FROM dba_advisor_tasks
 WHERE advisor_name = 'SQL Tuning Advisor';
 
clear    breaks  
set echo on

