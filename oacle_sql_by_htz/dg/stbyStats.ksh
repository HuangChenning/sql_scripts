#!/bin/ksh
if [ $# -eq 0 ]; then
  $0 15        # Run every 15 secs
elif [ $# -ne 1 ]; then
  echo "Usage: $0 <interval>"
  exit 1
fi
#
run_interval=$1
#
while [ 1 ]; do
sqlplus -s '/ as sysdba' << eof >> recoveryData_`uname -n`_${ORACLE_SID}.out
set linesize 200 pagesize 2000
col units format a20
col comments format a15
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , ITEM
     , SOFAR 
     , TOTAL
     , UNITS 
     , to_char(TIMESTAMP,'DD-MON-YYYY HH24:MI:SS') "Timestamp"
 from v\$recovery_progress
 where total = 0
/
col name format a30
col value format a18
col unit format a35
col time_computed format a22
select
       NAME 
     , VALUE
     , UNIT
     , DATUM_TIME
     , TIME_COMPUTED
 from v\$dataguard_stats
 order by time_computed
/
col inst_id format 99
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , INST_ID
     , PROCESS
     , PID
     , CLIENT_PROCESS
     , STATUS
     , THREAD#
     , SEQUENCE#
     , BLOCK#
     , BLOCKS
 from gv\$managed_standby
 order by inst_id 
/
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , GROUP#
     , THREAD#
     , SEQUENCE#
     , USED
 from v\$standby_log
 where STATUS = 'ACTIVE'
/
eof
sleep ${run_interval} 
done
