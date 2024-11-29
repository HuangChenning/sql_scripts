#!/usr/bin/ksh
export LANG=en
 
#ÁʱĿ¼
tmp_dest=/tmp
#Ó»§Ã
#username=username
#ÃÂ
#password=password
 
cd $tmp_dest
#sqlplus -s $username/$password<<XFF>/dev/null
sqlplus -s / as sysdba<<XFF>/dev/null
set echo on
spool sqlplus.txt
col name format a20
col value format a55
select name,value from v\$parameter where name='background_dump_dest';
spool off
exit
XFF
 
alert_path_num=$(grep -n "background_dump_dest" $tmp_dest/sqlplus.txt |awk -F":" '{print $1}')
alert_path=$(cat $tmp_dest/sqlplus.txt |sed -n "${alert_path_num}p" | awk -F" " '{print $2}')
 
first_day=`cat $tmp_dest/first_day.tmp`
d_day=$(date +%e)
if [ $d_day -lt 10 ]
then
###########עÒ:ÒÏ}Ö·½ʽѡÔÆһ###################
#²¿·Öµͳ³ölertÈ־ÀÈ:Tue Aug  7 07:44:59 2012
 last_day=$(date +%a)' '$(date +%b)'.*'$d_day'.*'$(date +%Y)
 
#²¿·Öµͳ³ölertÈ־ÀÈ:Thu Jun 07 13:56:18 2012
 n_day=`echo $d_day | awk 'gsub(/^ *| *$/,"")'`
 last_day=$(date +%a)' '$(date +%b)'.*0'$n_day'.*'$(date +%Y)
 
else
 last_day=$(date|cut -c 1-10).*$(date +%Y)
fi
echo $last_day > $tmp_dest/first_day.tmp
first_num=$(grep -n "$first_day" $alert_path/alert_$ORACLE_SID.log |head -1|awk -F":" '{print $1}')
if [ -z "$first_num" ]
then
   first_num=1
fi
 
#Ð¸Älast_dayΪ'.*',±íalertÈ־½á
last_num=$(grep -n ".*" $alert_path/alert_$ORACLE_SID.log |tail -1|awk -F":" '{print $1}')
 
point=1
export=$point
 
echo "########################## checking alert_log start $first_day ########################## "
 
sed -n "${first_num},${last_num}p" $alert_path/alert_$ORACLE_SID.log > $tmp_dest/trunc_alert
cat $tmp_dest/trunc_alert|grep ORA-|while read line
do
   line=$(echo "$line"|sed -e 's/\[/\\[/g;s/\]/\\]/g')
   time=$(grep -n "$line" $tmp_dest/trunc_alert | awk -F':' '{print $1}'|wc -l)
 
if [ "$time" -ge 1 ]
then
   num=$(grep -n "$line" $tmp_dest/trunc_alert|awk -F':' '{print $1}'|tail -1)
   #echo $num
   front_num=$((num-1))
   back_num=$((num+9))
 
   echo "++++++++++++++++++$point++++++++++++++++++++"
    sed -n "${front_num},${back_num}p" $tmp_dest/trunc_alert
   echo "++++++++++++++++++$point-End++++++++++++++++"
   point=$((point+1))
 
   flag=1
else
     if [ -z "$time" ]
     then
     flag=0
     fi
fi
done
 
#rm $tmp_dest/trunc_alert
#rm $tmp_dest/sqlplus.txt
 
if [ " $flag " -eq 0 ]
   then
   echo "No errors in $first_day !"
fi
echo "########################## checking alert_log end $last_day ########################## "

rm -rf $tmp_dest/sqlplus.txt
