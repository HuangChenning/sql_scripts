#!/bin/ksh
##########################################################################
# Script displays memory statistics for oracle processes running under AIX
#
# This script implements a quick-and-dirty estimation that grabs data 
# only from PS command and makes certain assumptions (i.e. virtual = rss+pgsp)
#
# For better precision, use ora_mem.pl tool that grabs data from SVMON
#
# Usage: omem_proc.sh <oracle sid> <sort mode: inuse|pgsp|virtual>
#
# Prerequisites:
#   1) Database instance needs to run (duh...)
#
# Maxym Kharchenko 2010
##########################################################################

(( 0 == $# )) && set -- $ORACLE_SID 'inuse'

ORACLE_SID=$1
SORT_BY=$2

cat <<EOM

Display Memory Statistics for ORACLE Processes on AIX
Simplified Version that grabs data from PS command
For better precision use ora_mem.pl which grabs data from SVMON

Author: Maxym Kharchenko, 2010

EOM

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

echo "Displaying process memory statistics for ORACLE instance: $ORACLE_SID"

ps vgw | egrep " oracle${ORACLE_SID} | ora_.*_${ORACLE_SID} " | grep -v egrep | 
  awk -v SortBy=$SORT_BY '
  BEGIN {
    print_header();
  }
  
  {
    if (0 in aInUse) {
      ;
    } else {
      aL[0] = sprintf("%10d %10.2f %10.2f %10.2f %-24s", -1, $10/1024, 0, 0, "TEXT SEGMENT");
      aInUse[0] = $10 ":0"; aVirt[0] = "0:0"; aPgSp[0] = "0:0";
    }
    aL[NR] = sprintf("%10d %10.2f %10.2f %10.2f %-24s", $1, ($7-$10)/1024, ($6-$7+$10)/1024, $6/1024, $13);
    aInUse[NR] = ($7-$10) ":" NR; aVirt[NR]=$6 ":" NR; aPgSp[NR]=aVirt[NR]-aInUse[NR] ":" NR;

    nProc++;
  }
  END {
    if("pgsp" == SortBy) {
      for(i in aPgSp)
        aIndex[i] = aPgSp[i];
    } else if ("virtual" == SortBy) {
      for(i in aVirt)
        aIndex[i] = aVirt[i];
    } else {
      for(i in aInUse)
        aIndex[i] = aInUse[i];
    }

    isort(aIndex)
    for(i=0; i <= NR; i++) {
      split(aIndex[i], B, ":")
      print aL[B[2]];
    }

    print_header();
    printf "%10s %10.2f %10.2f %10.2f %-24s\n", "TOTAL:", sum_array(aInUse), sum_array(aPgSp), sum_array(aVirt), "Processes: " nProc;
  }

  function print_header() {
    print "---------- ---------- ---------- ---------- ------------------------"
    print "   PID       InMem      Paging     Virtual          COMMAND"
    print "---------- ---------- ---------- ---------- ------------------------"
  }

  function sum_array(A) {
    nSum = 0;

    for (i in A) {
      split(A[i], B, ":");
      nSum += B[1];
    }

    return nSum/1024;
  }

  # awk insertion sort
  function isort(A) {
    for (i=0; i <= NR; i++) {
      szSave = A[i];
      nSave=sortable(A[i]);
      for(j=i-1; j >= 0 && sortable(A[j]) > nSave; j--) {
        A[j+1] = A[j];
      }
      A[j+1] = szSave;
    }
  }

  function sortable(szVal) {
    split(szVal, A, ":");
    return A[1];
  }
'
