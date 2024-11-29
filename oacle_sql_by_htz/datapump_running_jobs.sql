
SET lines 180
set echo off
COL owner_name FORMAT a10 heading 'OWNER|NAME'
COL job_name FORMAT a20
COL job_state FORMAT a12
COL operation for a10
COL job_mode for a10
col object_id for 9999999
col object_type for a15
col object_name for a25
col obj_owner for a15
col sess   for a10;
col status for a10;
col username for a10;
col owner_name for a20;
col client for a18;
col osuser for a10;
col state for a10;
col job_mode for a15;
col program for a20
col per_done for a7
col attached_sessions for 999 heading 'ATTACHED|SESSIONS'
  SELECT a.owner_name,
         a.job_name,
         a.operation ,
         a.job_mode,
         a.state job_state,
         b.status obj_status,
         b.object_id,
         b.object_type,
         b.owner obj_owner,
         b.object_name,
         a.attached_sessions 
    FROM dba_datapump_jobs a, dba_objects b
   WHERE     a.job_name NOT LIKE 'BIN$%'
         AND a.owner_name = b.owner
         AND a.job_name = b.object_name
ORDER BY 1, 2
/
pro "DISPLAY DATAPUMP SESSION LONGOPS AND %"
SELECT a.sid || ',' || a.serial# AS sess,
       c.username,
       c.status,
       SUBSTR (c.program, 1, 20) program,
       c.osuser || '@' || c.machine || '@' || c.process AS client,
       ROUND (a.SOFAR * 100 / a.TOTALWORK, 0) || '%' AS "per_done",
       b.owner_name,
       b.OPERATION,
       b.state,
       b.job_mode
  FROM v$session_longops a, dba_datapump_jobs b, v$session c
 WHERE a.opname = b.job_name AND c.sid = a.sid AND c.serial# = a.serial#
/

