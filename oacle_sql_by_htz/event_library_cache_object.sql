SET ECHO OFF
SET PAGESIZE 2000  LINESIZE 200 VERIFY OFF HEADING ON
COL event FORMAT a18
COL program FORMAT a23
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
COL client FOR a31
col sql_id for a18
COL row_wait  for a22 heading 'ROW_WAIT|FILE#:OBJ#:BLOCK#:ROW#'
col logon_time for a12
col status for a10  heading 'STATUS|STATE'
col command for a3
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col inst_id for 9 heading 'I'
col EXEC_TIME for a5 heading 'RUN|TIME'
col client for a32 heading 'CLIENT|OSUSER_MACHINE_PRO'
COL CON_ID                  heading "C"                  for a1
COL OBJECT_INFO             heading "OBJECT|OWNER:NAME:DBLINK:TYPE"     heading A60
COL lock_type               heading "LOCK:MODE:REQ"                     heading A5

define _VERSION_11  = "--"
define _VERSION_10  = "--"
define _CLIENT_MODE = "  "
define _LONG_MODE   = "--"
define _VERSION_12  = "--"
col version12  noprint new_value _VERSION_12
col version11  noprint new_value _VERSION_11
col version10  noprint new_value _VERSION_10
SELECT /*+ no_parallel */
      CASE
          WHEN     SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) >= '10.2'
               AND SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) < '11.2'
          THEN
             '  '
          ELSE
             '--'
       END
          version10,
       CASE
          WHEN     SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) >= '11.2'
               AND SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) < '12.2'
          THEN
             '  '
          ELSE
             '--'
       END
          version11,
       CASE
          WHEN SUBSTR (
                  banner,
                  INSTR (banner, 'Release ') + 8,
                  INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                         ' ')) >= '12.1'
          THEN
             '  '
          ELSE
             '--'
       END
          version12
  FROM v$version
 WHERE banner LIKE 'Oracle Database%';


