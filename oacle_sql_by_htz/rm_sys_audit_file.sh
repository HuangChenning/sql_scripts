#!/bin/bash

if [ $# != 4 ];then
        echo "USAGE: $0 DBNAME SIDNAME DBVERSION  DAY"
        exit;
fi

SYSTEM=`uname -s`
DBNAME=$1;
SIDNAME=$2;
DBVERSION=$3;
LOGFILE=rm_sys_audit_`date +"%Y%m%d_%H%M%S"`.txt

if [ $DBVERSION -eq 11 ];then
        FILE_NAME=`echo $SIDNAME`_ora_*.aud;
elif [ $DBVERSION -eq 10 ];then
        FILE_NAME='ora_*.aud';
fi
BASEPATH=`echo $ORACLE_BASE`/admin/`echo $DBNAME`/adump/

if [ $SYSTEM = "Linux" ] ; then
        . ~/.bash_profile;
else
        . ~/.profile;
fi
BASEHOME=`echo $ORACLE_BASE`
if [ -z "$BASEHOME" ];then
        printf "please config ORACLE_BASE\n";
        exit
else
			 if [ -d "$BASEPATH" ];then
			 			printf "find file name and put into logfile text\n";
       			find $BASEPATH -name "$FILE_NAME" -mtime +$4 >./$LOGFILE
       			if [ `wc -l $LOGFILE|awk '{print $1}'` -ge 1 ];then
       				 printf "begin remove audit file\n";
						   find $BASEPATH -name "$FILE_NAME" -mtime +$4|xargs -n 1000 -i rm {} 
						   printf "success remove audit file\n";
						else
							printf "no file will be remove\n";
							exit;
						fi
			 fi
fi