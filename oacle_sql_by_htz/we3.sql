SET ECHO OFF
SET PAGESIZE 2000  
SET LINESIZE 200
SET HEADING ON
COL event FORMAT a25
COL program FORMAT a23
COL os_sess FOR a25 heading 'SESS_SERIAL|OSPID'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
COL client FOR a31
col sql_id for a18
COL row_wait  for a22 heading 'ROW_WAIT|FILE#:OBJ#:BLOCK#:ROW#'
col logon_time for a12
col status for a6  heading 'STATUS|STATE'
col command for a15
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col inst_id for 9 heading 'I'
break on inst_id
SELECT b.inst_id,
       SUBSTR(DECODE(b.STATE,
                     'WAITING',
                     b.EVENT,
                     DECODE(TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:')) ||
              b.event,
              1,
              25) event,
       SUBSTR(b.program, 1, 22) program,
       b.username || ':' || last_call_et || ':' || b.seq# u_s,
       b.sid || ':' || b.serial# || ':' || c.spid os_sess,
       --      substr(b.status || ':' || b.state, 1, 19) status,
       decode(b.status,
              'ACTIVE',
              'A',
              'INACTIVE',
              'I',
              'KILLED',
              'K',
              'CACHED',
              'C',
              'SNIPED',
              'S') || '.' || decode(b.state,
                                    'WAITING',
                                    'W',
                                    'WAITED UNKNOWN TIME',
                                    'U',
                                    'WAITED SHORT TIME',
                                    'S',
                                    'WAITED KNOWN TIME',
                                    'N') status,
       a.name command,
       DECODE(b.sql_id, '0', b.prev_sql_id, '', b.prev_sql_id, b.sql_id) || ':' ||
       sql_child_number sql_id,
       b.BLOCKING_SESSION_STATUS || ':' || b.BLOCKING_INSTANCE || ':' ||
       b.BLOCKING_SESSION block_s,
       row_wait_file# || ':' || row_wait_obj# || ':' || row_wait_block# || ':' ||
       row_wait_row# row_wait
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
   
SELECT b.inst_id,
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id) sql_id,
         a.name command,
         COUNT (*)
    FROM gv$session b, sys.audit_actions a
   WHERE username IS NOT NULL AND status = 'ACTIVE' AND a.action = b.command
GROUP BY inst_id, DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id), a.name
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
         DECODE (b.sql_id, '0', b.prev_sql_id, b.sql_id)
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
                 DECODE (TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || b.event)
ORDER BY 1, 3 DESC;

 
clear    breaks