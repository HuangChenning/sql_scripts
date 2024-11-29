#!/bin/bash

#脚本运行的前提是需要配置FTP运行服务器可以不需要输入密码SSH登录目标服务器
PATH_GROUP=$1                                                        #定义传那个目录的                                                                                  
SHELL_HOME=/linshi/shell/ftp                                         #定义本地基本位置
REMOTE_HOME=/linshi/shell/ftp                                        #定义远程脚本位置
FTP_FILE_LOG=$SHELL_HOME/ftp_file_log_$PATH_GROUP.txt                #查找那些文件需要传输，把需要传输的文件报错在FTP_FILE_LOG文件中
FINISH_FTP_FILE_LOG=$SHELL_HOME/finish_ftp_file_log_$PATH_GROUP.txt  #记录已经FTP成功的文件到此文件中
RUN_FTP_FILE_LOG=$SHELL_HOME/run_ftp_file_log_$PATH_GROUP.txt        #本次传输需要传输的文件
FTP_RUN_LOG=$SHELL_HOME/ftp_run_log_$PATH_GROUP.txt                  #FTP运行时，输出的日志文件
PATH_PATH=/linshi/dev/vx/rdsk/vgacctdb                               #文件的路径名
PATH_FILE=$PATH_PATH$PATH_GROUP                                      #文件的完整路径名
ERROR_FILE_LOG=$SHELL_HOME/ftp_error_file_log_${PATH_GROUP}
EXCLUDE_FILE_LOG=$SHELL_HOME/exclude_file_log.txt                    #需要排除的文件名
IP_ADDR=192.168.111.5                                                #ftp远程的IP地址
SCRIPT_RUNING=$SHELL_HOME/script_runing_$PATH_GROUP 


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
# NAME:        find_filename
# 查找需要FTP的文件，存放在FTP_FILE_LOG文件中
# 
###############################################################################
find_filename()
{
    display "find_filename" "Begin Find All File Name Into Temp File"
    #生成指定路径下面所有的文件的名字
    find $PATH_FILE -type f > ${FTP_FILE_LOG}_temp
    chkerr $? "Failed ! Exec Find All File Name Into Temp File" 
    #去除排除的文件的名字，将需要FTP传输的文件写入到ftp file log
    display "find_filename" "Begin Find All File Name that will Ftp Into Log File"
    diff  ${FTP_FILE_LOG}_temp ${EXCLUDE_FILE_LOG}|grep -E "^< "|sed 's/< //'   > $FTP_FILE_LOG
    chkerr $? "Failed ! Exec Find All File Name that will Ftp Into Log File" 
}


###############################################################################
# NAME:        file_exists
# 用于判断目录是否存在
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
# NAME:        dir_exists
# 用于判断目录是否存在
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
# 对比已经完成的上传文件名，生成本次需要FTP上传的文件名到RUN_FTP_FILE_LOG日志文件中
# 
###############################################################################
create_ftp_file()
{
  display "create_ftp_file" "Diff Ftp Log File and Create RUN ftp log"
  #FIND生成的文件名与上传完成的日志文件进行对比，生成本次FTP需要上次的文件名
  diff $FTP_FILE_LOG $FINISH_FTP_FILE_LOG|grep -E "^< "|sed 's/< //'   > $RUN_FTP_FILE_LOG
  chkerr $? "Failed ! Create Finish Ftp Log File"
}


###############################################################################
# NAME:        ping_test
# 对比已经完成的上传文件名，生成本次需要FTP上传的文件名到RUN_FTP_FILE_LOG日志文件中
# 
###############################################################################
ping_test()
{
  display "ping_test" "Test Ping ${IP_ADDR}"
  #PING服务器的IP地址，看是否能PING同
  ping -c 2 ${IP_ADDR} >>/dev/null
  chkerr $? "Failed ! Test Ping ${IP_ADDR}"
}
###############################################################################
# NAME:        ssh_test
# 对比已经完成的上传文件名，生成本次需要FTP上传的文件名到RUN_FTP_FILE_LOG日志文件中
# 
###############################################################################
ssh_test()
{
  display "ssh_test" "Test Ssh ${IP_ADDR}"
  #PING服务器的IP地址，看是否能PING同
  ssh -l oracle ${IP_ADDR} "ls -l " >/dev/null
  chkerr $? "Failed ! Test Ssh ${IP_ADDR}"
}
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
# NAME:        ftp_file
# 上传文件到指定服务器上面
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
# 用户检查ftp是否有错误信息输出
# 
###############################################################################
check_ftp_error_file()
{
  #检查FTP日志文件是否有下面的报错
  if [ `grep -E "Not connected|Could not create file|Failed" $FTP_RUN_LOG|wc -l|awk '{print $1}'` -ne "0" ];then
     display "ftp_file"  "Last Ftp Log File have not Fail,Please See ${FTP_RUN_LOG}"
     echo "1" >> ${ERROR_FILE_LOG} 
     exit 0
  else
     #下面是判断在目标服务器上面是否存在文件，如果存在代表成功。
     display "ftp_file"  "Check  $2 Is Or Not Successfully"
     ssh -l oracle ${IP_ADDR} "ls -l $1/$2" >>/dev/null
     chkerr $? "Failed ! Check  $2 Is Not  Successfully"
     display "ftp_file"  "Check  $2 Is  Successfully"
  fi
}

###############################################################################
# NAME:        get_ftp_file
# 从RUN_FTP_FILE_LOG文件中读取需要上次的文件名，调用ftp_file来实现上传文件名
# 
###############################################################################
get_ftp_file()
{
   if [ `wc -l $RUN_FTP_FILE_LOG|awk '{print $1}'` -eq '0' ];then
   	    #检查是否有新的文件需要上传
        display "get_ftp_file" "No Any File In $RUN_FTP_FILE_LOG"
        #删除进程标识符文件
        remove_check_file ${SCRIPT_RUNING}
        exit 0
   fi
   for i in $(cat $RUN_FTP_FILE_LOG)
   do
      display "get_ftp_file" "Begin Put File:File Name IS $i"
      #生成上传数据文件的名字，也就是去掉路径
      data_file_name=`echo  $i|awk -F  '/' '{print $NF}'`
      chkerr $? "Failed ! Get Data File Name" "get_file_name"
      ftp_file $PATH_FILE  $PATH_FILE ${data_file_name} >/dev/null  2>&1
      display "get_ftp_file" "Check Ftp Run Log file"
      #检查FTP日志文件是否生成错误日志，如果没有错误日志，那么检查上次的文件是否在目标端存在
      check_ftp_error_file $PATH_FILE ${data_file_name}
      chkerr $? "Failed ! Create Finish Ftp Log File"
      #显示文件上传成功
      display "get_ftp_file" "Success ! Put File Name IS $i"
      #上传成功的文件写入日志，标记上传成功
      echo $i >> $FINISH_FTP_FILE_LOG
      display "get_ftp_file" "Put $FINISH_FTP_FILE_LOG To Remote Shell Home"
      #获取文件名
      finish_file_name=`echo  ${FINISH_FTP_FILE_LOG}|awk -F  '/' '{print $NF}'`
      #将上传成功的文件日志，传到远程去，用户COVERNT的源文件
      ftp_file $SHELL_HOME  $REMOTE_HOME ${finish_file_name}  >>/dev/null 2>&1
      #检查上传成功文件日志，是否上传到目标端
      check_ftp_error_file $REMOTE_HOME ${finish_file_name}
      #远程调用CONVERT脚本运行
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