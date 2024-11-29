set echo off
set pages 9999;
set linesize 200; 
set heading on
set verify off
set long 55555


col event for a50;
col curtime for a10
col program format a27
col username for a9
col client for a25
col sess for a22
col event for a30
col SQLID for a20
col command for a10
col inst_id for 9 heading 'I'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
col status for a20  heading 'STATUS|STATE'

SELECT a.inst_id,
       a.sid || ':' || a.serial# || ':' || c.spid AS sess,
       substr(a.program,1,27) program,
       a.username||':'||a.last_call_et||':'||a.seq# u_s,
       substr(a.status || ':' || a.state,1,19) status,  
       b.name command,
       a.machine || '@' || a.osuser || '@' || a.process AS client,
       DECODE(a.sql_id, '', 'p'||'_'||a.prev_sql_id, a.sql_id) || ':' ||
       sql_child_number AS SQLID,
       substr(a.event,1,30) || ':' || a.p1 || ':' || a.p2 AS event
  FROM sys.gv$session a, audit_actions b, gv$process c
 WHERE a.inst_id = c.inst_id
   and a.paddr = c.addr
   and a.command = b.action
   and a.inst_id = nvl('&inst_id', a.inst_id)
   and a.sid = nvl('&sid', a.sid)
   order by inst_id
/
undefine inst_id;
undefine sid;
