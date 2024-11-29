# OS specific locations
SYSTEM=`uname -s`
if [ $SYSTEM = "Linux" ] ; then
        . ~/.bash_profile;
else
        . ~/.profile;
fi

if [[ "$SYSTEM" = 'Linux' ]]; then
   #Linux version
   cat /proc/meminfo|grep -E "HugePages|AnonPages|AnonHugePages"
   vmstat 2 2 
   df -h   
   free -g
elif [[ "$SYSTEM" = 'AIX' ]]; then
   vmstat -P all
   vmstat 2 2
   df -g
else
   echo "not linux and aix";
   exit
fi


##collect database

sqlplus -s "/ as sysdba" << EOF
@collect_database.sql
exit;
EOF


echo "LISTENER "
lsnrctl status listener

echo "ALERT"

runsql(){
sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
$1
EOF
}

TMPTEXT=`runsql "SELECT substr(VALUE,INSTR(VALUE,'diag'))||' '||to_char(SYSDATE-10,'yyyy-mm-dd') FROM v\\$diag_info WHERE NAME='ADR Home';"`
ADRHOME=`echo $TMPTEXT|awk '{print $1}'`
QRYDATE=`echo $TMPTEXT|awk '{print $2}'`

adrci exec="set home $ADRHOME;show alert -term -p \\\"ORIGINATING_TIMESTAMP>'$QRYDATE' and message_text like '%ORA-%'\\\" "