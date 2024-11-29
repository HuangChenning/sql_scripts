#!/bin/sh
#
# splitSSDPS.sh - Shell Script to split a trace file containing a
#                 systemstate dump into multiple files containing
#                 one process state from the original trace file.
#
# Usage:
# ~~~~~~
#  splitSSDPS.sh trace_file_name [output_filename_prefix]
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
   exit 1
fi

SPLIT_STRING="PROCESS "

prefix=$2

if [ "$prefix" == "" ]; then
   prefix=$1
fi

$RM $prefix.* 2>/dev/null

$CSPLIT -f $prefix. $1 /^"$SPLIT_STRING"/ "{*}" 2>/dev/null

exit 0


