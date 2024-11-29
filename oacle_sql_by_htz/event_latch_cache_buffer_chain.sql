/* Formatted on 2012/12/21 10:22:12 (QP5 v5.215.12089.38647) */
SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
COL event FORMAT a29
COL program FORMAT a29
COL os_sess FOR a25 heading 'SESS_SERIAL|OS_PROCESS'
COL username FOR a11
COL client FOR a31
col sql_id for a15
COL row_wait  for a15 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col p1text for a7
col p1 for 99999999999
col p1raw for a17
col p2 for 9999999
col p2raw for a17
col p2text for a6
col p3 for 9999
col p3text for a6
col p3raw for a4
col count for 99999 heading 'COUNT|RAW'
col count2 for 9999999 heading 'COUNT|RAW_SQL'
col count3 for 999999 heading 'COUNT|SQL_ID'
col raw_pct for a7 heading 'RAW_PCT'
col raw_sql_pct for a7 heading 'RAW_SQL|PCT'
select os_sess,
       sql_id,
       p1text,
       p1,
       p1raw,
       count,
       ROUND((count / count1) * 100, 2) || '%' raw_pct,
       count2,
       ROUND((count2 / count1) * 100, 2) || '%' raw_sql_pct,
       count3,
       p2text,
       p2,
       p2raw,
       p3text,
       p3,
       p3raw
  from (SELECT b.sid || ':' || b.serial# || ':' || c.spid os_sess,
               DECODE(b.sql_id, '0', b.prev_sql_id, b.sql_id) || ':' ||
               sql_child_number sql_id,
               b.P1TEXT,
               b.p1,
               b.p1raw,
               count(1) over(partition by p1raw) count,
               count(1) over() count1,
               count(1) over(partition by p1raw, sql_id) count2,
               count(1) over(partition by sql_id) count3,
               b.p2text,
               b.p2,
               b.p2raw,
               b.p3text,
               b.p3,
               b.p3raw
          FROM v$session b, v$process c
         WHERE b.paddr = c.addr
           AND b.event = 'latch: cache buffers chains')
 order by p1raw
/