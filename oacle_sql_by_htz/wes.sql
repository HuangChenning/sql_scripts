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

define _VERSION_11  = "--"
define _VERSION_10  = "--"
define _LONG_MODE   = "  "

col version11  noprint new_value _VERSION_11
col version10  noprint new_value _VERSION_10

select case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '10.2' and
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '11.2' then
          '  '
         else
          '--'
       end  version10,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '11.2' then
          '  '
         else
          '--'
       end  version11
  from v$version
 where banner like 'Oracle Database%';


break on inst_id
SELECT /*+ noparallel */b.inst_id,
       SUBSTR(DECODE(b.STATE,
                     'WAITING',
                     b.EVENT,
                     DECODE(TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') ||b.event),
              1,
              18) event,
       SUBSTR(b.program, 1, 22) program,
       b.username || ':' || last_call_et || ':' || b.seq# u_s,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
--      substr(b.status || ':' || b.state, 1, 19) status,
&_VERSION_10       substr(decode(b.status,
&_VERSION_10              'ACTIVE',
&_VERSION_10              'A',
&_VERSION_10              'INACTIVE',
&_VERSION_10              'I',
&_VERSION_10              'KILLED',
&_VERSION_10              'K',
&_VERSION_10              'CACHED',
&_VERSION_10              'C',
&_VERSION_10              'SNIPED',
&_VERSION_10              'S') || '.' || decode(b.state,
&_VERSION_10                                    'WAITING',
&_VERSION_10                                    'W' || '.' || b.SECONDS_IN_WAIT || 'S',
&_VERSION_10                                    'WAITED UNKNOWN TIME',
&_VERSION_10                                    'U',
&_VERSION_10                                    'WAITED SHORT TIME',
&_VERSION_10                                    'S',
&_VERSION_10                                    'WAITED KNOWN TIME',
&_VERSION_10                                    'N'),1,10) status,
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
&_VERSION_11              'W' || '.' || trunc(b.wait_time_micro / 1000) || 'MS',
&_VERSION_11              'WAITED UNKNOWN TIME',
&_VERSION_11              'U' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS',
&_VERSION_11              'WAITED SHORT TIME',
&_VERSION_11              'S' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS',
&_VERSION_11              'WAITED KNOWN TIME',
&_VERSION_11              'N' || '.' || trunc(b.TIME_SINCE_LAST_WAIT_MICRO / 1000) || 'MS'),1,10) status, 
                   substr(a.name,1,3) command,
                   DECODE(b.sql_id, '0', 'P.'||b.prev_sql_id, '', 'P.'||b.prev_sql_id, 'C.'||b.sql_id) || ':' || sql_child_number sql_id,
&_VERSION_10       b.BLOCKING_SESSION_STATUS || ':' || b.BLOCKING_INSTANCE || ':' ||b.BLOCKING_SESSION block_s
&_VERSION_11       decode(FINAL_BLOCKING_SESSION_STATUS,
&_VERSION_11             'VALID',
&_VERSION_11              'F.'||FINAL_BLOCKING_INSTANCE || '.' || FINAL_BLOCKING_SESSION,
&_VERSION_11              decode(BLOCKING_SESSION_STATUS,
&_VERSION_11                     'VALID',
&_VERSION_11                     BLOCKING_INSTANCE || '.' || BLOCKING_SESSION)) block_s
&_LONG_MODE                  ,
&_LONG_MODE   &_VERSION_11   substr(((sysdate - nvl(b.SQL_EXEC_START, b.PREV_EXEC_START)) * 24 * 3600),1,4)  EXEC_TIME
&_LONG_MODE   &_VERSION_11    ,
&_LONG_MODE       row_wait_obj# || ':' ||row_wait_file# || ':' ||  row_wait_block# || ':' ||
&_LONG_MODE       row_wait_row# row_wait
  FROM gv$session b, gv$process c, gv$session_wait s, sys.audit_actions a
 WHERE b.paddr = c.addr
   AND s.SID = b.SID
   and b.inst_id = c.inst_id
   and c.inst_id = s.inst_id
   and a.action = b.command
   and b.status = 'ACTIVE'
   and b.username is not null
 order by inst_id, sql_id 
/


col program for a30
col username for a15

SELECT b.inst_id, substr(b.program, 1, 30) program, b.username, COUNT(*)
  FROM gv$session b
 WHERE username IS NOT NULL
   AND status = 'ACTIVE'
 GROUP BY b.inst_id, substr(b.program, 1, 30), b.username having count(*)>1
 ORDER BY inst_id, program, 4 desc;

col machine for a20
SELECT b.inst_id, b.machine, count(*)
  FROM gv$session b
 WHERE username IS NOT NULL
   AND status = 'ACTIVE'
 GROUP BY b.inst_id, b.machine having count(*)>1
 ORDER BY inst_id, 2 DESC;


col command for a20
COL event FORMAT a25
   
SELECT b.inst_id,
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) sql_id,
         a.name command,
         COUNT (*)
    FROM gv$session b, sys.audit_actions a
   WHERE username IS NOT NULL AND status = 'ACTIVE' AND a.action = b.command
GROUP BY inst_id, DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id), a.name having count(*)>1
ORDER BY inst_id, 4 DESC;



col event for a40

SELECT b.inst_id,
         DECODE (b.STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event)
            EVENT,
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) sql_id,
         COUNT (*)
    FROM gv$session b
   WHERE b.status = 'ACTIVE' AND b.username IS NOT NULL
GROUP BY inst_id,
         DECODE (b.STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event),
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) having count(*)>1
ORDER BY inst_id ,4;



SELECT inst_id,
         DECODE (STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event) event,
         COUNT (*)
    FROM gv$session b
   WHERE username IS NOT NULL AND status = 'ACTIVE'
GROUP BY inst_id,
         DECODE (STATE,
                 'WAITING', EVENT,
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event) having count(*)>1
ORDER BY 1, 3 DESC;

 
clear    breaks