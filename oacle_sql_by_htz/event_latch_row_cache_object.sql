SET ECHO OFF
SET PAGESIZE 2000
SET LINESIZE 200
SET HEADING ON
COL event FORMAT a25
COL program FORMAT a23
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|SEQ#'
COL client FOR a31
col sql_id for a18
COL row_wait  for a22 heading 'ROW_WAIT|FILE#:OBJ#:BLOCK#:ROW#'
col logon_time for a12
col status for a20  heading 'STATUS|STATE'
col command for a15
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col inst_id for 9 heading 'I'
col seq# for 999999999
break on inst_id

/* Formatted on 2013/9/5 15:36:57 (QP5 v5.240.12305.39476) */
  SELECT b.inst_id,
         SUBSTR (b.event, 1, 25) event,
         SUBSTR (b.program, 1, 22) program,
         b.username || ':' || b.seq# u_s,
         b.sid || ':' || b.serial# || ':' || c.spid os_sess,
         SUBSTR (b.status || ':' || b.state, 1, 19) status,
         a.name command,
            DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id)
         || ':'
         || sql_child_number
            sql_id,
            b.BLOCKING_SESSION_STATUS
         || ':'
         || b.BLOCKING_INSTANCE
         || ':'
         || b.BLOCKING_SESSION
            block_s,
            row_wait_file#
         || ':'
         || row_wait_obj#
         || ':'
         || row_wait_block#
         || ':'
         || row_wait_row#
            row_wait
    FROM gv$session b,
         gv$process c,
         gv$session_wait s,
         sys.audit_actions a
   WHERE     b.paddr = c.addr
         AND s.SID = b.SID
         AND b.inst_id = c.inst_id
         AND c.inst_id = s.inst_id
         AND a.action = b.command
         AND b.event = 'latch: row cache objects'
ORDER BY inst_id, sql_id 
/
col addr for a20
col name for a20

  SELECT addr,
         latch#,
         child#,
         level#,
         name,
         gets,
         sleeps,
         misses
    FROM v$latch_children
   WHERE name = 'row cache objects' AND gets <> 0
ORDER BY gets;
col name for a40
  SELECT DISTINCT s.kqrstcln latch#,
                  r.cache#,
                  r.parameter name,
                  r.TYPE,
                  r.subordinate#,
                  r.gets,
                  r.getmisses
    FROM v$rowcache r, x$kqrst s
   WHERE r.cache# = s.kqrstcid
ORDER BY 1, 4, 5;


clear    breaks  
