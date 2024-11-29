#!/bin/ksh
#######################################################################
# Script displays allocated shared memory segments
# for ORACLE instance running under AIX
#
# Usage: omem_shared.sh <oracle sid> <sort mode: inuse|pgsp|virtual>
#
# Prerequisites:
#   1) Database instance needs to run (duh...)
#   2) svmon -P needs to be available
#
# Maxym Kharchenko 2010
#######################################################################

(( 0 == $# )) && set -- $ORACLE_SID 'inuse'

ORACLE_SID=$1
SORT_BY=$2

cat << EOM

Display Memory Statistics for ORACLE Shared Segments on AIX
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

echo "Displaying shared memory segments for ORACLE instance: $ORACLE_SID"

svmon -P $SMON_PID 2>/dev/null | grep -i 'text data BSS heap' | read SVMON_AVAILABLE

if [[ -z $SVMON_AVAILABLE ]]
then
  echo "svmon did NOT produce any results. Perhaps, you need to run the script as root?"
  exit -2
fi

ipcs -bmS1 | grep $(svmon -P $SMON_PID | grep shmat | awk '{print $1}' | head -1) | awk '{print $7/(1024*1024)}' | read SGA_REQUESTED_SIZE

svmon -P $SMON_PID | grep shmat |
  awk -v SortBy=$SORT_BY -v SgaSize=$SGA_REQUESTED_SIZE '
  BEGIN {
    print_header();
  }

  {
    if($6 == "s" || $6 == "sm") {page_size=4} 
    else if ($6 == "m") {page_size=64} 
    else if ($6 == "L") {page_size=16*1024} 
    else {page_size = -1};

    aL[NR] = sprintf("%10s %2s %10.2f %10.2f %10.2f %10.2f", $1, $6, $7*page_size/1024, $8*page_size/1024, $9*page_size/1024, $10*page_size/1024);
    aInUse[NR] = $7*page_size ":" NR; aPin[NR] = $8*page_size ":" NR; aPgSp[NR] = $9*page_size ":" NR; aVirt[NR] = $10*page_size ":" NR;

    nSegs++;
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

    isort(aIndex, 1, NR)
    for(i=1; i <= NR; i++) {
      split(aIndex[i], B, ":")
      print aL[B[2]];
    }

    print_header();
    printf "%10s %2s %10.2f %10.2f %10.2f %10.2f\n", "TOTAL:", "", sum_array(aInUse), sum_array(aPin), sum_array(aPgSp), sum_array(aVirt);
    printf "\n%20s %20s\n\n", "Requested SGA: " SgaSize, "Segments: " nSegs;
  }

  function print_header() {
    print "---------- -- ---------- ---------- ---------- ----------"
    print "   Vsid    Pg   InMem       Pin       Paging     Virtual "
    print "---------- -- ---------- ---------- ---------- ----------"
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
