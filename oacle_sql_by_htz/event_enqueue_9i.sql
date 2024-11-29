/* Formatted on 2012/12/21 10:22:12 (QP5 v5.215.12089.38647) */
SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
col event for a7
COL program FORMAT a29
COL sess_sql_hash FOR a15
COL username FOR a11
col command for a10
COL client FOR a31
col id1-id2 for a15
col lmode for a15
col request for a35
col type for a4
SELECT a.event event,
       d.id1 || '-' || d.id2 "id1-id2",
       SUBSTR (b.program, 1, 39) program,
          b.sid
       || ':'
       || DECODE (sql_hash_value, 0, prev_hash_value, sql_hash_value)
          sess_sql_hash,
       b.username,
       e.name command,
       TO_CHAR (b.logon_time, 'mm-dd hh24:mi') logon_time,
       d.type,
       DECODE (d.lmode,
               1, '1||No Lock',
               2, '2||Row Share',
               3, '3||Row Exclusive',
               4, '4||ITL con/unique index',
               5, '5||Shr Row Excl',
               6, '6||row lock contention',
               NULL)
          lmode,
       DECODE (d.REQUEST,
               1, '1||No Lock',
               2, '2||Row Share',
               3, '3||Row Exclusive',
               4, '4||ITL con/unique index',
               5, '5||Shr Row Excl',
               6, '6||row lock contention',
               NULL)
          REQUEST,
       SUBSTR (
          b.osuser || '@' || b.machine || '@' || b.process || '@' || c.spid,
          1,
          31)
          client
  FROM v$session_wait a,
       v$session b,
       v$process c,
       v$enqueue_lock d,
       audit_actions  e
 WHERE     a.sid = b.sid
       AND b.paddr = c.addr
       AND a.event = 'enqueue'
       AND a.sid = d.sid
       AND e.action=b.command
/
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | please @itl_wait watch itl contention info                             |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

