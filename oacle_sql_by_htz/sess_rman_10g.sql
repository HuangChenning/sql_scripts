REM -------------------------------
REM Script to monitor rman backup/restore operations
REM To run from sqlplus:   @monitor '<yyyy-mm-dd hh24:mi:ss>'
REM Example:
REM where <date> is the start time of your rman backup or restore job
REM Run monitor script periodically to confirm rman is progessing
REM -------------------------------

ALTER SESSION SET nls_date_format='yyyy-mm-dd hh24:mi:ss';
SET LINES 1500
SET PAGES 100
COL CLI_INFO FORMAT a10
COL spid FORMAT a5
COL ch FORMAT a20
COL seconds FORMAT 999999.99
COL filename FORMAT a65
COL bfc  FORMAT 9
COL "% Complete" FORMAT 999.99
COL event FORMAT a40
SET NUMWIDTH 10

SELECT SYSDATE FROM DUAL;

REM gv$session_longops (channel level)

PROMPT
PROMPT Channel progress - gv$session_longops:
PROMPT

SELECT s.inst_id,
       o.sid,
       CLIENT_INFO ch,
       context,
       sofar,
       totalwork,
       ROUND (sofar / totalwork * 100, 2) "% Complete"
  FROM gv$session_longops o, gv$session s
 WHERE     opname LIKE 'RMAN%'
       AND opname NOT LIKE '%aggregate%'
       AND o.sid = s.sid
       AND totalwork != 0
       AND sofar <> totalwork;

REM Check wait events (RMAN sessions) - this is for CURRENT waits only
REM use the following for 11G+
PROMPT
PROMPT Session progess - CURRENT wait events and time in wait so far:
PROMPT

REM use the following for 10G

SELECT inst_id,
       sid,
       CLIENT_INFO ch,
       seq#,
       event,
       state,
       seconds_in_wait secs
  FROM gv$session
 WHERE program LIKE '%rman%' AND wait_time = 0 AND NOT action IS NULL;
REM gv$backup_async_io
PROMPT
PROMPT Disk (file and backuppiece) progress - includes tape backuppiece
PROMPT if backup_tape_io_slaves=TRUE:
PROMPT

  SELECT s.inst_id,
         a.sid,
         CLIENT_INFO Ch,
         a.STATUS,
         open_time,
         ROUND (BYTES / 1024 / 1024, 2) "SOFAR Mb",
         ROUND (total_bytes / 1024 / 1024, 2) TotMb,
         io_count,
         ROUND (BYTES / TOTAL_BYTES * 100, 2) "% Complete",
         a.TYPE,
         filename
    FROM gv$backup_async_io a, gv$session s
   WHERE     NOT a.STATUS IN ('UNKNOWN')
         AND a.sid = s.sid
         AND open_time > TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss')
ORDER BY 2, 7;

REM gv$backup_sync_io
PROMPT
PROMPT Tape backuppiece progress (only if backup_tape_io_slaves=FALSE):
PROMPT

SELECT s.inst_id,
       a.sid,
       CLIENT_INFO Ch,
       filename,
       a.TYPE,
       a.status,
       buffer_size bsz,
       buffer_count bfc,
       open_time open,
       io_count
  FROM gv$backup_sync_io a, gv$session s
 WHERE a.sid = s.sid AND open_time > TO_DATE ('&&date', 'yyyy-mm-dd hh24:mi:ss');

REM -------------------------------