set pages 1000
set lines 270;
col sess   for a20 heading 'sess:serial|os process';
col status for a10;
col username for a15;
col client for a25;
col osuser for a10;
col program for a30;
col command for a20;
set verify off
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col seq# for 999999999 heading 'seq#'
col l_s for a15 heading 'LAST_CALL_ET|SEQ#'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display session :active,INACTIVE,all                                   |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT status prompt 'Enter Search Status (i.e. active(default)|all|INACTIVE) : ' default 'active'
ACCEPT sid prompt 'Enter Search Sid (i.e. 123|0(all default)) : ' default 0
ACCEPT spid prompt 'Enter Search Os process number (i.e. 123|0(all default)) : ' default 0

SELECT /*+ rule*/a.sid || ',' || a.serial# || '.' || c.spid AS sess,
       a.username,
       a.status,
       a.last_call_et||'.'||a.seq# l_s,
       SUBSTR(a.program, 1, 25) program,
       substr(a.osuser || '@' || a.machine || '@' || a.process,1,24) AS client,
       a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
       a.BLOCKING_SESSION block_s,
       DECODE(a.sql_id, '0', a.prev_sql_id, a.sql_id) || ':' ||
       sql_child_number sql_id,
       b.name AS command,
       TO_CHAR(a.logon_time, 'mm-dd hh24:mi') AS logon_time
  FROM v$session a, audit_actions b, v$process c
 WHERE a.command = b.action
   AND a.paddr = c.addr
   AND a.username IS NOT NULL
   AND a.status = DECODE(UPPER('&status'),
                         'ALL',
                         a.status,
                         'ACTIVE',
                         'ACTIVE',
                         'INACTIVE')
   AND a.sid = decode(&sid, 0, a.sid, &sid)
   AND c.spid = decode(&spid, 0, c.spid, &spid)
--and  a.command>0
 ORDER BY sess
/