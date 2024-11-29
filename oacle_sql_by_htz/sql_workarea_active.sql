set echo off
set lines 200
set pages 40
col sql_id for a17
col sid for 99999999
col operation_id for 9999 heading 'OPAR|ID'
col operation for a15 heading 'OPERATION|TYPE'
SELECT TO_NUMBER (DECODE (SID, 65535, NULL, SID)) sid,
       sql_id,
       operation_type OPERATION,
       OPERATION_ID ,
       POLICY,
       TRUNC (EXPECTED_SIZE / 1024) EXPECTED_SIZE,
       TRUNC (ACTUAL_MEM_USED / 1024) ACTUAL_MEM_USED,
       TRUNC (MAX_MEM_USED / 1024) MAX_MEM_USED,
       NUMBER_PASSES PASS,
       TRUNC (TEMPSEG_SIZE / 1024) TEMPSEG_SIZE
  FROM V$SQL_WORKAREA_ACTIVE;