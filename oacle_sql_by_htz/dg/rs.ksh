#!/bin/ksh
if [ $# -eq 0 ]; then
  $0 30        # Run every 30 secs
elif [ $# -ne 1 ]; then
  echo "Usage: $0 <interval>"
  exit 1
fi
#
run_interval=$1
#
while [ 1 ]; do
sqlplus -s '/ as sysdba' << eof >> redoSize_`uname -n`_${ORACLE_SID}.out
set linesize 150 pagesize 2000
col value format 9999999999999999 
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time", value
 from v\$sysstat
 where name = 'redo size'
/
eof
sleep ${run_interval}
done
