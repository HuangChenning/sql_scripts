set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col backup_name for a19
col start_time for a19
col elapsed_time for a15
col status for a20
col input_type for a20
col output_device_type for a20 heading 'OUTPUT|DEVICE_TYPE'
col input_size for a10
col output_size for a11
col output_rate_per_sec for a10 heading 'OUTPUT_RATE|PER_SEC'
SELECT R.COMMAND_ID BACKUP_NAME,
       TO_CHAR(R.START_TIME, 'yyyy-mm-dd HH24:MI:SS') START_TIME,
       TO_CHAR(R.END_TIME, 'yyyy-mm-dd HH24:MI:SS') START_TIME,
       R.TIME_TAKEN_DISPLAY ELAPSED_TIME,
       DECODE(R.STATUS,
              'COMPLETED',
              R.STATUS,
              'RUNNING',
              R.STATUS,
              'FAILED',
              R.STATUS,
              R.STATUS) STATUS,
       R.INPUT_TYPE INPUT_TYPE,
       R.OUTPUT_DEVICE_TYPE OUTPUT_DEVICE_TYPE,
       R.INPUT_BYTES_DISPLAY INPUT_SIZE,
       R.OUTPUT_BYTES_DISPLAY OUTPUT_SIZE,
       R.OUTPUT_BYTES_PER_SEC_DISPLAY OUTPUT_RATE_PER_SEC
  FROM (SELECT COMMAND_ID,
               START_TIME,
               END_TIME,
               TIME_TAKEN_DISPLAY,
               STATUS,
               INPUT_TYPE,
               OUTPUT_DEVICE_TYPE,
               INPUT_BYTES_DISPLAY,
               OUTPUT_BYTES_DISPLAY,
               OUTPUT_BYTES_PER_SEC_DISPLAY
          FROM V$RMAN_BACKUP_JOB_DETAILS
         ORDER BY START_TIME DESC) R
 WHERE ROWNUM < 50
 
 /
clear    breaks  