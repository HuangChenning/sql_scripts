set pages 1000
set lines 200;
col sess   for a20 heading 'sess:serial|os process';
col username for a15;
col client for a25;
col osuser for a10;
col program for a30;
col command for a20;
set verify off
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col u_s_l for a25 heading 'USERNAME.STATUS|LAST_elapsed_time.SEQ#'
col logon_time for a12
col a.status for a1
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display session :active,INACTIVE,all                                   |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT a.sid || ',' || a.serial# || '.' || c.spid AS sess,
       a.username||'.'||
       a.LAST_CALL_ET||'.'|| 
       a.seq# u_s_l,
       substr(a.status,1,14) status,
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
   AND a.program like '%&program%'
--and  a.command>0
 ORDER BY status
/