#!/bin/bash

#�ű����е�ǰ������Ҫ����FTP���з��������Բ���Ҫ��������SSH��¼Ŀ�������
PATH_GROUP=$1                                                        #���崫�Ǹ�Ŀ¼��                                                                                  
SHELL_HOME=/linshi/shell/ftp                                         #���屾�ػ���λ��
REMOTE_HOME=/linshi/shell/ftp                                        #����Զ�̽ű�λ��
FTP_FILE_LOG=$SHELL_HOME/ftp_file_log_$PATH_GROUP.txt                #������Щ�ļ���Ҫ���䣬����Ҫ������ļ�������FTP_FILE_LOG�ļ���
FINISH_FTP_FILE_LOG=$SHELL_HOME/finish_ftp_file_log_$PATH_GROUP.txt  #��¼�Ѿ�FTP�ɹ����ļ������ļ���
RUN_FTP_FILE_LOG=$SHELL_HOME/run_ftp_file_log_$PATH_GROUP.txt        #���δ�����Ҫ������ļ�
FTP_RUN_LOG=$SHELL_HOME/ftp_run_log_$PATH_GROUP.txt                  #FTP����ʱ���������־�ļ�
PATH_PATH=/linshi/dev/vx/rdsk/vgacctdb                               #�ļ���·����
PATH_FILE=$PATH_PATH$PATH_GROUP                                      #�ļ�������·����
ERROR_FILE_LOG=$SHELL_HOME/ftp_error_file_log_${PATH_GROUP}
EXCLUDE_FILE_LOG=$SHELL_HOME/exclude_file_log.txt                    #��Ҫ�ų����ļ���
IP_ADDR=192.168.111.5                                                #ftpԶ�̵�IP��ַ
SCRIPT_RUNING=$SHELL_HOME/script_runing_$PATH_GROUP 


###############################################################################
# NAME:        display
# ������ʾ��־��Ϣ
#
###############################################################################
display()
{
    DE=`date +"%Y-%m-%d %H:%M:%S"`
    printf "%18s %30s : %s\n" "${DE}" "$1" "$2"
}

###############################################################################
# NAME:        chkerr
# ���ڼ�����������Ƿ�ִ�гɹ������ִ�гɹ�����Ϊ0�����ִ��ʧ�ܾ�ֱ���Ƴ�����
# ����ʾ������Ϣ
###############################################################################
chkerr()
{
if [ "$1" -ne "0" ]; then
  display "chkerr"  "$2" "$3"
  display "chkerr" "Output Error Function Name To The Wrong File"
  echo "$3" >> ${ERROR_FILE_LOG}
  exit $1
fi
}


###############################################################################
# NAME:        find_filename
# ������ҪFTP���ļ��������FTP_FILE_LOG�ļ���
# 
###############################################################################
find_filename()
{
    display "find_filename" "Begin Find All File Name Into Temp File"
    #����ָ��·���������е��ļ�������
    find $PATH_FILE -type f > ${FTP_FILE_LOG}_temp
    chkerr $? "Failed ! Exec Find All File Name Into Temp File" 
    #ȥ���ų����ļ������֣�����ҪFTP������ļ�д�뵽ftp file log
    display "find_filename" "Begin Find All File Name that will Ftp Into Log File"
    diff  ${FTP_FILE_LOG}_temp ${EXCLUDE_FILE_LOG}|grep -E "^< "|sed 's/< //'   > $FTP_FILE_LOG
    chkerr $? "Failed ! Exec Find All File Name that will Ftp Into Log File" 
}


###############################################################################
# NAME:        file_exists
# �����ж�Ŀ¼�Ƿ����
# 
###############################################################################
file_exists()
{
  param_number=$#
  file_name=$1
  if [ "$param_number" -gt "1" ];then
  	 display "file_exists" "Remote Check File $file_name"
     ssh -l oracle ${IP_ADDR} "ls -l ${file_name}" >>/dev/null 2>&1
     chkerr $? "Remote ${file_name} Is Not Exists"
     display "file_exists" "Remote Check File $file_name Is Exist"
  elif [ "$param_number" -eq "1" ];then
  	 display "file_exists" "Local Check File $file_name"
     ls -l ${file_name} >>/dev/null 2>&1
     chkerr $? "Local ${file_name} Is Not Exists"
     display "file_exists" "Local Check File $file_name Is Exist"
  fi
}


