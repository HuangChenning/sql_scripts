#!/bin/ksh
sqlplus -s "/ as sysdba" <<EOF
set pagesize 9999 linesize 170
@$1
exit
