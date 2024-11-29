col spid FOR 9999999
col USED_MB FOR 9999
col USED_UREC FOR 99999999
col SID FOR a10
col program FOR a20
col machine FOR a20
col username FOR a8
col sql_hash_value FOR 999999999999
col event FOR a25
col status FOR a6
col p1 FOR 999999
col p2 FOR 9999999
set pagesize 999 linesize 170
SELECT '! kill -9 '||P.SPID,
        T.USED_UBLK / 128 USED_MB,
        T.USED_UREC,
        S.SID || ',' || S.SERIAL# SID,
        SUBSTR(S.STATUS, 1, 6) STATUS,
        substr(S.PROGRAM,1,20) program,
        substr(S.MACHINE,1,20) machine,
        substr(S.USERNAME,1,8) username ,
        S.SQL_HASH_VALUE,
        substr(W.EVENT,1,25) event
   FROM V$SESSION S, V$SESSION_WAIT W, V$TRANSACTION T, V$PROCESS P
  WHERE S.SID = W.SID
    AND S.PADDR = P.ADDR(+)
    AND S.SADDR = T.SES_ADDR(+)  
    and s.program like 'rman%' 
    AND S.USERNAME IS NOT NULL
 /
