SET LINESIZE 200
set echo off
SET PAGESIZE 9999

COLUMN opname           FORMAT a35      HEADING 'RMAN|Operation'
COLUMN start_time       FORMAT a18      HEADING 'Start|Time'
COLUMN totalwork                        HEADING 'Total|Work'
COLUMN sofar                            HEADING 'So|Far'
COLUMN pct_done                         HEADING 'Percent|Done'
COLUMN elapsed_seconds                  HEADING 'Elapsed|Seconds'
COLUMN time_remaining                   HEADING 'Seconds|Remaining'
COLUMN done_at          FORMAT a20      HEADING 'Done|At'
COLUMN client           FORMAT a25      HEADING 'Client'
COLUMN sess             FORMAT a15      HEADING 'Session|Serial'
  SELECT a.sid || ',' || a.serial# sess,
         b.opname opname,
         a.osuser || '@' || a.machine || '@' || a.process AS client,
         b.totalwork totalwork,
         b.sofar sofar,
         ROUND ( (b.sofar / DECODE (b.totalwork, 0, 0.001, b.totalwork) * 100),
                2)
            pct_done,
         b.elapsed_seconds elapsed_seconds,
         b.time_remaining time_remaining,
         TO_CHAR (b.start_time, 'mm-dd HH24:MI:SS') start_time,
         DECODE (
            b.time_remaining,
            0, TO_CHAR ( (b.start_time + b.elapsed_seconds / 3600 / 24),
                        'YYYY-MM-DD HH24:MI:SS'),
            TO_CHAR ( (SYSDATE + b.time_remaining / 3600 / 24),
                     'YYYY-MM-DD HH24:MI:SS'))
            done_at
    FROM v$session a, v$session_longops b
   WHERE     a.program LIKE 'rman%'
         AND b.opname LIKE 'RMAN%'
         AND b.opname NOT LIKE '%aggregate%'
         AND b.totalwork > 0
         AND b.totalwork<>b.sofar
         AND a.sid = b.sid
         AND a.serial# = b.serial#
         --  and  a.command>0
ORDER BY b.start_time
/