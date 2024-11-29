SET PAGESIZE 40
SET ECHO OFF
SET LINESIZE 800
SET HEADING ON
COL event FORMAT a25
COL program FORMAT a29
COL os_sess FOR a20 heading 'SESS_SERIAL|OSPID'
COL username FOR a11
COL client FOR a30
col sql_id for a15
COL row_wait  for a20 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col logon_time for a12
col status for a10
col text for a40 heading 'p1text-p3text'
col inst_id for 9  heading 'I'
col instance_sess for a15 heading 'BLOCK|SESSION'
SELECT /*+ rule */s.inst_id,SUBSTR(b.event, 1, 25) event,
       b.p1text || ':' || b.p1raw || ':' || b.p2text || ':' || b.p2raw || ':' ||
       b.p3text || ':' || b.p3raw text,
       SUBSTR(b.program, 1, 29) program,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       b.username,
       b.status,
       DECODE(b.sql_id, '0', b.prev_sql_id, b.sql_id) || ':' ||
       sql_child_number sql_id,
       b.blocking_instance||'.'||b.blocking_session instance_sess,
       row_wait_file# || ':' || row_wait_obj# || ':' || row_wait_block# || ':' ||
       row_wait_row# row_wait
  FROM gv$session b, gv$process c, gv$session_wait s
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   AND s.inst_id=b.inst_id
   AND b.inst_id=c.inst_id
   AND s.event <> 'Idle'
   AND s.event NOT LIKE '%SQL%'
   AND s.event NOT LIKE '%message%'
   AND s.event NOT LIKE '%time%'
   AND s.event NOT LIKE 'PX Deq:%'
   AND s.event NOT LIKE 'jobq slave%'
   AND s.event NOT LIKE '%idle%'
   AND s.event NOT LIKE '%Idle%'
   AND s.event NOT LIKE 'Streams AQ:%'
 order by inst_id,event;