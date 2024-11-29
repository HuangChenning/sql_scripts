set echo off
set lines 200 pages 40
set heading on
col client for a23 heading 'CLIENT|OSUSER_MACHINE_SPID'
col client_txid for a30 heading 'CLIENT|TXID'
col u_s for a22 heading 'USERNMAE|LAST_CALL_SEQ#'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col sql_id for a17
COL os_sess FOR a20 heading 'SESS_SERIAL|OSPID'
col command for a15
col event for a25
col status for a19
SELECT /*+ ORDERED */
 SUBSTR(a.osuser || '@' || a.machine || '@' || a.process, 1, 24) AS client,
 G.K2GTITID_ORA "client_TXID",
 a.inst_id || ':' || a.username || ':' || a.last_call_et || ':' || a.seq# u_s,
 a.sid || ':' || a.serial# || ':' || c.spid os_sess,
 substr(a.status || ':' || a.state, 1, 19) status,
 DECODE(a.sql_id, '0', a.prev_sql_id, '', a.prev_sql_id, a.sql_id) || ':' ||
 sql_child_number sql_id,
 d.name command,
 a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
 a.BLOCKING_SESSION block_s,
 SUBSTR(a.event, 1, 25) event
  FROM SYS.X$K2GTE       G,
       SYS.X$KTCXB       T,
       SYS.X$KSUSE       S,
       gv$session        a,
       gv$process        c,
       sys.audit_actions d
 WHERE G.K2GTDXCB = T.KTCXBXBA
   AND G.K2GTDSES = T.KTCXBSES
   AND S.ADDR = G.K2GTDSES
   AND a.sid = s.indx
   AND a.inst_id(+) = c.inst_id
   AND a.paddr(+) = c.addr
   AND a.inst_id = s.inst_id
   AND d.action = a.command
   and a.process = nvl('&clientospid', a.process)
   and a.username = nvl(upper('&dbusername'), a.username)
   and a.osuser = nvl(upper('&clientusername'), a.osuser)
   and a.machine = nvl(upper('&clienthostname'), a.machine)
 order by client
       

 /