###############################################################################
# NAME:        file_exists_touch
# �����ж��ļ��Ƿ���ڣ���������ھʹ���һ��
# 
###############################################################################
file_exists_touch()
{
  file_name=$1
  if [ ! -f $file_name ];then
     display "file_exists_touch" "${file_name} Is Not Exits,And Touch $file_name" 
     touch $file_name
     chkerr $? "Failed ! Touch ${file_name}" "file_exists_touch"
     display "file_exists_touch" "Success !  Touch ${file_name}"
  fi
}

###############################################################################
# NAME:        dir_exists
# �����ж�Ŀ¼�Ƿ����
# 
###############################################################################
dir_exists()
{
  param_number=$#
  dir_name=$1
  if [ "$param_number" -gt "1" ];then
  	 display "dir_exists" "Remote Check Dir $1"
     ssh -l oracle ${IP_ADDR} "ls -l ${dir_name}" >>/dev/null 2>&1
     chkerr $? "Remote ${dir_name} Is Not Exists"
     display "dir_exists" "Remote Check Dir $1 Is Exist"
  elif [ "$param_number" -eq "1" ];then
  	 display "dir_exists" "Local Check Dir $1"
     ls -l ${dir_name} >>/dev/null
     chkerr $? "Local ${dir_name} Is Not Exists"
     display "dir_exists" "Local Check Dir $1 Is Exist"
  fi
}
###############################################################################
# NAME:        create_ftp_file
# �Ա��Ѿ���ɵ��ϴ��ļ��������ɱ�����ҪFTP�ϴ����ļ�����RUN_FTP_FILE_LOG��־�ļ���
# 
###############################################################################
create_ftp_file()
{
  display "create_ftp_file" "Diff Ftp Log File and Create RUN ftp log"
  #FIND���ɵ��ļ������ϴ���ɵ���־�ļ����жԱȣ����ɱ���FTP��Ҫ�ϴε��ļ���
  diff $FTP_FILE_LOG $FINISH_FTP_FILE_LOG|grep -E "^< "|sed 's/< //'   > $RUN_FTP_FILE_LOG
  chkerr $? "Failed ! Create Finish Ftp Log File"
}


###############################################################################
# NAME:        ping_test
# �Ա��Ѿ���ɵ��ϴ��ļ��������ɱ�����ҪFTP�ϴ����ļ�����RUN_FTP_FILE_LOG��־�ļ���
# 
###############################################################################
ping_test()
{
  display "ping_test" "Test Ping ${IP_ADDR}"
  #PING��������IP��ַ�����Ƿ���PINGͬ
  ping -c 2 ${IP_ADDR} >>/dev/null
  chkerr $? "Failed ! Test Ping ${IP_ADDR}"
}
###############################################################################
# NAME:        ssh_test
# �Ա��Ѿ���ɵ��ϴ��ļ��������ɱ�����ҪFTP�ϴ����ļ�����RUN_FTP_FILE_LOG��־�ļ���
# 
###############################################################################
ssh_test()
{
  display "ssh_test" "Test Ssh ${IP_ADDR}"
  #PING��������IP��ַ�����Ƿ���PINGͬ
  ssh -l oracle ${IP_ADDR} "ls -l " >/dev/null
  chkerr $? "Failed ! Test Ssh ${IP_ADDR}"
}
###############################################################################
# NAME:        check_running
# �û��жϽű��Ƿ���ִ�У������ִ�о��Ƴ������û��ִ�оͼ���ִ�нű�
#
###############################################################################
check_running()
{
   if [ -f $ERROR_FILE_LOG ];then
         display "check_running" "Error Be Exists,Program Last Exist Due to Error"
         remove_check_file $ERROR_FILE_LOG
   else
        if [ -f $SCRIPT_RUNING ];then
          display "check_running" "Script Is Runing,Will Be Exists"
          exit 0
        fi
     fi
     display "check_running" "Touch Check File Log"
     touch $SCRIPT_RUNING
     chkerr $? "Failed ! Touch Check File Log" "check_running"
}


###############################################################################
# NAME:        check_running
# �ű������꣬ɾ�����м��ű�
#
###############################################################################
remove_check_file()
{
     if [ -f $1 ];then
         display "remove_check_file" "File Is Exist,Will Be Rm $1"
         rm $1
         chkerr $? "Failed ! Rm Check File :$SCRIPT_RUNING" "remove_check_file"
         if [ -f $1 ];then
           display "remove_check_file" "Failed !Remove $1"
         else
           display "remove_check_file" "Success !Remove $1" 
         fi
     fi
}
###############################################################################
# NAME:        ftp_file
# �ϴ��ļ���ָ������������
# 
###############################################################################
ftp_file()
{
ftp -i -n $IP_ADDR << EOF >$FTP_RUN_LOG 
   user oracle "oracle"
   bin
   prom
   lcd $1
   cd $2 
   put $3
   bye  
EOF
}


