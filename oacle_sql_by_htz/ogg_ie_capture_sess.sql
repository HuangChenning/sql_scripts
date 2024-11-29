set verify off
set linesize 200
set pagesize 80
col extract_name format a8 heading 'Extract|Name'
col Run_time_HR format 99,999.99 heading 'Run Time'
col mined_GB format 999,999.99 heading 'Total GB|mined'
col sent_GB format 999,999.99 heading 'Total GB|sent'
col Sent_GB_Per_HR format 999,999.99 heading 'Total GB|Per HR'
col capture_lag Heading 'Capture|Lag|seconds'
col Current_time Heading 'Current|Time'
col extract_name format a8 heading 'Extract|Name'
col GB_Per_HR format 999,999.99 heading 'GB Mined|Per HR'
alter session set nls_date_format='YYYY-MM-DD HH24:Mi:SS';

select
        EXTRACT_NAME,
        TO_CHAR(sysdate, 'HH24:MI:SS MM/DD/YY') Current_time,
        ((SYSDATE-STARTUP_TIME)*24) Run_time_HR ,
        (SYSDATE- capture_message_create_time)*86400 capture_lag,
        BYTES_OF_REDO_MINED/1024/1024/1024 mined_GB,
        (BYTES_OF_REDO_MINED/1024/1024/1024)/((SYSDATE-STARTUP_TIME)*24) GB_Per_HR,
        BYTES_SENT/1024/1024/1024 sent_GB,
        (BYTES_SENT/1024/1024/1024)/((SYSDATE-STARTUP_TIME)*24) Sent_GB_Per_HR
   from gv$goldengate_capture;