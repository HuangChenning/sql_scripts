set echo off
set heading on pages 1000 lines 300
col spid FOR 9999999
col USED_MB FOR 9999
col USED_UREC FOR 99999999
col SID FOR a15
col program FOR a20
col machine FOR a20
col username FOR a8
col sql_id for a19
col event FOR a25
col kill_spid for a30
col status FOR a6
col p1 FOR 999999
col p2 FOR 9999999
col last_call_et for 99999999999999

SELECT 'kill -9 '||P.SPID kill_spid,
       T.USED_UBLK / 128 USED_MB,
       T.USED_UREC,
       S.SID || ',' || S.SERIAL# SID,
       SUBSTR(S.STATUS, 1, 6) STATUS,
       substr(S.PROGRAM,1,20) program,
       substr(S.MACHINE,1,20) machine,
       substr(S.USERNAME,1,8) username ,
       DECODE(s.sql_id, '0', s.prev_sql_id, '',s.prev_sql_id,s.sql_id) || ':' ||sql_child_number sql_id,
       substr(W.EVENT,1,25) event,
       s.LAST_CALL_ET
  FROM V$SESSION S, V$SESSION_WAIT W, V$TRANSACTION T, V$PROCESS P
 WHERE S.SID = W.SID
   AND S.PADDR = P.ADDR(+)
   AND S.SADDR = T.SES_ADDR(+)
   AND S.USERNAME IS NOT NULL
   AND s.status='INACTIVE'    
   AND s.username<>'SYS' and s.username <>'SYSTEM'
   and s.LAST_CALL_ET > nvl('&time_s',7200) 
  order by LAST_CALL_ET
/
undefine time;