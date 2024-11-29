set pages 9999;
set linesize 200;
col event for a40;
col curtime for a10
col program format a27
col username for a9
col client for a25
col sess for a12
col event for a30
col SQLID for a20
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one session info include event                                 |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sid_id prompt 'Enter Search sid (i.e. CONTROL|0) : '

SELECT distinct TO_CHAR (SYSDATE, 'hh24:mi:ss') AS curtime,
       a.sid || ':' || a.serial# AS sess,
       a.program,
       a.username,
       b.name command,
       TO_CHAR (a.logon_time, 'mmdd hh24:mi:ss') AS logon_time,
       a.machine || '@' || a.osuser || '@' || a.process AS client,
       DECODE (a.sql_hash_value, 0, a.prev_hash_value, a.sql_hash_value)
          hash_value
  FROM sys.v$session a,sys.audit_actions b
 WHERE a.sid = DECODE (&sid_id, 0, a.sid, &sid_id)
 and a.command=b.action
/
