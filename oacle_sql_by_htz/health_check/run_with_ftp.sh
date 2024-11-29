#!/bin/ksh
sqlplus '/as sysdba' @check.sql
sh oscheck.sh > ${ORACLE_SID}_log.log

ftp -n <<EOF
open 83.16.16.1
user zhangqiaoc 123456
prompt
ascii
mput *.html
mput *.log
mput *.lst
mput *.txt
EOF
