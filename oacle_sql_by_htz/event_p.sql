SET ECHO OFF
SET PAGESIZE 2000  LINESIZE 300 VERIFY OFF HEADING ON
COL event FORMAT a15
COL program FORMAT a15
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
COL client FOR a31
col sql_id for a18
COL row_wait  for a22 heading 'ROW_WAIT|FILE#:OBJ#:BLOCK#:ROW#'
col logon_time for a12
col status for a10  heading 'STATUS|STATE'
col command for a3
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col INST_ID for 9 heading 'I'
col EXEC_TIME for a5 heading 'RUN|TIME'
col ptext for a80



break on inst_id
SELECT b.inst_id,
       SUBSTR(DECODE(b.STATE, 'WAITING', b.EVENT), 1, 15) event,
       SUBSTR(b.program, 1, 15) program,
       b.username || ':' || last_call_et || ':' || b.seq# u_s,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       substr(a.name, 1, 3) command,
       DECODE(b.sql_id,
              '0',
              'P.' || b.prev_sql_id,
              '',
              'P.' || b.prev_sql_id,
              'C.' || b.sql_id) || ':' || sql_child_number sql_id,
       substr(((sysdate - nvl(b.SQL_EXEC_START, b.PREV_EXEC_START)) * 24 * 3600),
              1,
              4) EXEC_TIME,
       b.p1text || ':' || b.p1 || ':' || b.p2text || ':' || b.p2 || ':' ||
       b.p3text || ':' || b.p3 ptext
  FROM gv$session b, gv$process c, gv$session_wait s, sys.audit_actions a
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   and b.inst_id = c.inst_id
   and c.inst_id = s.inst_id
   and a.action = b.command
   and b.status = 'ACTIVE'
   and b.username is not null
 order by inst_id, sql_id
/