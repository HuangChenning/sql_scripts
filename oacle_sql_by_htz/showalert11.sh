runsql(){
sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
$1
EOF
}

TMPTEXT=`runsql "SELECT substr(VALUE,INSTR(VALUE,'diag'))||' '||to_char(SYSDATE-$1,'yyyy-mm-dd') FROM v\\$diag_info WHERE NAME='ADR Home';"`
ADRHOME=`echo $TMPTEXT|awk '{print $1}'`
QRYDATE=`echo $TMPTEXT|awk '{print $2}'`

adrci exec="set home $ADRHOME;show alert -term -p \\\"ORIGINATING_TIMESTAMP>'$QRYDATE' and message_text like '%ORA-%'\\\" "