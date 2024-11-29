SET PAGESIZE 2000
SET ECHO OFF
SET LINESIZE 800
COL event FORMAT a29
COL program FORMAT a29
COL os_sess FOR a20 heading 'SESS_SERIAL|OSPID'
COL username FOR a11
COL client FOR a30
col sql_id for a18
COL row_wait  for a15 heading 'ROW_WAIT|FILE#|OBJ#|BLOCK#|ROW#'
col logon_time for a12
col status for a10
col rid for a18 heading 'ROWID'
col objec_name for a25 heading 'OBJECT|OWNER:NAME'
col object_type for a10
SELECT SUBSTR (b.event, 1, 25) event,
       SUBSTR (b.program, 1, 39) program,
          b.sid||':'||b.serial#||':'||c.spid os_sess
       ,b.status,DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id)
         || ':'
         || sql_child_number
            sql_id,
         row_wait_file# || ':'||row_wait_obj#||':' || row_wait_block# || ':' || row_wait_row#
          row_wait,
        dbms_rowid.rowid_create(1,row_wait_file#,row_wait_obj#,row_wait_block#,row_wait_row#) rid
        ,d.owner||':'||d.object_name objec_name,d.object_type
  FROM v$session b, v$process c, v$session_wait s,dba_objects d
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
       and d.object_id=b.row_wait_obj#
       order by sql_id
/
