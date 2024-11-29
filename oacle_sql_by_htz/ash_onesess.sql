set echo off
set verify off
set serveroutput on
set feedback off
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display event information from ash                                     |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT b_hours prompt 'Enter Search Hours Ago (i.e. 3) : '
ACCEPT e_hours prompt 'Enter How Many Hours  (i.e. 3) : '
ACCEPT i_sid prompt 'Enter Search Sid   (i.e. db 123) : '
variable b_hours number;
variable e_hours number;
variable i_sid number;
begin
   :e_hours:=&e_hours;
   :b_hours:=&b_hours;
   :i_sid:=&i_sid;
   end;
   /
set linesize 250
set pagesize 999
col sid for a10
col username for a8
col program for a15
col TOTAL  for 999999
col OTHER  for 9999 
col NET    for 99999
col APP    for 99999
col ADMIN  for 9999 
col CLUST  for 99999
col CONCUR for 99999
col CONFIG for 9999 
col COMMIT for 99999
col S_IO   for 99999
col UIO    for 99999
col CPU    for 99999
col BCPU   for 99999

/* Formatted on 2013/1/3 17:38:34 (QP5 v5.215.12089.38647) */
SELECT *
  FROM (  SELECT *
            FROM (  SELECT ASH.SESSION_ID || ',' || ASH.SESSION_SERIAL# SID,
                           SUM (cnt) TOTAL,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Other', cnt, 0)) OTHER,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Network', cnt, 0)) NET,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Application', cnt, 0))
                              APP,
                           SUM (
                              DECODE (ASH.WAIT_CLASS, 'Administration', cnt, 0))
                              ADMIN,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Cluster', cnt, 0)) CLUST,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Concurrency', cnt, 0))
                              CONCUR,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Configuration', cnt, 0))
                              CONFIG,
                           SUM (DECODE (ASH.WAIT_CLASS, 'Commit', cnt, 0)) COMMIT,
                           SUM (DECODE (ASH.WAIT_CLASS, 'System I/O', cnt, 0))
                              S_IO,
                           SUM (DECODE (ASH.WAIT_CLASS, 'User I/O', cnt, 0)) UIO,
                           SUM (DECODE (ASH.WAIT_CLASS, 'ON CPU', cnt, 0)) CPU,
                           SUM (DECODE (ASH.WAIT_CLASS, 'BCPU', cnt, 0)) BCPU,
                           SUBSTR (
                              NVL (U.USERNAME,
                                   ASH.SESSION_ID || '#' || ASH.SESSION_SERIAL#),
                              1,
                              8)
                              USERNAME,
                           SUBSTR (ASH.PROGRAM, 1, 15) PROGRAM
                      FROM (SELECT SQL_ID,
                                   USER_ID,
                                   SESSION_ID,
                                   SAMPLE_ID,
                                   SESSION_SERIAL#,
                                   PROGRAM,
                                   DECODE (
                                      SESSION_STATE,
                                      'ON CPU', DECODE (SESSION_TYPE,
                                                        'BACKGROUND', 'BCPU',
                                                        'ON CPU'),
                                      WAIT_CLASS)
                                      WAIT_CLASS,
                                   1 cnt
                              FROM GV$ACTIVE_SESSION_HISTORY
                             --from  ash_dump
                             WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
                                   AND SAMPLE_TIME <=
                                          SYSDATE - (:b_hours - :e_hours) / 24
                                   AND session_id = :i_sid
                            UNION ALL
                            SELECT SQL_ID,
                                   USER_ID,
                                   SESSION_ID,
                                   SAMPLE_ID,
                                   SESSION_SERIAL#,
                                   PROGRAM,
                                   DECODE (
                                      SESSION_STATE,
                                      'ON CPU', DECODE (SESSION_TYPE,
                                                        'BACKGROUND', 'BCPU',
                                                        'ON CPU'),
                                      WAIT_CLASS)
                                      WAIT_CLASS,
                                   10 cnt
                              FROM DBA_HIST_ACTIVE_SESS_HISTORY
                             WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
                                   AND SAMPLE_TIME <=
                                          SYSDATE - (:b_hours - :e_hours) / 24
                                   AND session_id = :i_sid) ASH,
                           DBA_USERS U
                     WHERE U.USER_ID(+) = ASH.USER_ID
                  GROUP BY ASH.SESSION_ID,
                           ASH.SESSION_SERIAL#,
                           ASH.PROGRAM,
                           U.USERNAME)
        ORDER BY TOTAL DESC)
 WHERE ROWNUM <= 100;

undefine 1
undefine 2


col time for a19 heading 'sample_time'
col sess_id for a15 heading 'session|serial#'
col sqlid for a18 heading 'sql_id|child_number'
col pn_text for a30 heading 'P1_TEXT:P2_TEXT:P3_TEXT'
col pn for a20 heading 'P1:P2:P3'
col oevent for a30 heading 'Event'
col oprogram for a15 heading 'PROGRAM'
col obj for a15 heading 'waiting|obj#:file#block#'


--SELECT TO_CHAR (sample_time, 'dd hh24:mi:ss') time,
--       session_id || '-' || session_serial# sess_id,session_state,
--       SUBSTR (program, 1, 30) oprogram,
--       sql_id || ':' || sql_child_number sqlid,
--       SUBSTR (event, 0, 15) oevent,
--       p1text || ':' || p2text || ':' || p3text pn_text,
--       p1 || ':' || p2 || ':' || p3 pn,
--       current_obj#||':'||current_file#||':'||current_block#  obj
--  FROM GV$ACTIVE_SESSION_HISTORY
-- WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
--       AND SAMPLE_TIME <= SYSDATE - (:b_hours - :e_hours) / 24
--       AND session_id = :i_sid
--UNION ALL
--SELECT TO_CHAR (sample_time, 'dd hh24:mi:ss') time,
--       session_id || '-' || session_serial# sess_id,session_state,
--       SUBSTR (program, 1, 30),
--       sql_id || ':' || sql_child_number sqlid,
--       SUBSTR (event, 0, 15) oevent,
--       p1text || ':' || p2text || ':' || p3text pn_text,
--       p1 || ':' || p2 || ':' || p3 pn,
--       current_obj#||':'||current_file#||':'||current_block#  obj
--  FROM DBA_HIST_ACTIVE_SESS_HISTORY
-- WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
--       AND SAMPLE_TIME <= SYSDATE - (:b_hours - :e_hours) / 24
--       AND session_id = :i_sid
--ORDER BY TIME
--/

clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
