#!/bin/ksh
#########################################################################
# Script displays total memory usage for oracle instance running under AIX
#
# Usage: omem.sh <oracle sid>
#
# Prerequisites:
#   1) Database instance needs to run (duh...)
#   2) svmon -P needs to be available
#
# Maxym Kharchenko 2010
########################################################################## 

(( 0 == $# )) && set -- $ORACLE_SID

ORACLE_SID=$1

if [[ 'AIX' != $(uname) ]]
then
  echo "Sorry, script can only run on AIX"
  exit -1
fi

SMON_PID=$(ps -fu oracle | fgrep "ora_smon_${ORACLE_SID} " | grep -v grep | awk '{print $2}')

if [[ ! -n $SMON_PID ]]
then
   echo "Database $ORACLE_SID is NOT running"
   exit -1
fi

# Shared segments
svmon -P $SMON_PID | grep shmat | 
  awk '{if($6 == "s" || $6 == "sm") {page_size=4} 
        else if ($6 == "m") {page_size=64} 
        else if ($6 == "L") {page_size=16*1024} 
        else {page_size = -1}; rss += $7; virt += $10; c++} 
       END {print int(rss*page_size/1024), int(virt*page_size/1024), c}' | read s_r s_v s_c

if (( 0 == $s_r ))
then
  echo "svmon did NOT produce any results. perhaps, you need to run the script as root?"
  exit -2
fi

# Processes
ps vgw | egrep " oracle${ORACLE_SID} | ora_.*_${ORACLE_SID} " | grep -v egrep | 
  awk '{rss += ($7-$10); virt+= $6; code=$10; c++ } END {print int((rss+code)/1024), int(virt/1024), c}' | read p_r p_v p_c

(( t_r = $s_r + $p_r ))
(( t_v = $s_v + $p_v ))

echo =============================================================================
echo Memory used by ORACLE instance: $ORACLE_SID
echo =============================================================================
echo
echo "SGA:"
echo "In Memory (RSS):     $s_r Mb"
echo "Requested (Virtual): $s_v Mb"
echo "Segments:            $s_c"
echo
echo "Processes:"
echo "In Memory (RSS):     $p_r Mb"
echo "Requested (Virtual): $p_v Mb"
echo "Processes:           $p_c"
echo
echo "Total: "
echo "In Memory (RSS):     $t_r Mb"
echo "Requested (Virtual): $t_v Mb"
