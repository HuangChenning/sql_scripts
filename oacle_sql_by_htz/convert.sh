#!/bin/bash
#�ű��Ĺ�����
PATH_GROUP=$1                    #����GROUP�ĺ���
SHELL_HOME=/linshi/shell/ftp     #����ű���λ��
LOG_FILE_PATH=/linshi/shell/ftp  #Զ�˴����������־�ļ���λ��Ҳ������
FINISH_FTP_FILE_LOG=$SHELL_HOME/finish_ftp_file_log_$PATH_GROUP.txt  #�Ѿ��ɹ�FTP���ļ�
FINISH_CONVERT_FILE_LOG=$SHELL_HOME/finish_convert_file_log_$PATH_GROUP.txt  #�Ѿ��ɹ�convert��ASM��������ļ�
RUN_CONVERT_FILE_LOG=$SHELL_HOME/run_convert_file_log_$PATH_GROUP.txt        #���ڼ�¼���νű���ҪCONVERT�������ļ�����Ϣ
DB_UNIQUE_NAME=accta                          #�������ݿ��Ψһ����
ASM_DISKGROUP=ACCTA_DATA01                    #����ASM�����������
RMAN_RUN_EXETMP=$SHELL_HOME/rman_run_exetmp$PATH_GROUP     #��������RMAN���еĽű�
RMAN_RUN_LOG_FILE=$SHELL_HOME/rman_run_log_$PATH_GROUP.txt  #����rman����ʱ���ɵ���־�ļ�
EXCLUDE_FILE='lv_redo_1g|standby|lv_undo_16g|lv_system_2g|lv_sysaux_2g|lv_undo_16g|lv_tmp_16g|lv_vg06_20g_066'  #���ﶨ����Ҫ�ų����ض��ļ���
EXCLUDE_FILE_NAME_LOG=$SHELL_HOME/exclude_convert_file_name_$PATH_GROUP.txt #�������ų����ļ�
SCRIPT_RUNING=$SHELL_HOME/script_runing_$PATH_GROUP                         #�������еı�ʶ��
ERROR_FILE_LOG=$SHELL_HOME/error_file_log_$PATH_GROUP                       #����������г�����ļ�

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
# NAME:        display_raw
# ������ʾ��־��Ϣ�����ﲻ��ʹ��
#
###############################################################################

#display_raw()
#{
#if [ "$suppress" -eq "1" ]; then
#  return 0
#else
#  if [ "$suppresst" -eq "0" ]; then
#    echo -e "$1"
#  fi
#  if [ "$suppressl" -eq "0" ]; then
#    if [ "$LOG_RUN_ENABLED" -eq "1" ]; then
#      echo -e "$1" >> $LOG_RUN_FILE
#    fi
#  fi
#  return 0
#fi
#}

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
# NAME:        rman_convert_file
# ��Դ�����ļ���·��ͨ��RMAN��convert����ת����Ŀ¼��ַ����������Ϊ8
# 
###############################################################################
rman_convert_file()
{
source_file_name=$1
target_file_name=$2

rman target / nocatalog  msglog $RMAN_RUN_LOG_FILE append  << EOF
run {
allocate channel d1 type disk;
allocate channel d2 type disk;
allocate channel d3 type disk;
allocate channel d4 type disk;
allocate channel d5 type disk;
allocate channel d6 type disk;
allocate channel d7 type disk;
allocate channel d8 type disk;
convert from platform 'AIX-Based Systems (64-bit)' datafile  '$source_file_name' format '$target_file_name' parallelism 8;
release channel d1;
release channel d2;
release channel d3;
release channel d4;
release channel d5;
release channel d6;
release channel d7;
release channel d8;
}
exit;
EOF

# save sqlplus return value
l_se_ret=$?

return $l_se_ret
}

