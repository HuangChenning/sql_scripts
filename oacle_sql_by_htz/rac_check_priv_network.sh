#!/bin/ksh

export TODAY=`date "+%Y%m%d"`
while [ $TODAY -lt 20121231 ] # format needs to be YearMonthDate 
do
export TODAY=`date "+%Y%m%d"`
export LOGFILE=/tmp/interconnect_test_${TODAY}.log
ssh drrac1-priv "hostname; date" >> $LOGFILE 2>&1
ssh drrac2-priv "hostname; date" >> $LOGFILE 2>&1
ssh drrac3-priv "hostname; date" >> $LOGFILE 2>&1

echo "" >> $LOGFILE
echo "" >> $LOGFILE

sleep 5
done