break on inst_id on con_id
/* Formatted on 2016/12/29 16:07:13 (QP5 v5.256.13226.35510) */
  SELECT /*+ noparallel */
        SUBSTR (
            DECODE (
               b.STATE,
               'WAITING', b.EVENT,
               DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event),
            1,
            18)
            event,
         SUBSTR (b.program, 1, 22) program,
            b.username
         || '|'
         || CASE
               WHEN b.last_call_et < 1000
               THEN
                  b.last_call_et || ''
               WHEN b.last_call_et BETWEEN 1000 AND 10000
               THEN
                  SUBSTR (b.last_call_et / 1000, 1, 3) || 'K'
               WHEN b.last_call_et > 10000
               THEN
                  SUBSTR (b.last_call_et / 10000, 1, 3) || 'W'
            END
         || '|'
         || CASE
               WHEN b.seq# < 1000
               THEN
                  b.seq# || ''
               WHEN b.seq# BETWEEN 1000 AND 10000
               THEN
                  SUBSTR (b.seq# / 1000, 1, 3) || 'K'
               WHEN b.seq# > 10000
               THEN
                  SUBSTR (b.seq# / 10000, 1, 3) || 'W'
            END
            u_s,
         b.sid || ':' || b.serial# os_sess,
&_VERSION_10         SUBSTR (
&_VERSION_10               DECODE (b.status,
&_VERSION_10                       'ACTIVE', 'A',
&_VERSION_10                       'INACTIVE', 'I',
&_VERSION_10                       'KILLED', 'K',
&_VERSION_10                       'CACHED', 'C',
&_VERSION_10                       'SNIPED', 'S')
&_VERSION_10            || '|'
&_VERSION_10            || DECODE (
&_VERSION_10                  b.state,
&_VERSION_10                  'WAITING',    'W'
&_VERSION_10                             || '|'
&_VERSION_10                             || CASE
&_VERSION_10                                   WHEN b.SECONDS_IN_WAIT < 1000
&_VERSION_10                                   THEN
&_VERSION_10                                      b.SECONDS_IN_WAIT || ''
&_VERSION_10                                   WHEN b.SECONDS_IN_WAIT BETWEEN 1000
&_VERSION_10                                                              AND 10000
&_VERSION_10                                   THEN
&_VERSION_10                                         SUBSTR (b.SECONDS_IN_WAIT / 1000,
&_VERSION_10                                                 1,
&_VERSION_10                                                 3)
&_VERSION_10                                      || 'K'
&_VERSION_10                                   WHEN b.SECONDS_IN_WAIT > 10000
&_VERSION_10                                   THEN
&_VERSION_10                                         SUBSTR (b.SECONDS_IN_WAIT / 10000,
&_VERSION_10                                                 1,
&_VERSION_10                                                 3)
&_VERSION_10                                      || 'W'
&_VERSION_10                                END,
&_VERSION_10                  'WAITED UNKNOWN TIME', 'U',
&_VERSION_10                  'WAITED SHORT TIME', 'S',
&_VERSION_10                  'WAITED KNOWN TIME',    'N'
&_VERSION_10                                       || '|'
&_VERSION_10                                       || CASE
&_VERSION_10                                             WHEN b.WAIT_TIME > 0
&_VERSION_10                                             THEN
&_VERSION_10                                                CASE
&_VERSION_10                                                   WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                         - TRUNC (
&_VERSION_10                                                              b.WAIT_TIME / 100)) <
&_VERSION_10                                                           1000
&_VERSION_10                                                   THEN
&_VERSION_10                                                         (  b.SECONDS_IN_WAIT
&_VERSION_10                                                          - TRUNC (
&_VERSION_10                                                                 b.WAIT_TIME
&_VERSION_10                                                               / 100))
&_VERSION_10                                                      || ''
&_VERSION_10                                                   WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                         - TRUNC (
&_VERSION_10                                                              b.WAIT_TIME / 100)) BETWEEN 1000
&_VERSION_10                                                                                      AND 10000
&_VERSION_10                                                   THEN
&_VERSION_10                                                         SUBSTR (
&_VERSION_10                                                              (  b.SECONDS_IN_WAIT
&_VERSION_10                                                               - TRUNC (
&_VERSION_10                                                                      b.WAIT_TIME
&_VERSION_10                                                                    / 100))
&_VERSION_10                                                            / 1000,
&_VERSION_10                                                            1,
&_VERSION_10                                                            3)
&_VERSION_10                                                      || 'K'
&_VERSION_10                                                   WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                         - TRUNC (
&_VERSION_10                                                              b.WAIT_TIME / 100)) >
&_VERSION_10                                                           10000
&_VERSION_10                                                   THEN
&_VERSION_10                                                         SUBSTR (
&_VERSION_10                                                              (  b.SECONDS_IN_WAIT
&_VERSION_10                                                               - TRUNC (
&_VERSION_10                                                                      b.WAIT_TIME
&_VERSION_10                                                                    / 100))
&_VERSION_10                                                            / 10000,
&_VERSION_10                                                            1,
&_VERSION_10                                                            3)
&_VERSION_10                                                      || 'W'
&_VERSION_10                                                END
&_VERSION_10                                          END),
&_VERSION_10            1,
&_VERSION_10            10)
&_VERSION_10            status,
&_VERSION_11         SUBSTR (
&_VERSION_11               DECODE (b.status,
&_VERSION_11                       'ACTIVE', 'A',
&_VERSION_11                       'INACTIVE', 'I',
&_VERSION_11                       'KILLED', 'K',
&_VERSION_11                       'CACHED', 'C',
&_VERSION_11                       'SNIPED', 'S')
&_VERSION_11            || '.'
&_VERSION_11            || DECODE (
&_VERSION_11                  b.state,
&_VERSION_11                  'WAITING',    'W'
&_VERSION_11                             || '.'
&_VERSION_11                             || TRUNC (b.wait_time_micro / 1000)
&_VERSION_11                             || 'MS',
&_VERSION_11                  CASE
&_VERSION_11                     WHEN b.wait_time_micro < 1000000
&_VERSION_11                     THEN
&_VERSION_11                        TRUNC (b.wait_time_micro / 1000) || 'MS'
&_VERSION_11                     WHEN b.wait_time_micro BETWEEN 1000000 AND 100000000
&_VERSION_11                     THEN
&_VERSION_11                        SUBSTR (b.wait_time_micro / 1000000, 1, 3) || 'S'
&_VERSION_11                     WHEN b.wait_time_micro BETWEEN 100000000 AND 100000000000
&_VERSION_11                     THEN
&_VERSION_11                        SUBSTR (b.wait_time_micro / 1000000000, 1, 3) || 'KS'
&_VERSION_11                     WHEN b.wait_time_micro > 100000000000
&_VERSION_11                     THEN
&_VERSION_11                           SUBSTR (b.wait_time_micro / 1000000 / 3600, 1, 4)
&_VERSION_11                        || 'H'
&_VERSION_11                  END, 'WAITED UNKNOWN TIME',
&_VERSION_11                     'U'
&_VERSION_11                  || '.'
&_VERSION_11                  || TRUNC (b.TIME_SINCE_LAST_WAIT_MICRO / 1000)
&_VERSION_11                  || 'MS', 'WAITED SHORT TIME',
&_VERSION_11                     'S'
&_VERSION_11                  || '.'
&_VERSION_11                  || TRUNC (b.TIME_SINCE_LAST_WAIT_MICRO / 1000)
&_VERSION_11                  || 'MS', 'WAITED KNOWN TIME',
&_VERSION_11                     'N'
&_VERSION_11                  || '.'
&_VERSION_11                  || TRUNC (b.TIME_SINCE_LAST_WAIT_MICRO / 1000)
&_VERSION_11                  || 'MS'),
&_VERSION_11            1,
&_VERSION_11            10)
&_VERSION_11            status,
         SUBSTR (a.name, 1, 3) command,
            DECODE (b.sql_id,
                    '0', 'P.' || b.prev_sql_id,
                    '', 'P.' || b.prev_sql_id,
                    'C.' || b.sql_id)
         || ':'
         || sql_child_number
            sql_id,
