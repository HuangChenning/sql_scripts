REM -------------------------------
REM Script TO monitor rman backup/restore operations REM TO run FROM sqlplus: @monitor '<yyyy-mm-dd hh24:mi:ss>' REM Example: --SQL>spool monitor.out
--SQL>@monitor '06-aug-12 16:38:03'
REM WHERE <date> IS the START time OF your rman backup OR restore job REM Run monitor script periodically TO confirm rman IS progessing REM -------------------------------

ALTER SESSION SET nls_date_format='yyyy-mm-dd hh24:mi:ss';


SET lines 200
SET pages 100
set verify off
col CLI_INFO format a10 
col spid format a5 
col ch format a20 
col inst_id for 99 heading 'I'
col seconds format 999999.99
col filename format a30
col bfc format 9 
col "% Complete" format 999.99 
col event format a40
SET numwidth 10
SELECT sysdate
FROM dual;

 REM gv$session_longops (channel LEVEL) prompt prompt Channel progress - gv$session_longops: prompt
SELECT s.inst_id,
       o.sid,
       CLIENT_INFO ch,
       context,
       sofar,
       totalwork,
       round(sofar/totalwork*100,2) "% Complete"
FROM gv$session_longops o,
                        gv$session s
WHERE opname LIKE 'RMAN%'
  AND opname NOT LIKE '%aggregate%'
  AND o.sid=s.sid
  AND totalwork != 0
  AND sofar <> totalwork and o.inst_id=s.inst_id;

 REM CHECK wait events (RMAN sessions) - this IS FOR CURRENT waits ONLY REM USE the following FOR 11G+ prompt prompt SESSION progess - CURRENT wait events AND time IN wait so far: prompt
SELECT a.inst_id,
       a.sid,
       a.CLIENT_INFO ch,
       -- seq#
       b.event,
       b.TIME_WAITED_MICRO/1000000 seconds
FROM gv$session a,gv$session_event b
WHERE a.program LIKE '%rman%'
  AND a.action IS NULL and a.sid=b.sid and a.inst_id=b.inst_id;

REM USE the following FOR 10G 
--select  inst_id, sid, CLIENT_INFO ch, seq#, event, state, seconds_in_wait secs 
--from gv$session where program like '%rman%' and
--wait_time = 0 and
--not action is null;
 REM gv$backup_async_io prompt prompt Disk (file AND backuppiece) progress - includes tape backuppiece prompt IF backup_tape_io_slaves=TRUE: prompt
SELECT s.inst_id,
       a.sid,
       CLIENT_INFO Ch,
       a.STATUS,
       open_time,
       round(BYTES/1024/1024,2) "SOFAR Mb" ,
       round(total_bytes/1024/1024,2) TotMb,
       io_count,
       round(BYTES/TOTAL_BYTES*100,2) "% Complete" ,
       a.type,
       filename
FROM gv$backup_async_io a,
                        gv$session s
WHERE NOT a.STATUS IN ('UNKNOWN')
  AND a.sid=s.sid
  AND open_time > to_date('&1', 'yyyy-mm-dd hh24:mi:ss') and a.inst_id=s.inst_id 
ORDER BY 2,
         7;

 REM gv$backup_sync_io prompt prompt Tape backuppiece progress (ONLY IF backup_tape_io_slaves=FALSE): prompt
SELECT s.inst_id,
       a.sid,
       CLIENT_INFO Ch,
       filename,
       a.type,
       a.status,
       buffer_size bsz,
       buffer_count bfc,
       open_time OPEN,
                 io_count
FROM gv$backup_sync_io a,
                       gv$session s
WHERE a.sid=s.sid
  AND open_time > to_date('&1', 'yyyy-mm-dd hh24:mi:ss')  and a.inst_id=s.inst_id;

 REM -------------------------------
