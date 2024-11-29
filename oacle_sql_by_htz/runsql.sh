#!/bin/ksh
while [ 1 ]
do
sqlplus -s "/ as sysdba" <<EOF
set pagesize 9999 linesize 170
@$1
exit
EOF
sleep 2
done

