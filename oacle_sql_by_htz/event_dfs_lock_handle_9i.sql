SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
COL event FORMAT a25
COL program FORMAT a29
COL os_sess FOR a20 heading 'SESS_SERIAL|OSPID'
col l_s for 99999 heading 'LAST|ET'
col hash_value for 9999999999
col status for a10
col lock_mode for a4 heading 'LOCK|MODE'
col id1_id2 for a5 heading ID1_ID2|P2_P3'
SELECT SUBSTR (b.event, 1, 25) event,
       SUBSTR (b.program, 1, 29) program,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       b.last_call_et  l_s,
       b.username || '.' || b.status user_status,
          DECODE (b.sql_hash_value, '0', b.prev_hash_value, b.sql_hash_value) hash_value,
       a.name,
          CHR (BITAND (s.p1, -16777216) / 16777215)
       || CHR (BITAND (s.p1, 16711680) / 65535)
       ||'.'||TO_CHAR (BITAND (s.p1, 65536)) lock_mode,
       s.p2 || '.' || s.p3 id1_id2
  FROM gv$session b,
       gv$process c,
       gv$session_wait s,
       audit_actions a
 WHERE     b.paddr = c.addr
       AND s.SID = b.SID
       AND b.inst_id = c.inst_id
       AND b.inst_id = s.inst_id
       AND b.command = A.ACTION
       AND b.event = 'DFS lock handle'
/
PROMPT SELECT inst_id,
PROMPT        sid,
PROMPT        TYPE,
PROMPT        id1,
PROMPT        id2,
PROMPT        lmode,
PROMPT        request,
PROMPT        block
PROMPT   FROM gv$lock
PROMPT  WHERE TYPE = 'CI' AND id1 = 9 AND id2 = 5
@sqlplusset
