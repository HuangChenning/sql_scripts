set pages 1000
set lines 200;
col sess   for a20 heading 'sess:serial|os process';
col username for a15;
col client for a25 heading 'osuser:machine:process';
col osuser for a10;
col program for a30;
col command for a20;
set verify off
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col u_s_l for a45 heading 'USERNAME.STATUS|LAST_elapsed_time.SEQ#'
col value for 99999999999 heading 'CALLS_TO|KCMGAS'
/* Formatted on 2013/6/27 15:10:27 (QP5 v5.240.12305.39476) */
  SELECT /*+ rule */a.sid || ',' || a.serial# || '.' || c.spid AS sess,
         stat.VALUE,
            a.username
         || '.'
         || a.status
         || '.'
         || a.LAST_CALL_ET
         || '.'
         || a.seq#
            u_s_l,
         SUBSTR (a.program, 1, 25) program,
         SUBSTR (a.osuser || '@' || a.machine || '@' || a.process, 1, 24)
            AS client,
            a.BLOCKING_SESSION_STATUS
         || ':'
         || a.BLOCKING_INSTANCE
         || ':'
         || a.BLOCKING_SESSION
            block_s,
            DECODE (a.sql_id, '0', a.prev_sql_id, a.sql_id)
         || ':'
         || sql_child_number
            sql_id,
         b.name AS command
    FROM v$session a,
         audit_actions b,
         v$process c,
         v$sesstat stat
   WHERE     a.command = b.action(+)
         AND a.paddr = c.addr(+)
         AND stat.sid = a.sid
         AND statistic# = (SELECT statistic#
                             FROM v$sysstat
                            WHERE name = 'calls to kcmgas')
         AND stat.VALUE > 0
ORDER BY VALUE
/