store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col session_id for 9999999 heading 'SESSION'
col coord_session_id for 99999999 heading 'Parallel Coordinator|SESSION'
col coord_instance_id for 99999999 heading 'Parallel Coordinator|INSTANCE'


select session_id,instance_id,coord_instance_id,coord_session_id,status,timeout,start_time,suspend_time,''||chr(10)||sql_text sqltext,chr(10)||error_msg error_info from dba_resumable
/
clear    breaks  
@sqlplusset

