-- File Name : we.sql
-- Purpose : 显示活动回话的统计信息
-- 支持 10g,11g,12c
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 最原始版本是基于原OLM的脚本修改
-- 20161103 添加12C版本的支持
-- 20161109 添加10G版本,state为WAITED KNOWN TIME时,等待消耗的时间
-- 20170314 去掉audit_actions，支持在MOUNT阶段执行

SET ECHO OFF
SET PAGESIZE 2000  LINESIZE 250 VERIFY OFF HEADING ON
COL event FORMAT a18
COL program FORMAT a23
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
COL client FOR a31
col sql_id for a18
COL row_wait  for a22 heading 'ROW_WAIT|FILE#:OBJ#:BLOCK#:ROW#'
col logon_time for a12
col status for a10  heading 'STATUS|STATE'
col command for 999
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col inst_id for 9 heading 'I'
col EXEC_TIME for a5 heading 'RUN|TIME'
col client for a32 heading 'CLIENT|OSUSER_MACHINE_PRO'
COL CON_ID                  heading "C"                  for a1

define _VERSION_11  = "--"
define _VERSION_10  = "--"
define _CLIENT_MODE = "  "
define _LONG_MODE   = "  "
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
 --              AND SUBSTR (
 --                     banner,
 --                     INSTR (banner, 'Release ') + 8,
 --                     INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
 --                            ' ')) < '13.1'
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
SELECT /*+ noparallel */
       &_VERSION_12 trim(b.CON_ID) con_id,
       SUBSTR(DECODE(b.STATE,
                     'WAITING',
                     b.EVENT,
                     DECODE(TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') ||b.event),
              1,
              18) event,
       SUBSTR(b.program, 1, 22) program,
--       b.username || ':' || last_call_et || ':' || b.seq# u_s
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
                u_s       
       ,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
--      substr(b.status || ':' || b.state, 1, 19) status,
&_VERSION_10      SUBSTR (
&_VERSION_10             DECODE (b.status,
&_VERSION_10                     'ACTIVE', 'A',
&_VERSION_10                     'INACTIVE', 'I',
&_VERSION_10                     'KILLED', 'K',
&_VERSION_10                     'CACHED', 'C',
&_VERSION_10                     'SNIPED', 'S')
&_VERSION_10          || '|'
&_VERSION_10          || DECODE (
&_VERSION_10                b.state,
&_VERSION_10                'WAITING',    'W'
&_VERSION_10                           || '|'
&_VERSION_10                           || CASE
&_VERSION_10                                 WHEN b.SECONDS_IN_WAIT < 1000
&_VERSION_10                                 THEN
&_VERSION_10                                    b.SECONDS_IN_WAIT || ''
&_VERSION_10                                 WHEN b.SECONDS_IN_WAIT BETWEEN 1000
&_VERSION_10                                                            AND 10000
&_VERSION_10                                 THEN
&_VERSION_10                                       SUBSTR (b.SECONDS_IN_WAIT / 1000,
&_VERSION_10                                               1,
&_VERSION_10                                               3)
&_VERSION_10                                    || 'K'
&_VERSION_10                                 WHEN b.SECONDS_IN_WAIT > 10000
&_VERSION_10                                 THEN
&_VERSION_10                                       SUBSTR (b.SECONDS_IN_WAIT / 10000,
&_VERSION_10                                               1,
&_VERSION_10                                               3)
&_VERSION_10                                    || 'W'
&_VERSION_10                              END,
&_VERSION_10                'WAITED UNKNOWN TIME', 'U',
&_VERSION_10                'WAITED SHORT TIME', 'S',
&_VERSION_10                'WAITED KNOWN TIME',    'N'
&_VERSION_10                                     || '|'
&_VERSION_10                                     || CASE
&_VERSION_10                                           WHEN b.WAIT_TIME > 0
&_VERSION_10                                           THEN
&_VERSION_10                                              CASE
&_VERSION_10                                                 WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                       - TRUNC (
&_VERSION_10                                                            b.WAIT_TIME / 100)) <
&_VERSION_10                                                         1000
&_VERSION_10                                                 THEN
&_VERSION_10                                                       (  b.SECONDS_IN_WAIT
&_VERSION_10                                                        - TRUNC (
&_VERSION_10                                                               b.WAIT_TIME
&_VERSION_10                                                             / 100))
&_VERSION_10                                                    || ''
&_VERSION_10                                                 WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                       - TRUNC (
&_VERSION_10                                                            b.WAIT_TIME / 100)) BETWEEN 1000
&_VERSION_10                                                                                    AND 10000
&_VERSION_10                                                 THEN
&_VERSION_10                                                       SUBSTR (
&_VERSION_10                                                            (  b.SECONDS_IN_WAIT
&_VERSION_10                                                             - TRUNC (
&_VERSION_10                                                                    b.WAIT_TIME
&_VERSION_10                                                                  / 100))
&_VERSION_10                                                          / 1000,
&_VERSION_10                                                          1,
&_VERSION_10                                                          3)
&_VERSION_10                                                    || 'K'
&_VERSION_10                                                 WHEN (  b.SECONDS_IN_WAIT
&_VERSION_10                                                       - TRUNC (
&_VERSION_10                                                            b.WAIT_TIME / 100)) >
&_VERSION_10                                                         10000
&_VERSION_10                                                 THEN
&_VERSION_10                                                       SUBSTR (
&_VERSION_10                                                            (  b.SECONDS_IN_WAIT
&_VERSION_10                                                             - TRUNC (
&_VERSION_10                                                                    b.WAIT_TIME
&_VERSION_10                                                                  / 100))
&_VERSION_10                                                          / 10000,
&_VERSION_10                                                          1,
&_VERSION_10                                                          3)
&_VERSION_10                                                    || 'W'
&_VERSION_10                                              END
&_VERSION_10                                        END),
&_VERSION_10          1,
&_VERSION_10          10)
&_VERSION_10                status,
&_VERSION_11       substr(decode(b.status,
&_VERSION_11              'ACTIVE',
&_VERSION_11              'A',
&_VERSION_11              'INACTIVE',
&_VERSION_11              'I',
&_VERSION_11              'KILLED',
&_VERSION_11              'K',
&_VERSION_11              'CACHED',
&_VERSION_11              'C',
&_VERSION_11              'SNIPED',
&_VERSION_11              'S') || '.' ||
&_VERSION_11       decode(b.state,
&_VERSION_11              'WAITING',
&_VERSION_11              'W' || '.' || 
--trunc(b.wait_time_micro / 1000) || 'MS',
&_VERSION_11      CASE
&_VERSION_11                WHEN b.wait_time_micro < 1000000
&_VERSION_11                THEN
&_VERSION_11                   TRUNC (b.wait_time_micro / 1000) || 'MS'
&_VERSION_11                WHEN b.wait_time_micro BETWEEN 1000000 AND 100000000
&_VERSION_11                THEN
&_VERSION_11                   SUBSTR (b.wait_time_micro / 1000000, 1, 3) || 'S'
&_VERSION_11                WHEN b.wait_time_micro BETWEEN 100000000 AND 100000000000
&_VERSION_11                THEN
&_VERSION_11                   SUBSTR (b.wait_time_micro / 1000000000, 1, 3) || 'KS'
&_VERSION_11                WHEN b.wait_time_micro > 100000000000 
&_VERSION_11                THEN
&_VERSION_11                   SUBSTR (b.wait_time_micro / 1000000 / 3600, 1, 4) || 'H'
&_VERSION_11             END,
&_VERSION_11              'WAITED UNKNOWN TIME',
&_VERSION_11              'U' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS',
&_VERSION_11              'WAITED SHORT TIME',
&_VERSION_11              'S' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS',
&_VERSION_11              'WAITED KNOWN TIME',
&_VERSION_11              'N' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS'),1,10) status, 
                   b.command,
                   DECODE(b.sql_id, '0', 'P.'||b.prev_sql_id, '', 'P.'||b.prev_sql_id, 'C.'||b.sql_id) || ':' || sql_child_number sql_id,
&_VERSION_10       b.BLOCKING_SESSION_STATUS || ':' || b.BLOCKING_INSTANCE || ':' ||b.BLOCKING_SESSION block_s
&_VERSION_11       decode(FINAL_BLOCKING_SESSION_STATUS,
&_VERSION_11             'VALID',
&_VERSION_11              'F.'||FINAL_BLOCKING_INSTANCE || '.' || FINAL_BLOCKING_SESSION,
&_VERSION_11              decode(BLOCKING_SESSION_STATUS,
&_VERSION_11                     'VALID',
&_VERSION_11                     BLOCKING_INSTANCE || '.' || BLOCKING_SESSION)) block_s
&_VERSION_11       ,
-- &_VERSION_11 substr(((sysdate - nvl(b.SQL_EXEC_START, b.PREV_EXEC_START)) * 24 * 3600),1,4)
&_VERSION_11     CASE
&_VERSION_11               WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                     * 24
&_VERSION_11                     * 3600 < 1000)
&_VERSION_11               THEN
&_VERSION_11                     SUBSTR (
&_VERSION_11                        (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                         * 24
&_VERSION_11                         * 3600),
&_VERSION_11                        1,
&_VERSION_11                        4)
&_VERSION_11                  || ''
&_VERSION_11               WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                     * 24
&_VERSION_11                     * 3600) BETWEEN 1000
&_VERSION_11                                 AND 10000
&_VERSION_11               THEN
&_VERSION_11                     (SUBSTR (
&_VERSION_11                           (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                         * 24
&_VERSION_11                         * 3600
&_VERSION_11                         / 1000,
&_VERSION_11                         1,
&_VERSION_11                         4))
&_VERSION_11                  || 'K'
&_VERSION_11                   WHEN (  (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                     * 24
&_VERSION_11                     * 3600) >10000
&_VERSION_11               THEN
&_VERSION_11                     (SUBSTR (
&_VERSION_11                           (SYSDATE - NVL (b.SQL_EXEC_START, b.PREV_EXEC_START))
&_VERSION_11                         * 24
&_VERSION_11                         * 3600
&_VERSION_11                         / 10000,
&_VERSION_11                         1,
&_VERSION_11                         4))
&_VERSION_11                  || 'W' 
&_VERSION_11            END 
&_VERSION_11            EXEC_TIME,
                 substr(replace(b.osuser,'Administrator','admin') || '@' || replace(replace(b.machine,'WORKGROUP\','W:'),'WorkGroup','W:') || '@' || b.process,1,24)||'.'||replace(replace(b.service_name,'SYS$USERS','SYSU'),'SYS$BACKGROUND','SYSB') AS client
&_LONG_MODE        ,
&_LONG_MODE       row_wait_obj# || ':' ||row_wait_file# || ':' ||  row_wait_block# || ':' ||
&_LONG_MODE       row_wait_row# row_wait
  FROM v$session b, v$process c, v$session_wait s
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   and b.status = 'ACTIVE'
   and b.username is not null
&_VERSION_12 and b.con_id=c.con_id and b.con_id=s.con_id
   and b.event not in ('class slave wait')
 order by 
  &_VERSION_12 con_id,
 sql_id 
/

col program for a30
col username for a15

SELECT 
       &_VERSION_12 trim(con_id) con_id,
       substr(b.program, 1, 30) program, b.username, COUNT(*) hcount
  FROM v$session b
 WHERE username IS NOT NULL
   AND status = 'ACTIVE'
   and b.event not in ('class slave wait')
 GROUP BY 
        &_VERSION_12 trim(con_id),
 substr(b.program, 1, 30), b.username
 ORDER BY 
  &_VERSION_12 con_id,
 program, hcount desc;

col machine for a20
SELECT 
   &_VERSION_12 trim(con_id) con_id,
  b.machine, count(*) hcount
  FROM gv$session b
 WHERE username IS NOT NULL
   AND status = 'ACTIVE'
   AND b.event not in ('class slave wait')
 GROUP BY 
 &_VERSION_12 trim(con_id),
 b.machine
 ORDER BY 
 &_VERSION_12 con_id,
 hcount DESC;


col command for 99999
COL event FORMAT a25
   
SELECT 
         &_VERSION_12 trim(con_id) con_id,
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) sql_id,
         b.command command,
         COUNT (*) hcount
    FROM v$session b
   WHERE username IS NOT NULL AND status = 'ACTIVE'
   and b.event not in ('class slave wait')
GROUP BY 
        &_VERSION_12 trim(con_id),
        DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id), b.command
ORDER BY 
        &_VERSION_12 con_id,
        hcount DESC;



col event for a40

SELECT 
         &_VERSION_12 trim(con_id) con_id,
         DECODE (b.STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event)
            EVENT,
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) sql_id,
         COUNT (*) hcount
    FROM v$session b
   WHERE b.status = 'ACTIVE' AND b.username IS NOT NULL
   and b.event not in ('class slave wait')
GROUP BY 
        &_VERSION_12 trim(con_id),
         DECODE (b.STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event),
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id)
ORDER BY 
      &_VERSION_12 con_id,
     hcount;



SELECT 
        &_VERSION_12 trim(con_id) con_id,
         DECODE (STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event) event,
         COUNT (*) hcount
    FROM v$session b
   WHERE username IS NOT NULL AND status = 'ACTIVE'
GROUP BY 
        &_VERSION_12 trim(con_id),
        DECODE (STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event)
ORDER BY 
      &_VERSION_12 con_id,
      hcount DESC;

 
clear    breaks

