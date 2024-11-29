set echo off
set lines 200 pages 4000 verify off heading on
col username for a15
col "QC SID" for A6
col "SID" for A6
col "QC/Slave" for A8
col "Req. DOP" for 9999
col "Actual DOP" for 9999
col "Slaveset" for A8
col "Slave INST" for A5 heading 'Slave|Inst'
col "QC INST" for A6
col wait_event format a30
col SID:serial:ospid for a25
col sql_id for a18
col program for a25
  SELECT /*+ rule*/DECODE (
            px.qcinst_id,
            NULL, s.username,
            ' - '
            || LOWER (SUBSTR (pp.SERVER_NAME, LENGTH (pp.SERVER_NAME) - 4, 4)))
            "Username",
         DECODE (px.qcinst_id, NULL, 'QC', '(Slave)') "QC/Slave",
         TO_CHAR (px.server_set) "SlaveSet",
         s.sid||':'||s.serial#||':'||d.spid "SID:serial:ospid",
         DECODE(s.sql_id, '0', s.prev_sql_id, '',s.prev_sql_id,s.sql_id) || ':' ||
sql_child_number sql_id,substr(s.program,1,25) program,
         TO_CHAR (px.inst_id) "Slave INST",
 --        DECODE (sw.state, 'WAITING', 'WAIT', 'NOT WAIT') AS STATE,
         CASE sw.state
            WHEN 'WAITING' THEN SUBSTR (sw.event, 1, 30)
            ELSE NULL
         END
            AS wait_event,
         DECODE (px.qcinst_id, NULL, TO_CHAR (s.sid), px.qcsid) "QC SID",
         TO_CHAR (px.qcinst_id) "QC INST",
         px.req_degree "Req. DOP",
         px.degree "Actual DOP"
    FROM gv$px_session px,
         gv$session s,
         gv$px_process pp,
         gv$session_wait sw,
         v$process d
   WHERE     px.sid = s.sid(+)
         AND px.serial# = s.serial#(+)
         AND px.inst_id = s.inst_id(+)
         AND px.sid = pp.sid(+)
         AND px.serial# = pp.serial#(+)
         AND sw.sid = s.sid
         AND sw.inst_id = s.inst_id
         AND d.addr=s.paddr
ORDER BY DECODE (px.QCINST_ID, NULL, px.INST_ID, px.QCINST_ID),
         px.QCSID,
         DECODE (px.SERVER_GROUP, NULL, 0, px.SERVER_GROUP),
         px.SERVER_SET,
         px.INST_ID
/
