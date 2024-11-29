sqlplus -prelim / as sysdba<<EOF
oradebug setmypid;
oradebug unlimit;
oradebug setinst all;
oradebug -g all hanganalyze 4;

oradebug -g all dump systemstate 266;

exit
EOF
