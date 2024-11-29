#!/usr/bin/ksh
sqlplus -prelim / as sysdba<<EOF
oradebug setmypid
oradebug  hanganalyze 4
oradebug dump systemstate 266
exit
EOF
