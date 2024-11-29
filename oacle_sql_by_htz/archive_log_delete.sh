#!/usr/bin/ksh
. /home/oracle/.profile

###如果归档日志文件系统已经超过90％，则删除最旧的30个日志
###可以在同一台主机上对多个归档目录进行判断
###crontab中调用
###delete arch log ,when archive directory space greater than 85%
###00,15,30,45 * * * * ksh /home/oracle/rs/log/delete_arch.sh > /home/oracle/rs/log/delete.log 2>&1

CHKLOG_PATH=/home/oracle/rs/log

delete_arch_log()
{
ARCHLOG_PATH=$1
df -k | grep ${ARCHLOG_PATH} | awk '{print $4}' | awk -F% '{print $1}' | read Used
echo "$Used"
if (test $Used -gt 90) then

        CURRDATE=`date +%Y%m%d`
        CURRTIME=`date +%Y%m%d_%T`
        echo "_____**** ${CURRTIME} BEGIN DELETE ****______" >>${CHKLOG_PATH}/${CURRDATE}_UP_DEL.log
        ls -lt ${ARCHLOG_PATH} |grep ARC |awk '{print $9}' |tail -30| while read FileName
        do
            echo "$FileName " >>${CHKLOG_PATH}/${CURRDATE}_UP_DEL.log
            cd ${ARCHLOG_PATH}
            rm "$FileName"
        done
        echo "_____**** ${CURRTIME} END   DELETE ****______" >>${CHKLOG_PATH}/${CURRDATE}_UP_DEL.log
rman target / <<EOF
run{
crosscheck archivelog all;   ---更新控制文件记录
###delete noprompt expired archivelog all;
}
EOF
fi
}

delete_arch_log /arch1
delete_arch_log /arch2
