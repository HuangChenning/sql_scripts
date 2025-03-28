#!/bin/ksh
################################################################################
##
## File name:   heapdump_analyzer
## Purpose:     Script for aggregating Oracle heapdump chunk sizes
##
## Author:      Tanel Poder
## Copyright:   (c) http://www.tanelpoder.com
##
## Usage:       1) Take a heapdump ( read http://www.juliandyke.com )
##
##              2) run ./heapdump_analyzer <heapdump tracefile name>
##                 For example: ./heapdump_analyzer ORCL_ora_4345.trc
##
## Other:       Only take heapdumps when you know what you're doing!
##              Taking a heapdump on shared pool (when bit 2 in heapdump event
##              level is enabled) can hang your database for a while as it
##              holds shared pool latches for a long time if your shared pool
##              is big and heavily active.
##
##              Private memory heapdumps are safer as only the dumped process is
##              affected.
##
##
################################################################################

if [ "$1" == "-t" ]; then
    EXCLUDE='dummy_nonexistent_12345'
    shift
else
    EXCLUDE='Total heap size$'
fi

echo
echo "  -- Heapdump Analyzer v1.00 by Tanel Poder ( http://www.tanelpoder.com )"
echo
echo "  Total_size #Chunks  Chunk_size,        From_heap,       Chunk_type,  Alloc_reason"
echo "  ---------- ------- ------------ ----------------- ----------------- -----------------"

cat $1 | awk '
     /^HEAP DUMP heap name=/ { split($0,ht,"\""); HTYPE=ht[2]; doPrintOut = 1; }
     /Chunk/{ if ( doPrintOut == 1 ) {
                split($0,sf,"\"");
                printf "%10d , %16s, %16s, %16s\n", $4, HTYPE, $5, sf[2];
              }
     }
     /Total heap size/ {
              printf "%10d , %16s, %16s, %16s\n", $5, HTYPE, "TOTAL", "Total heap size";
              doPrintOut=0;
     }
    ' | grep -v "$EXCLUDE" | sort -n | uniq -c | awk '{ printf "%12d %s\n", $1*$2, $0 }' | sort -nr
echo