###############################################################################
# NAME:        check_ftp_error_file
# �û����ftp�Ƿ��д�����Ϣ���
# 
###############################################################################
check_ftp_error_file()
{
  #���FTP��־�ļ��Ƿ�������ı���
  if [ `grep -E "Not connected|Could not create file|Failed" $FTP_RUN_LOG|wc -l|awk '{print $1}'` -ne "0" ];then
     display "ftp_file"  "Last Ftp Log File have not Fail,Please See ${FTP_RUN_LOG}"
     echo "1" >> ${ERROR_FILE_LOG} 
     exit 0
  else
     #�������ж���Ŀ������������Ƿ�����ļ���������ڴ���ɹ���
     display "ftp_file"  "Check  $2 Is Or Not Successfully"
     ssh -l oracle ${IP_ADDR} "ls -l $1/$2" >>/dev/null
     chkerr $? "Failed ! Check  $2 Is Not  Successfully"
     display "ftp_file"  "Check  $2 Is  Successfully"
  fi
}

###############################################################################
# NAME:        get_ftp_file
# ��RUN_FTP_FILE_LOG�ļ��ж�ȡ��Ҫ�ϴε��ļ���������ftp_file��ʵ���ϴ��ļ���
# 
###############################################################################
get_ftp_file()
{
   if [ `wc -l $RUN_FTP_FILE_LOG|awk '{print $1}'` -eq '0' ];then
   	    #����Ƿ����µ��ļ���Ҫ�ϴ�
        display "get_ftp_file" "No Any File In $RUN_FTP_FILE_LOG"
        #ɾ�����̱�ʶ���ļ�
        remove_check_file ${SCRIPT_RUNING}
        exit 0
   fi
   for i in $(cat $RUN_FTP_FILE_LOG)
   do
      display "get_ftp_file" "Begin Put File:File Name IS $i"
      #�����ϴ������ļ������֣�Ҳ����ȥ��·��
      data_file_name=`echo  $i|awk -F  '/' '{print $NF}'`
      chkerr $? "Failed ! Get Data File Name" "get_file_name"
      ftp_file $PATH_FILE  $PATH_FILE ${data_file_name} >/dev/null  2>&1
      display "get_ftp_file" "Check Ftp Run Log file"
      #���FTP��־�ļ��Ƿ����ɴ�����־�����û�д�����־����ô����ϴε��ļ��Ƿ���Ŀ��˴���
      check_ftp_error_file $PATH_FILE ${data_file_name}
      chkerr $? "Failed ! Create Finish Ftp Log File"
      #��ʾ�ļ��ϴ��ɹ�
      display "get_ftp_file" "Success ! Put File Name IS $i"
      #�ϴ��ɹ����ļ�д����־������ϴ��ɹ�
      echo $i >> $FINISH_FTP_FILE_LOG
      display "get_ftp_file" "Put $FINISH_FTP_FILE_LOG To Remote Shell Home"
      #��ȡ�ļ���
      finish_file_name=`echo  ${FINISH_FTP_FILE_LOG}|awk -F  '/' '{print $NF}'`
      #���ϴ��ɹ����ļ���־������Զ��ȥ���û�COVERNT��Դ�ļ�
      ftp_file $SHELL_HOME  $REMOTE_HOME ${finish_file_name}  >>/dev/null 2>&1
      #����ϴ��ɹ��ļ���־���Ƿ��ϴ���Ŀ���
      check_ftp_error_file $REMOTE_HOME ${finish_file_name}
      #Զ�̵���CONVERT�ű�����
      display "get_ftp_file"  "Remote Exec convert.sh "
      ssh -l oracle ${IP_ADDR} "nohup sh $REMOTE_HOME/convert.sh ${PATH_GROUP} >$REMOTE_HOME/convert_${PATH_GROUP}.txt 2>&1 &" >/dev/null
      
   done
   display "get_ftp_file" "Finish Put All File in $RUN_FTP_FILE_LOG"
   remove_check_file ${SCRIPT_RUNING}
}

total()
{
    check_running
    dir_exists ${PATH_FILE} 'R'
    dir_exists ${REMOTE_HOME} 'R'
    dir_exists ${PATH_FILE}
    file_exists ${REMOTE_HOME}/convert.sh 'R'
    ping_test
    ssh_test
    find_filename
    file_exists_touch $FINISH_FTP_FILE_LOG
    create_ftp_file
    get_ftp_file   
}

total