#!/bin/bash
#脚本的功能是
PATH_GROUP=$1                    #定义GROUP的号码
SHELL_HOME=/linshi/shell/ftp     #定义脚本的位置
LOG_FILE_PATH=/linshi/shell/ftp  #远端传输过来的日志文件的位置也在这里
FINISH_FTP_FILE_LOG=$SHELL_HOME/finish_ftp_file_log_$PATH_GROUP.txt  #已经成功FTP的文件
FINISH_CONVERT_FILE_LOG=$SHELL_HOME/finish_convert_file_log_$PATH_GROUP.txt  #已经成功convert到ASM磁盘组的文件
RUN_CONVERT_FILE_LOG=$SHELL_HOME/run_convert_file_log_$PATH_GROUP.txt        #用于记录本次脚本需要CONVERT的数据文件的信息
DB_UNIQUE_NAME=accta                          #定义数据库的唯一名字
ASM_DISKGROUP=ACCTA_DATA01                    #定义ASM磁盘组的名字
RMAN_RUN_EXETMP=$SHELL_HOME/rman_run_exetmp$PATH_GROUP     #定义生成RMAN运行的脚本
RMAN_RUN_LOG_FILE=$SHELL_HOME/rman_run_log_$PATH_GROUP.txt  #定义rman运行时生成的日志文件
EXCLUDE_FILE='lv_redo_1g|standby|lv_undo_16g|lv_system_2g|lv_sysaux_2g|lv_undo_16g|lv_tmp_16g|lv_vg06_20g_066'  #这里定义需要排除的特定文件名
EXCLUDE_FILE_NAME_LOG=$SHELL_HOME/exclude_convert_file_name_$PATH_GROUP.txt #这里存放排除的文件
SCRIPT_RUNING=$SHELL_HOME/script_runing_$PATH_GROUP                         #程序运行的标识符
ERROR_FILE_LOG=$SHELL_HOME/error_file_log_$PATH_GROUP                       #定义程序运行出错的文件

###############################################################################
# NAME:        display
# 用于显示日志信息
#
###############################################################################
display()
{
        DE=`date +"%Y-%m-%d %H:%M:%S"`
        printf "%18s %30s : %s\n" "${DE}" "$1" "$2"
}


###############################################################################
# NAME:        display_raw
# 用于显示日志信息，这里不会使用
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
# 用户判断脚本是否在执行，如果在执行就推出，如果没有执行就继续执行脚本
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
# 脚本运行完，删除运行检查脚本
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
# 用于检查上条命令是否执行成功。如果执行成功换回为0，如果执行失败就直接推出程序
# 并显示错误信息
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
# 将源数据文件的路径通过RMAN的convert命令转换到目录地址，开启并行为8
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
# 判断FTP上传成功的日志的文件，如果日志文件不存在，那么报错并推出程序
# 
###############################################################################
finish_file_exists()
{
  file_name=$FINISH_FTP_FILE_LOG
  #判断FINISH_FTP_FILE_LOG文件是否存在，如果不存在，显示信息并推出
  if [ ! -f $file_name ];then
     display  "finish_file_exists" "$file_name Is Not Exist,Will be Exit"
     echo "$3" >> ${ERROR_FILE_LOG}
     exit 0
  fi
  
}
###############################################################################
# NAME:        file_exists_touch
# 用于判断文件是否存在，如果不存在就创建一个
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
# 收集需要转换的文件名，并保存到RUN_CONVERT_FILE_LOG文件中，其它需要排除指定的文件
# 这里排除不建议使用，遇到之前FTP上传文件前没有排除，在下次会在FTP上传前提前排除
###############################################################################
create_covert_file()
{
  display "create_covert_file" "Diff Ftp Log File and Finsih Convert File,Create Run Convert log"
  #使用FINISH_FTP_FILE_LOG 与FINISH_CONVERT_FILE_LOG文件做比较，将新成功传入的文件输出到需要转换的文件中
  diff $FINISH_FTP_FILE_LOG $FINISH_CONVERT_FILE_LOG|grep -E "^< "|sed 's/< //'|grep -v -E $EXCLUDE_FILE  > $RUN_CONVERT_FILE_LOG
  chkerr $? "Failed ! Diff Ftp Log File and Finsih Convert File,Create Run Convert log"
  display "create_covert_file" "Diff Ftp Log File and Finsih Convert File,Create Exclude File Name log"
  #生成排除的文件，用于后期判断是否排除有问题
  diff $FINISH_FTP_FILE_LOG $FINISH_CONVERT_FILE_LOG|grep -E "^< "|sed 's/< //'|grep -E $EXCLUDE_FILE  > $EXCLUDE_FILE_NAME_LOG
  #下面判断有问题，如果没有找到排除的文件，上面程序换回-1的结果，所以下面要排除掉
  #chkerr $? "Failed ! Diff Ftp Log File and Finsih Convert File,Create Exclude File Name log" "create_covert_file"
}

###############################################################################
# NAME:        get_file_name
# 在RUN_CONVERT_FILE_LOG文件中获取需要转换的文件，调用rman_convert_file来进行转换
# 目标生成的文件文件名默认是ASM下面
###############################################################################
get_file_name()
{
  for i in $(cat $RUN_CONVERT_FILE_LOG)
   do
       display "get_file_name" "Source File Name Is $i"
       #生成数据文件的名字，也就是去掉路径
       data_file_name=`echo  $i|awk -F  '/' '{print $NF}'`
       chkerr $? "Failed ! Get Data File Name" "get_file_name"
#      if [[ ${data_file_name} =~ "lv_redo" ]];then
#        display "get_file_name" "File Name Is Redo Log File,Will Be Skip"
#      else
        #生成ASM文件的名字
        asm_target_file_name=+${ASM_DISKGROUP}/${DB_UNIQUE_NAME}/datafile/${data_file_name}
        chkerr $? "Failed ! Get Asm File Name" "get_file_name"
        display "get_asm_file_name" "Asm File Name :${asm_target_file_name}" 
        display "convert file to asm"  "Begin Convert ${data_file_name} To ${ASM_DISKGROUP}"
        #开始转换文件
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
# 主程序
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