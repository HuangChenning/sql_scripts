/* Formatted on 2012/12/21 10:22:12 (QP5 v5.215.12089.38647) */
SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
COL event FORMAT a29
COL program FORMAT a29
COL sess_sql_hash FOR a15
COL username FOR a11
COL client FOR a31

SELECT SUBSTR (b.event, 1, 25) event,
       SUBSTR (b.program, 1, 39) program,
          b.sid
       || ':'
       || DECODE (sql_hash_value, 0, prev_hash_value, sql_hash_value)
          sess_sql_hash,
       b.sql_id,
       b.username,
       SUBSTR (
          b.osuser || '@' || b.machine || '@' || b.process || '@' || c.spid,
          1,
          31)
          client,
       TO_CHAR (b.logon_time, 'mm-dd hh24:mi') logon_time
  FROM v$session b, v$process c, v$session_event s
 WHERE     b.paddr = c.addr
       AND s.SID = b.SID
       AND s.event <> 'Idle'
       AND s.event NOT LIKE '%SQL%'
       AND s.event NOT LIKE '%message%'
       AND s.event NOT LIKE '%time%'
       AND s.event NOT LIKE 'PX Deq:%'
       AND s.event NOT LIKE 'jobq slave%'
       AND s.event NOT LIKE '%idle%'
       AND s.event NOT LIKE '%Idle%'
       AND s.event NOT LIKE 'Streams AQ:%'
