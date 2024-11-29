#################################################
## 
## File name:   exp2csv.sh
## Author:      zhangqiao
## Copyright:   zhangqiaoc@olm.com.cn
##
#################################################

export NLS_DATE_FORMAT="yyyy-mm-dd hh24:mi:ss"
export NLS_LANG=american_america.ZHS16GBK
mknod /tmp/tmp.txt p
cat /tmp/tmp.txt|grep -v -E "SQL>|----|^$"|sed 's/^/"/'|sed 's/$/"/'|sed 's/ *",/",/g'|sed 's/" */"/g' > /tmp/tmp.csv &

sqlplus -S "/as sysdba" <<EOF > /dev/null
set colsep '","'
set pagesize 50000
set trimspool on
set trim off
set feedback off
set headsep off
SET VERIFY OFF
set linesize 9999
set termout off
set numw 20
set arraysize 5000
spool /tmp/tmp.txt
$1
spool off
EOF
