SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
SET HEADING ON
COL event FORMAT a29
COL program FORMAT a29
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
COL username FOR a11
COL client FOR a30
col sql_id for a15
COL row_wait  for a25 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col logon_time for a12
col status for a10
SELECT /*+ rule */SUBSTR (b.event, 1, 25) event,
       SUBSTR (b.program, 1, 29) program,
          b.sid||':'||b.serial#||':'||c.spid os_sess
       ,b.status,DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id)
         || ':'
         || sql_child_number
            sql_id,
         row_wait_file# || ':'||row_wait_obj#||':' || row_wait_block# || ':' || row_wait_row#
          row_wait,
       b.username,
       SUBSTR (
          b.osuser || '@' || b.machine || '@' || b.process,
          1,
          30)
          client,
       TO_CHAR (b.logon_time, 'mm-dd hh24:mi') logon_time
  FROM v$session b, v$process c, v$session_wait s
 WHERE     b.paddr = c.addr
       AND s.SID = b.SID
       AND b.status='ACTIVE'
       order by sql_id
/
