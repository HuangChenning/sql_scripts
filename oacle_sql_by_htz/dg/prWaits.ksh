#!/bin/ksh
#
# prWaits.ksh gathers wait event data for the MRP (managed recovery process) and PR0n (parallel recovery slaves).
# The output is written to one file in the following format: <viewname>_<hostname>_<SID>.
# By default the view data is sampled every 15 seconds.
#
if [ $# -eq 0 ]; then
  $0 5        # Run every 5 secs
elif [ $# -ne 1 ]; then
  echo "Usage: $0 <interval>"
  exit 1
fi
#
run_interval=$1
#
while [ 1 ]; do
sqlplus -s '/ as sysdba' << eof >> prWaits_`uname -n`_${ORACLE_SID}
set lines 200 pages 2000
col process format a8
col spid format a8
col event format a50 tru
col SIW format 999999
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Current time"
       ,s.process
       , p.spid
       , substr(s.program, -6) PROC
       , s.event
       , s.p1
       , s.p2
       , s.p3
       , s.seconds_in_wait SIW
       , s.seq#
from v\$session s, v\$process p
where p.addr = s.paddr and (s.program like '%MRP%' or s.program like '%PR0%' or s.program like '%DBW%' or s.program like '%CKPT%')
order by s.process
/
eof
sleep ${run_interval}
done
