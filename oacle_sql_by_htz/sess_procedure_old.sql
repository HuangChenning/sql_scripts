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
col w_o for a35 heading 'PROCEDURE |OWNER:NAME'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display session  is runing procedure                            |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sid prompt 'Enter Search Sid (i.e. 123|all default)) : ' default ''
ACCEPT name prompt 'Enter Search Procedure Name (i.e. 123|all default)) : ' default ''
SELECT a.inst_id,a.sid || ':' || a.serial# || ':' || c.spid AS sess,
       a.username,
       e.owner || ':' || e.OBJECT w_o,
       a.status,
       a.seq#,
       SUBSTR(a.program, 1, 25) program,
       substr(a.osuser || '@' || a.machine || '@' || a.process, 1, 24) AS client,
       a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
       a.BLOCKING_SESSION block_s,
       TO_CHAR(a.logon_time, 'mm-dd hh24:mi') AS logon_time
  FROM gv$session a, gv$process c, gv$access e
 WHERE a.paddr = c.addr(+)
   AND a.username IS NOT NULL
   and a.inst_id = c.inst_id
   and c.inst_id=e.inst_id
   AND a.sid = nvl('&sid', a.sid)
   and e.sid = a.sid
   and e.type = 'PROCEDURE'
   and e.object = nvl(upper('&name'), e.object)
 ORDER BY w_o
/
