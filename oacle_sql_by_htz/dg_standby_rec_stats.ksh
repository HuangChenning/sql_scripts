#!/bin/ksh
#
# RecStats.ksh gathers data from the following V$ views at defined sample intervals:
# - V$SYSTEM_EVENT
# - V$EVENT_HISTOGRAM
# - V$SYSSTAT
# The output is written to 3 files (one per view) in the following format: <viewname>_<hostname>_<SID>.
# By default the view data is sampled every 15 seconds.
#
if [ $# -eq 0 ]; then
  $0 15 # Run every 15 secs
elif [ $# -ne 1 ]; then
  echo "Usage: $0 <interval>"
exit 1
fi
#
run_interval=$1
#
while [ 1 ]; do
sqlplus -s '/ as sysdba' << eof >> system_event_`uname -n`_${ORACLE_SID}
set linesize 250 pagesize 2000 numwidth 25
col event format a60
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , event
     , total_waits
     , total_timeouts
     , time_waited
     , average_wait
  from v\$system_event
 order by time_waited
/
eof
sqlplus -s '/ as sysdba' << eof >> event_histogram_`uname -n`_${ORACLE_SID}
set linesize 250 pagesize 2000 numwidth 25
col event format a60
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , event
     , wait_time_milli
     , wait_count
  from v\$event_histogram
 order by event, wait_time_milli
/
eof
sqlplus -s '/ as sysdba' << eof >> sysstat_`uname -n`_${ORACLE_SID}
set linesize 250 pagesize 2000 numwidth 25
col name format a60
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
     , name
     , value
  from v\$sysstat
/
eof
sleep ${run_interval}
done
