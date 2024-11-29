set echo off
set lines 2000 pages 3000 verify off heading on
col kill for a20
col program for a20
col username for a15
col event for a20
col what for a100
SELECT 'kill -9 ' || p.spid kill,
       j.instance,
       p.program,
       s.username,
       SUBSTR (s.event, 1, 20) event,
       j.what
  FROM v$session s,
       dba_jobs_running r,
       v$process p,
       dba_jobs j
 WHERE     s.sid = r.sid
       AND s.paddr = p.addr
       AND r.job = j.job
       AND j.instance = (SELECT instance_number - 1 FROM v$instance);