&_VERSION_10            b.BLOCKING_SESSION_STATUS
&_VERSION_10         || ':'
&_VERSION_10         || b.BLOCKING_INSTANCE
&_VERSION_10         || ':'
&_VERSION_10         || b.BLOCKING_SESSION
&_VERSION_10            block_s,
&_VERSION_11         DECODE (
&_VERSION_11            FINAL_BLOCKING_SESSION_STATUS,
&_VERSION_11            'VALID',    'F.'
&_VERSION_11                     || FINAL_BLOCKING_INSTANCE
&_VERSION_11                     || '.'
&_VERSION_11                     || FINAL_BLOCKING_SESSION,
&_VERSION_11            DECODE (BLOCKING_SESSION_STATUS,
&_VERSION_11                    'VALID', BLOCKING_INSTANCE || '.' || BLOCKING_SESSION))
&_VERSION_11            block_s,
&_VERSION_11         CASE
&_VERSION_11            WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                  * 24
&_VERSION_11                  * 3600 < 1000)
&_VERSION_11            THEN
&_VERSION_11                  SUBSTR (
&_VERSION_11                     (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                      * 24
&_VERSION_11                      * 3600),
&_VERSION_11                     1,
&_VERSION_11                     4)
&_VERSION_11               || ''
&_VERSION_11            WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                  * 24
&_VERSION_11                  * 3600) BETWEEN 1000
&_VERSION_11                              AND 10000
&_VERSION_11            THEN
&_VERSION_11                  (SUBSTR (
&_VERSION_11                        (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                      * 24
&_VERSION_11                      * 3600
&_VERSION_11                      / 1000,
&_VERSION_11                      1,
&_VERSION_11                      4))
&_VERSION_11               || 'K'
&_VERSION_11            WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                  * 24
&_VERSION_11                  * 3600) > 10000
&_VERSION_11            THEN
&_VERSION_11                  (SUBSTR (
&_VERSION_11                        (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                      * 24
&_VERSION_11                      * 3600
&_VERSION_11                      / 10000,
&_VERSION_11                      1,
&_VERSION_11                      4))
&_VERSION_11               || 'W'
&_VERSION_11         END
&_VERSION_11            exec_time,
         c.kgllkhdl,
         c.kgllkmod || '.' || c.kgllkreq lock_type,
            d.kglnaown
         || '.'
         || d.kglnaobj
         || '.'
         || d.kglnadlk
         || '.'
         || d.kglobtyd
            object_info
    FROM v$session b,
         sys.audit_actions a,
         dba_kgllock c,
         x$kglob d
   WHERE     a.action = b.command
         AND b.event NOT IN ('class slave wait')
         AND b.saddr = c.kgllkuse
         AND c.kgllkmod <> 0
         AND d.kglhdadr = c.kgllkhdl
         AND c.kgllkhdl IN (SELECT p1raw
                              FROM v$session_wait
                             WHERE event LIKE 'library%')
ORDER BY b.sql_id
/