set pages 1000
set lines 270;
col sess   for a20 heading 'sess:serial|os process';
col u_s for a25 heading 'USERNAME|STATUS'
col client for a25;
col osuser for a10;
col program for a30;
col command for a12;
col l_s for a20 heading 'LAST_CALL|SEQ#'
set verify off
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col seq# for 999999999 heading 'seq#'
col inst_id for 99 heading 'ID'
col logon_time for a13
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display session :active,INACTIVE,all                                   |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT a.inst_id  ,
       a.sid || ',' || a.serial# || '.' || c.spid AS sess,
       a.username||'.'||a.status u_s,
       last_call_et||'.'||a.seq# l_s,
       SUBSTR(a.program, 1, 25) program,
       substr(a.osuser || '@' || a.machine || '@' || a.process,1,24) AS client,
       a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
       a.BLOCKING_SESSION block_s,
       DECODE(a.sql_id, '0', a.prev_sql_id, a.sql_id) || ':' ||
       sql_child_number sql_id,
       substr(b.name,12) AS command,
       TO_CHAR(a.logon_time, 'mm-dd hh24:mi') AS logon_time
  FROM gv$session a, audit_actions b, gv$process c
 WHERE a.command = b.action
   AND a.paddr = c.addr
   AND a.inst_id=c.inst_id
   AND a.username=upper(nvl('&username',a.username))
   AND a.status = DECODE(UPPER('&status'),
                         'ALL',
                         a.status,
                         'ACTIVE',
                         'ACTIVE',
                         'INACTIVE')
--and  a.command>0
 ORDER BY 1
/
undefine username;
undefine status;