set echo off
store set sqlplusset replace
set pages 1000
set lines 270;
col sess   for a20 heading 'sess:serial|os process';
col u_s for a20 heading 'USERNAME|STATUS'
col p1raw for a8
col client for a25;
col osuser for a10;
col program for a30;
col command for a20;
set verify off
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col seq# for 999999999 heading 'seq#'

SELECT 'HOLDING',
       substr(d.kglpnhdl, -8, 8) p1raw,
       a.sid || ':' || a.serial# || ':' || c.spid AS sess,
       a.username || ':' || a.status u_s,
       a.seq#,
       SUBSTR(a.program, 1, 25) program,
       substr(a.osuser || '@' || a.machine || '@' || a.process, 1, 24) AS client,
       a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
       a.BLOCKING_SESSION block_s,
       DECODE(a.sql_id, '0', a.prev_sql_id, a.sql_id) || ':' ||
       sql_child_number sql_id,
       b.name AS command,
       TO_CHAR(a.logon_time, 'mm-dd hh24:mi') AS logon_time
  FROM v$session a, audit_actions b, v$process c, x$kglpn d
 WHERE a.command = b.action
   AND a.paddr = c.addr(+)
   and a.saddr = d.kglpnuse
   AND d.kglpnmod <> 0
   AND d.kglpnhdl IN (SELECT substr(p1raw, -8, 8)
                        FROM v$session_wait
                       WHERE event LIKE 'library%')
union all
SELECT 'BLOCKING',
       substr(a.p1raw, -8, 8) p1raw,
       a.sid || ':' || a.serial# || ':' || c.spid AS sess,
       a.username || ':' || a.status u_s,
       a.seq#,
       SUBSTR(a.program, 1, 25) program,
       substr(a.osuser || '@' || a.machine || '@' || a.process, 1, 24) AS client,
       a.BLOCKING_SESSION_STATUS || ':' || a.BLOCKING_INSTANCE || ':' ||
       a.BLOCKING_SESSION block_s,
       DECODE(a.sql_id, '0', a.prev_sql_id, a.sql_id) || ':' ||
       sql_child_number sql_id,
       b.name AS command,
       TO_CHAR(a.logon_time, 'mm-dd hh24:mi') AS logon_time
  FROM v$session a, audit_actions b, v$process c
 WHERE a.command = b.action
   AND a.paddr = c.addr
   AND a.event like 'library%'
 order by 2, 1 desc
/
clear    breaks  
@sqlplusset

