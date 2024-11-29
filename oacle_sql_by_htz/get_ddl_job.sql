#!/bin/bash

#1.创建存放迁移脚本目录
echo "!/bin/bash
cd /home/oracle/
if [ ! -d enmo ] ;then 
 mkdir enmo 
 else 
  echo dir_enmo exist
 fi 
cd /home/oracle/enmo
if [ ! -d script ] ;then 
 mkdir script 
 else 
  echo dir_enmo_script exist
 fi 
cd /home/oracle/enmo/script 
if [ ! -d log ] ;then 
 mkdir log 
 else 
  echo dir_enmo_script_log exist
 fi 
" >/home/oracle/mkdir_oracle.sh 
sh /home/oracle/mkdir_oracle.sh >>/home/oracle/mkdir_oracle.log
cat /home/oracle/mkdir_oracle.log

#2.创建本地Dump目录
echo "
#!/bin/sh
cd /u01
if [ ! -d app ] ;then 
 mkdir app 
 else 
  echo dir_app exist
 fi 
cd /u01/app/
if [ ! -d oracle ] ;then 
 mkdir oracle 
 else 
  echo dir_oracle exist
 fi 
cd /u01/app/oracle 
if [ ! -d enmo ] ;then 
 mkdir enmo 
 else 
  echo dir_u01_app_oracle_enmo exist
 fi
sqlplus / as sysdba >>/home/oracle/enmo/script/log/create_system_dump.log<<EOF
create or replace directory mydir as '/u01/app/oracle/enmo';   
grant read,write on directory mydir to public;
host df -h |grep /u01
exit;
EOF">/home/oracle/enmo/script/mkdir_dump_dir.sh 
sh /home/oracle/enmo/script/mkdir_dump_dir.sh 
cat /home/oracle/enmo/script/log/create_system_dump.log