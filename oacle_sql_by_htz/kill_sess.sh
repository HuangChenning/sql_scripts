#!/bin/sh
limit_1=$1;
runsql(){
sqlplus -s "/ as sysdba"<<EOF
SET FEEDBACK OFF;
SET TERM OFF;
SET ECHO OFF;
SET pages 0;
set verify off;
set heading off time off timing off;
$1
exit
EOF
}
runsql "set heading on
col spid FOR 9999999
col USED_MB FOR 9999
col USED_UREC FOR 99999999
col SID FOR a15
col program FOR a20
col machine FOR a20
col username FOR a8
col sql_hash_value FOR 999999999999
col event FOR a25
col status FOR a6
col p1 FOR 999999
col p2 FOR 9999999
col kill_spid for a20
col last_call_et for 999999999999
set pagesize 50000 linesize 170


SELECT 'kill -9 '||P.SPID kill_spid,
       T.USED_UBLK / 128 USED_MB,
       T.USED_UREC,
       S.SID || ',' || S.SERIAL# SID,
       SUBSTR(S.STATUS, 1, 6) STATUS,
       substr(S.PROGRAM,1,20) program,
       substr(S.MACHINE,1,20) machine,
       substr(S.USERNAME,1,8) username ,
       S.SQL_HASH_VALUE,
       substr(W.EVENT,1,25) event,
       last_call_et
  FROM V\$SESSION S, V\$SESSION_WAIT W, V\$TRANSACTION T, V\$PROCESS P
 WHERE S.SID = W.SID
   AND S.PADDR = P.ADDR(+)
   AND S.SADDR = T.SES_ADDR(+)   
   AND s.username<>'SYS' and s.username <>'SYSTEM'
   AND S.USERNAME IS NOT NULL
   AND ${limit_1}
   order by s.last_call_et
/"

list=`runsql "SELECT P.SPID    FROM V\\$SESSION S, V\\$SESSION_WAIT W, V\\$TRANSACTION T, V\\$PROCESS P  WHERE S.SID = W.SID   AND S.PADDR = P.ADDR(+)   AND S.SADDR = T.SES_ADDR(+)      AND s.username<>'SYS' and s.username <>'SYSTEM'   AND S.USERNAME IS NOT NULL  AND ${limit_1}  order by s.last_call_et;
"`

echo -n "Are you kill display session?"
read ANS
case $ANS in
    y|Y|yes|Yes)
        kill -9  $list
        ;;
    n|N|no|No)
       exit
       ;;
esac