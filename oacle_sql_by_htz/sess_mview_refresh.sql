-- File Name : sess_mview_refresh.sql
-- Purpose : 显示正在刷新的物化视图进程
-- Version : 1.0
-- Date : 2015/09/05
-- Modify Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
SET ECHO OFF
SET PAGESIZE 2000
SET LINESIZE 200
SET HEADING ON verify off
COL event FORMAT a25
COL program FORMAT a23
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
col sql_id for a18
col mview for a30 heading 'MVIEW|OWNER_NAME'
col status for a20  heading 'STATUS|STATE'
col inst_id for 9 heading 'I'
break on inst_id
select s.inst_id,
       o.owner || '.' || o.object_name mview,
       s.username || ':' || s.last_call_et || ':' || s.seq# u_s,
       s.sid || ':' || s.serial# || ':' || b.spid os_sess,
       substr(s.status || ':' || s.state, 1, 19) status,
       DECODE(s.sql_id, '0', s.prev_sql_id, '', s.prev_sql_id, s.sql_id) || ':' ||
       s.sql_child_number sql_id,
       SUBSTR(s.event, 1, 25) event,
       SUBSTR(s.program, 1, 22) program
  from gv$lock l, dba_objects o, gv$session s, gv$process b
 where s.inst_id = l.inst_id
   and b.inst_id = s.inst_id
   and b.addr = s.paddr
   and o.object_id = l.id1
   and l.type = 'JI'
   and l.lmode = 6
   and s.sid = l.sid
   and o.object_type = 'TABLE';
