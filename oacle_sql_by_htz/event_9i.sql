/* Formatted on 2012/12/21 10:22:12 (QP5 v5.215.12089.38647) */
SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 170
COL event FORMAT a39
COL program FORMAT a29
COL sess_sql_hash FOR a15
COL username FOR a11
COL client FOR a31
COL row_wait  for a15 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
/* Formatted on 2012/12/21 10:29:22 (QP5 v5.215.12089.38647) */
SELECT SUBSTR (a.event, 1, 25) event,
       SUBSTR (b.program, 1, 39) program,
          b.sid
       || ':'
       || DECODE (sql_hash_value, 0, prev_hash_value, sql_hash_value)
          sess_sql_hash,
       b.username,
       d.name command,
       row_wait_file# || ':' || row_wait_obj#||':'||row_wait_block# || ':' || row_wait_row#
          row_wait,
       SUBSTR (
          b.osuser || '@' || b.machine || '@' || b.process || '@' || c.spid,
          1,
          31)
          client,
       TO_CHAR (b.logon_time, 'mm-dd hh24:mi') logon_time
  FROM v$session_wait a,
       v$session b,
       v$process c,
       audit_actions d
 WHERE     a.sid = b.sid
       AND b.paddr = c.addr
       AND a.event NOT LIKE '%SQL%'
       AND a.event NOT LIKE '%message%'
       AND a.event NOT LIKE '%time%'
       AND a.event NOT LIKE 'PX Deq:%'
       AND d.action = b.command
       AND a.event NOT LIKE 'jobq slave%'
/
