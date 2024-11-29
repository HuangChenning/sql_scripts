#!/bin/bash

if  [ ! -n $1 ] ;then
      last_call_et=10

elif [ ! -n "$(echo $1| sed -n "/^[0-9]\+$/p")" ];then
      last_call_et=10

elif [ $1 -eq 0 ];then
      last_call_et=10

else
     last_call_et=$1
fi

runsql(){
sqlplus -s "/ as sysdba"<<EOF
SET FEEDBACK OFF;
SET TERM OFF;
SET ECHO OFF;
SET pages 0;
set verify off;
set heading off;
$1
exit
EOF
}

runsql "SELECT spid FROM v\$process WHERE addr IN (SELECT paddr FROM V\$SESSION s  WHERE     s.TYPE = 'USER' AND s.status = 'INACTIVE'  and s.machine <>sys_context('userenv','host') and username not in ('SYS','SYSTEM','DBSNMP','SYSMAN') AND s.last_call_et > ${last_call_et}*60);"|xargs kill -9
