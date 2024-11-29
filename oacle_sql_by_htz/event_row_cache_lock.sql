SET ECHO OFF
SET PAGESIZE 2000
SET LINESIZE 200
SET HEADING ON
COL event FORMAT a20
COL program FORMAT a29
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
COL username FOR a11
COL client FOR a30
col sql_id for a18
COL row_wait  for a25 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col logon_time for a12
col status for a10
col parameter for a22 heading 'ROW CACHE TYPE|PARAMETER'
SELECT SUBSTR(b.event, 1, 19) event,
       SUBSTR(b.program, 1, 39) program,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       b.status,
       DECODE(b.sql_id, '0', b.prev_sql_id, b.sql_id) || ':' ||
       sql_child_number sql_id,
       d.parameter,
       b.username,
       SUBSTR(b.osuser || '@' || b.machine || '@' || b.process, 1, 30) client,
       TO_CHAR(b.logon_time, 'mm-dd hh24:mi') logon_time
  FROM v$session b, v$process c, v$session_wait s, v$rowcache d
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   AND b.event = 'row cache lock'
   and b.P1 = d.CACHE#
/
