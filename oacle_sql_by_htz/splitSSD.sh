#!/bin/sh
#
# splitSSD.sh - Shell Script to split a trace file containing multiple
#               systemstate dumps into one single file per systemstate
#
# Usage:
# ~~~~~~
#  splitSSD.sh trace_file_name [output_filename_prefix]		
# 
# Notes:
# ~~~~~~
# This script uses csplit, which is part of coreutils available in 
# most Unix/Linux.
# For windows users: csplit can be found as part of cygwin.
#
# Author:
# ~~~~~~~
# Cesar Campo
#

CSPLIT="/usr/bin/csplit -k -s -z"
ECHO=/bin/echo
RM=/bin/rm

if [ -z "${1}" ]
 then
   $ECHO " "
   $ECHO "Usage : $0 trace_file_name [output_filename_prefix]"
   $ECHO " "
   exit
fi

SPLIT_STRING="END OF SYSTEM STATE"

prefix=$2

if [ "$prefix" == "" ]; then
   prefix="ssd"
fi

$RM $prefix.* 2>/dev/null

$CSPLIT -f $prefix. $1 /^"$SPLIT_STRING"/1 "{100}" 2>/dev/null

exit 0

