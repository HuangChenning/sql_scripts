set echo off
set lines 200
set pages 40
col inst_id for 9 heading 'I'
COL program FORMAT a23
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
col sql_id for a17
col tablespace for a12
col contents for a15
col segtype for a10
col blocks for 9999999 heading 'SIZE(M)'
col event for a25
/* Formatted on 2013/10/14 21:23:14 (QP5 v5.240.12305.39476) */
 SELECT a.inst_id,
         b.username || ':' || b.last_call_et || ':' || b.seq# u_s,
         b.sid || ':' || b.serial# || ':' || d.spid os_sess,
         a.sql_id,
         A.TABLESPACE,
         a.contents,
         a.segtype,
         ROUND (a.blocks * c.VALUE / 1024 / 1024, 2) blocks,
            b.BLOCKING_SESSION_STATUS
         || ':'
         || b.BLOCKING_INSTANCE
         || ':'
         || b.BLOCKING_SESSION
            block_s,
         SUBSTR (b.program, 1, 22) program,
         SUBSTR(b.event, 1, 25) event
    FROM gv$tempseg_usage a,
         gv$session b,
         v$parameter c,
         gv$process d
   WHERE     a.inst_id = b.inst_id
         AND a.inst_id = d.inst_id
         AND d.addr = b.paddr
         AND a.session_addr = B.SADDR
         AND c.name = 'db_block_size'
ORDER BY inst_id, blocks DESC
/