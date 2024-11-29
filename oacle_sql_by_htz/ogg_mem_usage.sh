#!/bin/bash

###############################
# determine the OS type
###############################
OSNAME=`uname`

case "$OSNAME" in
  "SunOS")
    echo "OSNAME = $OSNAME"
    ;;
  "Linux")
    echo "OSNAME = $OSNAME"
    ;;
  "*")
    echo "This script has not been verified on $OSNAME"
    exit 1
    ;;
esac

###############################
# set the temp file
###############################
TMPFILE=/tmp/pmem.tmp
if [ -f $TMPFILE ]
then
  rm -f $TMPFILE
fi

################################
# loop over the gg process types
################################
PROCESSES="extract replicat"

for PROCESS in $PROCESSES
do
  FLAG=""
  FLAG=`ps -ef | grep $PROCESS`
  if [ -z "FLAG" ]
  then
    echo "No $PROCESS processes found"
  else
    echo
    echo "#####################################"
    echo "# Individual $PROCESS Process Usage #"
    echo "#####################################"
    case "$OSNAME" in
      "Linux")
        ps -C $PROCESS -O rss > $TMPFILE
        cat $TMPFILE | grep $PROCESS | awk '{print $2/1024, "MB", $12}' | sort -k 2
        ;;
      "SunOS")
        ps -efo vsz,uid,pid,ppid,pcpu,args | grep -v grep | grep $PROCESS > $TMPFILE
        cat $TMPFILE | grep $PROCESS | awk '{print $1/1024, "MB", $8}' | sort -k 2
        ;;
      "*")
        echo "This script has not been verified on $OSNAME"
        exit 1
        ;;
    esac
    rm -f $TMPFILE

    echo
    echo "#####################################"
    echo "#   Total $PROCESS Process Usage    #"
    echo "#####################################"
    case "$OSNAME" in
      "Linux")
        ps -C $PROCESS -O rss > $TMPFILE
        cat $TMPFILE | grep $PROCESS | awk '{count ++; sum=sum+$2; } END \
          { print "Number of processes      =",count; \
          print "AVG Memory usage/process =",sum/1024/count, "MB"; \
          print "Total memory usage       =", sum/1024,  " MB"}'
        ;;
      "SunOS")
        ps -efo vsz,uid,pid,ppid,pcpu,comm | grep -v grep | grep $PROCESS > $TMPFILE
        cat $TMPFILE | awk '{count ++; sum=sum+$1; } END \
          { print "Number of processes      =",count; \
          print "AVG Memory usage/process =",sum/1024/count, "MB"; \
          print "Total memory usage       =", sum/1024,  " MB"}'
        ;;
      "*")
        echo "This script has not been verified on $OSNAME"
        exit 1
        ;;
    esac
    rm -f $TMPFILE
  fi
done

exit 0