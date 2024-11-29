store set sqlplusset replace
set lines 170
col sample_id noprint format 9999999
col sample_time format a19
col sess for a15 
col event format a19
col blocking_sid heading "BLOCKING_SID_MUTEX" format 9999999
col shared_refcount noprint heading "RFC" format 99
col location_id heading "LOCATION|ID" format 99
col sleeps  noprint format 99999
col mutex_object format a30
set pagesize 50000
set wrap off
 
ACCEPT begin_time prompt 'Enter Search Hours Ago (i.e. 2012-01-02 22:00:00) : '
ACCEPT end_time prompt 'Enter How Many Hours  (i.e. 2012-01-02 22:00:03) : '

SELECT TO_CHAR (sample_time, 'yyyy-mm-dd hh24:mi:ss') sample_time,
       event,
       session_id || ':' || session_serial# sess,
       sql_id,
       p1 hash_value,
       FLOOR (p2 / POWER (2, 4 * ws)) blocking_sid,
       MOD (p2, POWER (2, 4 * ws)) shared_refcount,
       FLOOR (p3 / POWER (2, 4 * ws)) location_id,
       MOD (p3, POWER (2, 4 * ws)) sleeps,
       substr(CASE
          WHEN (event LIKE 'library cache:%' AND p1 <= POWER (2, 17))
          THEN
             'library cache bucket: ' || p1
          ELSE
             (SELECT kglnaobj
                FROM x$kglob
               WHERE kglnahsh = p1 AND (kglhdadr = kglhdpar) AND ROWNUM = 1)
       END,1,30)
          mutex_object
  FROM (SELECT DECODE (INSTR (banner, '64'), 0, '4', '8') ws
          FROM v$version
         WHERE ROWNUM = 1) wordsize,
       gv$active_session_history
 WHERE     p1text = 'idn'
       AND session_state = 'WAITING'
       AND SAMPLE_TIME >= TO_DATE ('&begin_time', 'yyyy-mm-dd hh24:mi:ss')
       AND SAMPLE_TIME <= TO_DATE ('&end_time', 'yyyy-mm-dd hh24:mi:ss')
UNION ALL
SELECT TO_CHAR (sample_time, 'yyyy-mm-dd hh24:mi:ss') sample_time,
       event,
       session_id || ':' || session_serial#,
       sql_id,
       p1 hash_value,
       FLOOR (p2 / POWER (2, 4 * ws)) blocking_sid,
       MOD (p2, POWER (2, 4 * ws)) shared_refcount,
       FLOOR (p3 / POWER (2, 4 * ws)) location_id,
       MOD (p3, POWER (2, 4 * ws)) sleeps,
       substr(CASE
          WHEN (event LIKE 'library cache:%' AND p1 <= POWER (2, 17))
          THEN
             'library cache bucket: ' || p1
          ELSE
             (SELECT kglnaobj
                FROM x$kglob
               WHERE kglnahsh = p1 AND (kglhdadr = kglhdpar) AND ROWNUM = 1)
       END,1,30)
          mutex_object
  FROM (SELECT DECODE (INSTR (banner, '64'), 0, '4', '8') ws
          FROM v$version
         WHERE ROWNUM = 1) wordsize,
       DBA_HIST_ACTIVE_SESS_HISTORY
 WHERE     p1text = 'idn'
       AND session_state = 'WAITING'
       AND SAMPLE_TIME >= TO_DATE ('&begin_time', 'yyyy-mm-dd hh24:mi:ss')
       AND SAMPLE_TIME <= TO_DATE ('&end_time', 'yyyy-mm-dd hh24:mi:ss')
ORDER BY sample_time
/
@sqlplusset
