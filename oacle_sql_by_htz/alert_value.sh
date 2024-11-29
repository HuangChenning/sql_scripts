#!/bin/ksh
runsql(){
sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off time off timing off echo off long 9999 linesize 130 
$1
exit
EOF
}
ALERTLOG=`runsql "SELECT /*+no_merge(DIR) no_merge(FILENAME)*/ VALUE || '/alert_' || INSTANCE_NAME || '.log'  FROM (SELECT VALUE FROM V\\$PARAMETER WHERE NAME = 'background_dump_dest') DIR,(SELECT INSTANCE_NAME FROM V\\$INSTANCE) FILENAME;"`
echo "$ALERTLOG"
