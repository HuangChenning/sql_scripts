SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN inst_id           FORMAT 99      HEADING 'I'
COLUMN sid                                HEADING 'Oracle|SID'
COLUMN serial_num                         HEADING 'Serial|#'
COLUMN opname             FORMAT a30      HEADING 'RMAN|Operation'
COLUMN start_time         FORMAT a18      HEADING 'Start|Time'
COLUMN totalwork                          HEADING 'Total|Work'
COLUMN sofar                              HEADING 'So|Far'
COLUMN pct_done           FORMAT a10      HEADING 'Percent|Done'
COLUMN elapsed_seconds                    HEADING 'Elapsed|Seconds'
COLUMN time_remaining                     HEADING 'Seconds|Remaining'
COLUMN done_at            FORMAT a18      HEADING 'Done|At'

SELECT a.inst_id,
       a.sid sid,
       a.serial# serial_num,
       b.opname opname,
       TO_CHAR(b.start_time, 'mm/dd/yy HH24:MI:SS') start_time,
       b.totalwork totalwork,
       b.sofar sofar,
       ROUND((b.sofar / DECODE(b.totalwork, 0, 0.001, b.totalwork) * 100),
             2) || '%' pct_done,
       b.elapsed_seconds elapsed_seconds,
       b.time_remaining time_remaining,
       DECODE(b.time_remaining,
              0,
              TO_CHAR((b.start_time + b.elapsed_seconds / 3600 / 24),
                      'mm/dd/yy HH24:MI:SS'),
              TO_CHAR((SYSDATE + b.time_remaining / 3600 / 24),
                      'mm/dd/yy HH24:MI:SS')) done_at
  FROM gv$session a, gv$session_longops b
 WHERE a.program LIKE 'rman%'
   AND b.opname LIKE 'RMAN%'
   AND b.opname NOT LIKE '%aggregate%'
   AND b.totalwork > 0
   AND b.sofar <> b.totalwork
   AND a.sid = b.sid
   AND a.inst_id = b.inst_id
 ORDER BY a.inst_id, b.start_time 
 /
