#!/bin/sh
sqlplus / as sysdba <<EOF
purge dba_recyclebin; 
exit;
EOF 
