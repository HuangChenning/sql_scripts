set echo off
set lines 2000 pages 1000 heading on
col capture_name for a30
col capture_type for a10
col status for a15
col REQ_SCN for a18
col OLDEST_SCN for a18
SELECT CAPTURE_NAME,
       CAPTURE_TYPE,
       STATUS,
       TO_CHAR (REQUIRED_CHECKPOINT_SCN, '999999999999999') AS REQ_SCN,
       TO_CHAR (OLDEST_SCN, '999999999999999')              AS OLDEST_SCN
  FROM DBA_CAPTURE
/