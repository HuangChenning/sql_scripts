SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
COL event FORMAT a29
COL program FORMAT a29
COL os_sess FOR a20 heading 'SESS_SERIAL|OSPID'
COL username FOR a11
COL client FOR a30
col sql_id for a18
COL row_wait  for a20 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col logon_time for a12
col status for a10
col text for a40 heading 'p1text-p3text'
SELECT SUBSTR(b.event, 1, 25) event,
       b.p1text || ':' || b.p1 || ':' || b.p2text || ':' || b.p2 || ':' ||
       b.p3text || ':' || b.p3 text,
       SUBSTR(b.program, 1, 29) program,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       b.username,
       b.status,
       DECODE(b.sql_id, '0', b.prev_sql_id, b.sql_id) || ':' ||
       sql_child_number sql_id,
       row_wait_file# || ':' || row_wait_obj# || ':' || row_wait_block# || ':' ||
       row_wait_row# row_wait
  FROM v$session b, v$process c, v$session_wait s
 WHERE b.paddr = c.addr
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
 order by sql_id
/

prompt SELECT MUTEX_TYPE, LOCATION 
prompt   FROM x$mutex_sleep
prompt  WHERE mutex_type like 'Cursor Pin%' 
prompt    and location_id=
prompt     
prompt    SELECT sql_id, sql_text, version_count 
prompt   FROM V$SQLAREA where HASH_VALUE=
prompt 

SELECT SUBSTR(b.event, 1, 25) event,
       SUBSTR(b.program, 1, 29) program,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       b.p1 hash_value,
       decode(trunc(b.P2/4294967296),
           0,trunc(b.P2/65536),
             trunc(b.P2/4294967296)) SID_HOLDING_MUTEX,
             decode(trunc(b.P3/4294967296),
            0,trunc(b.P3/65536),
              trunc(b.P3/4294967296)) LOCATION_ID,
       b.username,
       b.status,
       DECODE(b.sql_id, '0', b.prev_sql_id, b.sql_id) || ':' ||
       sql_child_number sql_id
  FROM gv$session b, gv$process c, gv$session_wait s
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   and b.inst_id=c.inst_id
   and b.inst_id=s.inst_id
   AND b.event='&event_name';