###############################################################################
# NAME:        finish_file_exists
# �ж�FTP�ϴ��ɹ�����־���ļ��������־�ļ������ڣ���ô�����Ƴ�����
# 
###############################################################################
finish_file_exists()
{
  file_name=$FINISH_FTP_FILE_LOG
  #�ж�FINISH_FTP_FILE_LOG�ļ��Ƿ���ڣ���������ڣ���ʾ��Ϣ���Ƴ�
  if [ ! -f $file_name ];then
     display  "finish_file_exists" "$file_name Is Not Exist,Will be Exit"
     echo "$3" >> ${ERROR_FILE_LOG}
     exit 0
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
# NAME:        create_covert_file
# �ռ���Ҫת�����ļ����������浽RUN_CONVERT_FILE_LOG�ļ��У�������Ҫ�ų�ָ�����ļ�
# �����ų�������ʹ�ã�����֮ǰFTP�ϴ��ļ�ǰû���ų������´λ���FTP�ϴ�ǰ��ǰ�ų�
###############################################################################
create_covert_file()
{
  display "create_covert_file" "Diff Ftp Log File and Finsih Convert File,Create Run Convert log"
  #ʹ��FINISH_FTP_FILE_LOG ��FINISH_CONVERT_FILE_LOG�ļ����Ƚϣ����³ɹ�������ļ��������Ҫת�����ļ���
  diff $FINISH_FTP_FILE_LOG $FINISH_CONVERT_FILE_LOG|grep -E "^< "|sed 's/< //'|grep -v -E $EXCLUDE_FILE  > $RUN_CONVERT_FILE_LOG
  chkerr $? "Failed ! Diff Ftp Log File and Finsih Convert File,Create Run Convert log"
  display "create_covert_file" "Diff Ftp Log File and Finsih Convert File,Create Exclude File Name log"
  #�����ų����ļ������ں����ж��Ƿ��ų�������
  diff $FINISH_FTP_FILE_LOG $FINISH_CONVERT_FILE_LOG|grep -E "^< "|sed 's/< //'|grep -E $EXCLUDE_FILE  > $EXCLUDE_FILE_NAME_LOG
  #�����ж������⣬���û���ҵ��ų����ļ���������򻻻�-1�Ľ������������Ҫ�ų���
  #chkerr $? "Failed ! Diff Ftp Log File and Finsih Convert File,Create Exclude File Name log" "create_covert_file"
}

###############################################################################
# NAME:        get_file_name
# ��RUN_CONVERT_FILE_LOG�ļ��л�ȡ��Ҫת�����ļ�������rman_convert_file������ת��
# Ŀ�����ɵ��ļ��ļ���Ĭ����ASM����
###############################################################################
get_file_name()
{
  for i in $(cat $RUN_CONVERT_FILE_LOG)
   do
       display "get_file_name" "Source File Name Is $i"
       #���������ļ������֣�Ҳ����ȥ��·��
       data_file_name=`echo  $i|awk -F  '/' '{print $NF}'`
       chkerr $? "Failed ! Get Data File Name" "get_file_name"
#      if [[ ${data_file_name} =~ "lv_redo" ]];then
#        display "get_file_name" "File Name Is Redo Log File,Will Be Skip"
#      else
        #����ASM�ļ�������
        asm_target_file_name=+${ASM_DISKGROUP}/${DB_UNIQUE_NAME}/datafile/${data_file_name}
        chkerr $? "Failed ! Get Asm File Name" "get_file_name"
        display "get_asm_file_name" "Asm File Name :${asm_target_file_name}" 
        display "convert file to asm"  "Begin Convert ${data_file_name} To ${ASM_DISKGROUP}"
        #��ʼת���ļ�
        rman_convert_file $i ${asm_target_file_name} >/dev/null
        chkerr $? "Failed ! Convert ${data_file_name} To ${ASM_DISKGROUP}"  "get_file_name"
        display "get_file_name" "Put Source File Name to Finish Log File"
        echo $i >> ${FINISH_CONVERT_FILE_LOG}
        chkerr $? "Failed ! Put Source File Name to Finish Log File"   "get_file_name"
#     fi   
   done
   display "get_file_name" "**********************$PATH_GROUP***************************************"
   display "get_file_name" "****************************FINISH**************************************"
   display "get_file_name" "************************************************************************"
   display "get_file_name" "************************************************************************"
}

###############################################################################
# NAME:        total
# ������
###############################################################################
total()
{
   check_running
   finish_file_exists ${FINISH_FTP_FILE_LOG}
   file_exists_touch ${FINISH_CONVERT_FILE_LOG}
   create_covert_file
   get_file_name
   remove_check_file $SCRIPT_RUNING
}

total