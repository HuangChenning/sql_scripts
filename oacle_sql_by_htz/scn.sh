#!/bin/bash

#grep -v ^$ rollback_create_file.log|grep -v ^"Elapsed"|grep -v "PL/SQL" >rollback_create_file.txt
#csplit -f test11 rollback_create_file.log /^sqlplus/ "{*}" 10

TABLESPACE='ACCT_DATA_01','ACCT_DATA_02','ACCT_DATA_03','ACCT_DATA_04','ACCT_DATA_05','ACCT_DATA_06','ACCT_DATA_07','ACCT_DATA_08','ACCT_DATA_09','ACCT_DATA_10','ACCT_DATA_11','ACCT_DATA_12','ACCT_DATA_INDEX_TBS','ACCT_DATA_TBS','ACCT_GROUP','ACCT_IDX_01','ACCT_OWE_01','ACCT_OWE_02','ACCT_OWE_03','ACCT_OWE_04','ACCT_OWE_05','ACCT_OWE_06','ACCT_OWE_07','ACCT_OWE_08','ACCT_OWE_09','ACCT_OWE_10','ACCT_OWE_11','ACCT_OWE_12','ACCT_OWE_IDX_01','BALANCE_01','BALANCE_02','BALANCE_03','BALANCE_04','BALANCE_05','BALANCE_06','BALANCE_07','BALANCE_08','BALANCE_09','BALANCE_10','BALANCE_11','BALANCE_12','BALANCE_IDX_01','BILL_01','BILL_02','BILL_03','BILL_04','BILL_05','BILL_06','BILL_07','BILL_08','BILL_09','BILL_10','BILL_11','BILL_12','BILL_IDX_01','HSS_DATA_01','HSS_DATA_02','HSS_DATA_03','HSS_DATA_04','HSS_DATA_05','HSS_DATA_06','HSS_DATA_07','HSS_DATA_08','HSS_DATA_09','HSS_DATA_10','HSS_DATA_11','HSS_DATA_12','HSS_IDX_01','INVOICE_01','INVOICE_02','INVOICE_03','INVOICE_04','INVOICE_05','INVOICE_06','INVOICE_07','INVOICE_08','INVOICE_09','INVOICE_10','INVOICE_11','INVOICE_12','INVOICE_IDX_01','ITF_DATA','PAYMENT_01','PAYMENT_02','PAYMENT_03','PAYMENT_04','PAYMENT_05','PAYMENT_06','PAYMENT_07','PAYMENT_08','PAYMENT_09','PAYMENT_10','PAYMENT_11','PAYMENT_12','PAYMENT_IDX_01','SHARE_TBS','USERS'                             #Ҫ�������ݵı�ռ�
REMOTE_SHELL_HOME=/linshi/shell/scn            #Զ�̴�Žű���·��
LOG_PATH=/linshi/shell/scn                     #���ؽű�·��
LOG_SQL_EXETMP=${LOG_PATH}/sql_run_exetmp.sql   #ִ��SQLʱ�����ɵ���ʱ�ļ�
LOCAL_BACKSET=/linshi/shell/scn/backup
REMOTE_BACKSET=/linshi/shell/scn/backup
LOG_RMAN_FILE=${LOG_PATH}/rman_run_log.txt      #ִ��RMANʱ��RMAN�������־·��
CURRENT_SCN=${LOG_PATH}/rman_current_scn.txt    #��ǰSCNֵ���λ��
OLD_CURRENT_SCN=${LOG_PATH}/old_rman_current_scn.txt #����ϴ�ִ��RMAN�������ݵ�SCNֵ
OLD_SCN_VALUE=0                                 #�ϴ�ִ��RMAN��������ʱ��SCNֵ
CURRENT_SCN_VALUE=0                             #��ѯ��ǰ��SCNֵ
DB_UNIQUE_NAME=accta                            #�������ݿ��Ψһ����
ASM_DISKGROUP=ACCTA_DATA01                      #����ASM�����������
SQL_SPOOL=${LOG_PATH}/spool_off.txt             #sqlִ��ʱ���ɵ�spool�ļ�
HANDLE_FILE=${LOG_PATH}/create_handle_file.txt  #���ڴ�������������ɵ�HANDLE�ļ�
IP_ADDR=133.37.94.182                           #FTP��IP��ַ
SHELL_DATE=`date +"%d%H%M"`                                     #���ڱ�ʾ�ļ�����һ����
TOTAL_CONVERT_FILENAME=total_convert_`echo $SHELL_DATE`.sh     #ת���������ݵ��ܵĽű�
TOTAL_ROLL_SHELL=${LOG_PATH}/total_roll_`echo $SHELL_DATE`.sh   #ǰ��ʱ���ܵĽű�
ROLL_OUT=$LOG_PATH/rman_roll_`echo $SHELL_DATE`                 #����ǰ���ű����ļ�����ǰ�沿��
SHELL_OUT=$LOG_PATH/backupset_convert_`echo $SHELL_DATE`        #���ɱ��ݼ�ת���Ľű�����ǰ�沿��
FTP_RUN_LOG_TEMP=${LOG_PATH}/scn_ftp_run_log.                       #����FTP�ϴ�����־�ļ�
FTP_PARALLEL=8
ERROR_FILE_LOG=${LOG_PATH}/scn_error_file_log                   #�����ļ�������ļ�

###############################################################################
# NAME:        display
# ������ʾ��־���� ʱ�� ������ ����
###############################################################################
display()
{
        DE=`date +"%Y-%m-%d %H:%M:%S"`
        printf "%18s %30s : %s\n" "${DE}" "$1" "$2"
}

###############################################################################
# NAME:        display_raw
#
#
###############################################################################
display_raw()
{
if [ "$suppress" -eq "1" ]; then
  return 0
else
  if [ "$suppresst" -eq "0" ]; then
    echo -e "$1"
  fi
  if [ "$suppressl" -eq "0" ]; then
    if [ "$LOG_RUN_ENABLED" -eq "1" ]; then
      echo -e "$1" >> $LOG_RUN_FILE
    fi
  fi
  return 0
fi
}



###############################################################################
# NAME:        chkerr
#
# DESCRIPTION:
#   Check if $1 is non-zero, and if so, output the message supplied in $2 and
#   exit immediately.
#
# INPUT(S):
#   Arguments:
#     $1: status code
#     $2: error message
#
#   Globals:
#     None
#
# RETURN:
#   None
#
###############################################################################
chkerr()
{
if [ "$1" -ne "0" ]; then
  display "chkerr"  "$2"
  echo "1" >> ${ERROR_FILE_LOG}
  exit $1
fi
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
     ls -l ${dir_name} >>/dev/null 2>&1
     chkerr $? "Local ${dir_name} Is Not Exists"
     display "dir_exists" "Local Check Dir $1 Is Exist"
  fi
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
# NAME:        input_err_file
#
# DESCRIPTION:
# �жϴ����ļ��Ƿ�������
###############################################################################
output_err_file()
{
        display "output_err_file" "Output Failed Info Into Error File" "output_err_file"
        echo "faild">>$LOG_ERR_FILE
        chkerr $? "Failed ! Output Failed Info Into Error File"
        display "output_err_file" "Success ! Output Failed Info Into Error File" "output_err_file"
}

###############################################################################
# NAME:        sql_exec
# ִ��SQL�ű�
#
###############################################################################
sql_exec()
{
# write sql string to temporary file
echo "$1" > $LOG_SQL_EXETMP

# execute sql
sql_out=`sqlplus -L -s / as sysdba @${LOG_SQL_EXETMP}`

# save sqlplus return value
l_se_ret=$?
# display offending sql code
if [ "$l_se_ret" -ne "0" ]; then
  display_raw "\n### The following error was encountered:"
  display_raw "$sql_out"
  display_raw "\n### The offending sql code in its entirety:"
  display_raw "$1\n"
  output_err_file
fi
return $l_se_ret
}



sql_exec_script()
{
# write sql string to temporary file
echo "$1" > $LOG_SQL_EXETMP
sql_handle_name=$2
sql_out_file=$3

# execute sql
sql_out=`sqlplus -L -s / as sysdba @${LOG_SQL_EXETMP} ${sql_handle_name} ${sql_out_file}`

# save sqlplus return value
l_se_ret=$?
# display offending sql code
if [ "$l_se_ret" -ne "0" ] && [ "$LOG_SQL_ERRORS" -eq "1" ]; then
  display_raw "\n### The following error was encountered:"
  display_raw "$sql_out"
  display_raw "\n### The offending sql code in its entirety:"
  display_raw "$1\n"
  output_err_file
fi
return $l_se_ret
}
###############################################################################
# NAME:        check_scn_file
# ִ��SQL�ű�
#
###############################################################################

move_scn_file()
{
   if [ -f $CURRENT_SCN ];then
            #�жϵ�ǰSCN�ļ��Ƿ���ڣ�������ڽ����ݣ�����ͬʱCOPYһ�ݵ�OLD SCN�ļ���
            display "check_scn_file" "Scn File Is Exist,And Begin Move Current Scn File To Old Scn File";
            #���ݾ�SCN�ļ�������ʱ����ļ���
            cp $OLD_CURRENT_SCN ${OLD_CURRENT_SCN}_`date +"%Y_%m_%d_%H_%M_%S"`
            chkerr $? "Failed !  Copy Current Scn File To Backup File"
            #���ݵ�OLD SCN�ļ��У�����RMAN��������ʹ��
            mv $CURRENT_SCN $OLD_CURRENT_SCN
            chkerr $? "Failed !  Move Current Scn File To Old Scn File"
        display "chk_err_file" "SUCCESS ! Move Current Scn File To Old Scn File";
     else
       display "check_scn_file" "Scn File Is Not Exist,And Will be Create In check_scn_value";
   fi
}

###############################################################################
# NAME:        get_scn_value
# ִ��SQL�ű�����ִ�б�����������ʱ��SCNֵ���û��´���������ʹ��
#
###############################################################################

get_scn_value()
{
      display "check_scn_value" "Begin Get  Current SCN Value "
      i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      set num 30
      select current_scn from v\$database;
      exit;"
      #ִ��SQL��䣬����������sql_out��
      sql_exec "$i_run_sql"
      chkerr $? "failed to get check_scn_value"
      #��ʵ�Ƿ��ȡ��SCN��ֵ
      i_file_count=`echo $sql_out|wc -l |awk '{print $1}'|awk '{print $1}'`
      if [  "$i_file_count" -eq "0" ];then
           #���sql_out����Ľ��Ϊ0����ѯ��ǰSCNֵʧ��
           display "check_scn_value" "Failed Get  Current SCN Value "
           exit;
      else
      display "get_scn_value" "Current SCN Value :`echo $sql_out`"
      fi
      #����ǰSCN��ֵ������CURRENT_SCN���ļ���
      echo $sql_out > $CURRENT_SCN
      chkerr $? "Failed To Output To $CURRENT_SCN"
}

###############################################################################
# NAME:        get_old_scn_value
# ��ȡ����ִ���������ݵ�SCNֵ��Ҳ�����ϴ�ִ����������ʱ�����ݿ��SCNֵ
#
###############################################################################
get_old_scn_value()
{
         display "get_old_scn_value" "Get Scn From File : $OLD_CURRENT_SCN"
         if [ -f $OLD_CURRENT_SCN ];then
                   OLD_SCN_VALUE=`cat $OLD_CURRENT_SCN`
                   chkerr $? "Failed ! Get Old Scn From File : $OLD_CURRENT_SCN"
                   display "get_old_scn_value" "Old Scn Value is : $OLD_CURRENT_SCN"
         fi
}

###############################################################################
# NAME:        rman_incre_bakcup
# RMANִ����������
#
###############################################################################
rman_incre_bakcup()
{
display "rman_incre_bakcup" "Begin Exec Rman Incremental  Scn Value $OLD_SCN_VALUE"  "rman_incre_bakcup"
rman target / nocatalog  msglog $LOG_RMAN_FILE append  << EOF >/dev/null
run {
allocate channel t1 type disk ;
allocate channel t2 type disk ;
allocate channel t3 type disk ;
allocate channel t4 type disk ;
backup incremental from scn $OLD_SCN_VALUE tablespace $TABLESPACE format='${LOCAL_BACKSET}/%U';
release channel t1;
release channel t2;
release channel t3;
release channel t4;
}
exit;
EOF

# save sqlplus return value
l_se_ret=$?

# display offending sql code
if [ "$l_se_ret" -ne "0" ]; then
         display "rman_incre_bakcup" "Failed ! Begin Exec Rman Incremental  Scn Value $OLD_SCN_VALUE"  "rman_incre_bakcup"
         exit 0
else
   display "rman_incre_bakcup" "Success ! Begin Exec Rman Incremental  Scn Value $OLD_SCN_VALUE"  "rman_incre_bakcup"
fi
}


###############################################################################
# NAME:        sql_recover
# �����ݿ�������ADGģʽ����Ϊ�������ݻ��Զ�ͣ����־����
#
###############################################################################
sql_recover()
{
                i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
               whenever sqlerror exit sql.sqlcode
               recover managed standby database using current logfile disconnect;
               exit;"
      display "get_handle_file" "Query Incremental Handle File Name" "get_handle_file"
      sql_exec "$i_run_sql"
      chkerr $? "Failed ! Recover Managed Standby Datafile"
}

###############################################################################
# NAME:        get_handle_file
# ��ȡ���һ�������������ɵı���Ƭ�����֣�����������sql_spool�ļ���
# ������roll forward��ʱ�򣬻�ʹ�õ�����Ƭ������
###############################################################################
get_handle_file()
{
      i_run_sql="set pagesize 0 lines 2000 long 20000 feedback off verify off heading off echo off tab off timing off
               whenever sqlerror exit sql.sqlcode
         spool ${SQL_SPOOL}
         SELECT DISTINCT d.handle
           FROM v\$backup_piece d, v\$backup_files b
          WHERE     d.tag IN (SELECT tag
                                FROM (SELECT a.tag,
                                             a.handle,
                                             ROW_NUMBER ()
                                                OVER (ORDER BY a.start_time DESC)
                                                rnum
                                        FROM V\$BACKUP_PIECE a, v\$backup_files b
                                       WHERE     a.set_count = B.BS_COUNT
                                             AND A.SET_STAMP = B.BS_STAMP
                                             AND b.file_type = 'DATAFILE')
                               WHERE rnum = 1)
                AND d.set_count = B.BS_COUNT
                AND d.SET_STAMP = B.BS_STAMP
                AND b.file_type = 'DATAFILE' ;
               exit;"
      display "get_handle_file" "Query Incremental Handle File Name" "get_handle_file"
      sql_exec "$i_run_sql"
      #display "get_handle_file : `echo $sql_out`" "get_handle_file"
      i_run_val=`echo $sql_out|wc -l|awk '{print $1}'`
      if [ "$i_run_val" -eq "0" ];then
        display "get_handle_file" "Success Get Hanle File Number but Not Any Hanle File" "get_handle_file"
          exit 0
      else
        echo $sql_out > $HANDLE_FILE
      fi
}

###############################################################################
# NAME:        convert_backupset
# ����ת�����ݼ��Ľű�����AIX�ı��ݼ�ת����LINUX
#
###############################################################################
convert_backupset()
{
        echo "sqlplus / as sysdba <<EOF" >>$2
  echo "set timing on">>$2
  echo "set time on">>$2
  echo "DECLARE">>$2
  echo " handle    varchar2(512);">>$2
  echo " comment   varchar2(80);">>$2
  echo " media     varchar2(80);">>$2
  echo " concur    boolean;">>$2
  echo " recid     number;">>$2
  echo " stamp     number;">>$2
  echo " pltfrmfr number;">>$2
  echo " devtype   VARCHAR2(512);">>$2
  echo "BEGIN">>$2
  echo "   sys.dbms_backup_restore.restoreCancel(TRUE);">>$2
  echo "   devtype := sys.dbms_backup_restore.deviceAllocate;">>$2
  echo "   sys.dbms_backup_restore.backupBackupPiece(bpname => '${1}',fname => '${1}.bak',handle => handle,media=> media,comment=> comment, concur=> concur,recid=> recid,stamp => stamp, check_logical => FALSE,copyno=> 1, deffmt=> 0, copy_recid=> 0,copy_stamp => 0,npieces=> 1,dest=> 0,pltfrmfr=> 6);">>$2
  echo "END;">>$2
  echo "/">>$2
  echo "exit">>$2
  echo "EOF ">>$2
}

###############################################################################
# NAME:        for_hangle_file
# ��SQL_SPOOL�ж�ȡ����Ƭ�����֣�����convert_backupset����ת������Ƭ�Ľű���
# ���ѽű����ɵ�Զ�˷���������������ܵ�total�ű����ϴ���Զ�˷�����
###############################################################################
for_hangle_file()
{
        display "for_hangle_file" "Open Handle File : $SQL_SPOOL " "for_hangle_file"
        i_number=0
        for backupset_filename in $(cat $SQL_SPOOL)
        #while read backupset_filename
        do
           display "convert_backupset" "******************************************************************************"
           display "convert_backupset" "Begin ! Create Backupset Convert Shell $backupset_filename" "convert_backupset"
           i_number=$(($i_number+1))
           #����ÿ������Ƭ���ɵ�ת���ű�·����
           shell_out_file=${SHELL_OUT}_`echo $i_number`.sh
           #����ÿ������Ƭ���ɵ�ת���ļ���
           shell_filename=backupset_convert_`echo $SHELL_DATE`_`echo $i_number`.sh
           display "convert_backupset" "Begin ! Script name is : $shell_out_file" "convert_backupset"
           #����convert_backupset�������ɽű�����
           convert_backupset $backupset_filename $shell_out_file
           display "convert_backupset" "Success !Create Backupset Convert Shell $backupset_filename" "convert_backupset"
           #ʹ��ftp���ű��ϴ���Զ�˷�����
           ftp_file ${LOG_PATH} ${REMOTE_SHELL_HOME} ${shell_filename} >>/dev/null 2>&1
           #���FTP�Ƿ��б�������б�����쳣�˳�
           check_ftp_error_file ${REMOTE_SHELL_HOME} ${roll_out_filename}
           display "convert_backupset" "Begin ! Output Covenrt Scripts Into ${LOG_PATH}/${TOTAL_CONVERT_FILENAME}" "convert_backupset"
           #��ÿһ������Ƭ�Ľű�������ܵı���Ƭת���ű���
           echo "nohup sh ${REMOTE_SHELL_HOME}/${shell_filename} 2>&1 >${REMOTE_SHELL_HOME}/${shell_filename}.log &" >>${LOG_PATH}/${TOTAL_CONVERT_FILENAME}
           chkerr $? "Failed ! Recover Managed Standby Datafile"
           display "convert_backupset" "Success ! Output Covenrt Scripts Into ${LOG_PATH}/${TOTAL_CONVERT_FILENAME}" "convert_backupset"
        #done < $SQL_SPOOL
       done
        ftp_file ${LOG_PATH} ${REMOTE_SHELL_HOME} ${TOTAL_CONVERT_FILENAME}  >>/dev/null 2>&1
        check_ftp_error_file ${REMOTE_SHELL_HOME} ${TOTAL_CONVERT_FILENAME}
}

###############################################################################
# NAME:        put_hangle_file
# ����������Ƭ�������ϴ���Ŀ��˷�����
#
###############################################################################
put_hangle_file()
{

        i_number=0
        for backupset_filename in $(cat $SQL_SPOOL)
        do

           i_number++
           display "put_hangle_file" "******************************************************************************"
           data_file_name=`echo  ${backupset_filename}|awk -F  '/' '{print $NF}'`
           display "put_hangle_file" "Begin Put Handle File :${data_file_name} into  $REMOTE_BACKSET  parallel Number :$i_number" "put_hangle_file"
           ftp_file_parallel $LOCAL_BACKSET $REMOTE_BACKSET ${data_file_name} ${i_number}>>/dev/null 2>&1
           check_ftp_error_file_parallel $REMOTE_BACKSET ${data_file_name} ${i_number}
           display "put_hangle_file" "Success ! Put Handle File :${data_file_name} into  $REMOTE_BACKSET parallel Number :$i_number" "put_hangle_file"
           while (( $i_number >= $FTP_PARALLEL))
             {
              sleep 10S;
              i_number=`ps -ef|grep ftp|grep $IP_ADDR|grep -v grep|wc -l`
              display "put_hangle_file" "Now,Number ${i_number} is Working;" "put_hangle_file"
             }
        done
}

ftp_file()
{
ftp -i -n $IP_ADDR <<EOF >$FTP_RUN_LOG
   user oracle "oracle"
   bin
   prom
   lcd $1
   cd $2
   put $3
   bye
EOF
}

ftp_file_parallel()
{
  $FTP_RUN_LOG =$FTP_RUN_LOG_TEMP_${4}.log
ftp -i -n $IP_ADDR <<EOF >$FTP_RUN_LOG
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
# NAME:        check_ftp_error_file
# �û����ftp�Ƿ��д�����Ϣ���
#
###############################################################################

check_ftp_error_file_parallel()
{
  #���FTP��־�ļ��Ƿ�������ı���
  $FTP_RUN_LOG =$FTP_RUN_LOG_TEMP_${3}.log
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

rman_rollback_incre()
{
  i_run_sql="set pagesize 0 lines 2000 long 20000 feedback off verify off heading off echo off tab off timing off  serveroutput on size 1000000  format wrapped
               whenever sqlerror exit sql.sqlcode
    spool &2
    DECLARE
BEGIN
      DBMS_OUTPUT.put_line ('sqlplus / as sysdba <<EOF');
      DBMS_OUTPUT.put_line ('set timing on');
      DBMS_OUTPUT.put_line ('set time on');
      DBMS_OUTPUT.put_line ('set serveroutput on;');
      DBMS_OUTPUT.put_line ('DECLARE');
      DBMS_OUTPUT.put_line ('  outhandle varchar2(512) ;');
      DBMS_OUTPUT.put_line ('  outtag varchar2(30) ;');
      DBMS_OUTPUT.put_line ('  done boolean ;');
      DBMS_OUTPUT.put_line ('  failover boolean ;');
      DBMS_OUTPUT.put_line ('  devtype VARCHAR2(512);');
      DBMS_OUTPUT.put_line ('BEGIN');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  Entering RollForward'');');
      DBMS_OUTPUT.put_line (
         '  devtype := sys.dbms_backup_restore.deviceAllocate;');
      DBMS_OUTPUT.put_line (
         '  sys.dbms_backup_restore.applySetDatafile(check_logical => FALSE, cleanup => FALSE) ;');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  After applySetDataFile'');');
      DBMS_OUTPUT.put_line (' ');

      FOR i_file_cursor
         IN (SELECT a.df_file# df_file,
                       '+$ASM_DISKGROUP/'
                    || '$DB_UNIQUE_NAME'
                    || '/datafile/'
                    || SUBSTR (a.fname,
                       INSTR (a.fname,
                           '/',
                           1,
                           LENGTH (REGEXP_REPLACE (a.fname, '[^/]+', '')))
                         + 1)
                       fname
               FROM v\$backup_files a, v\$backup_piece b
              WHERE     a.bs_count = b.set_count
                    AND a.bs_stamp = b.SET_STAMP
                    AND b.handle = '&&1'
                    AND a.file_type = 'DATAFILE')
      LOOP
         DBMS_OUTPUT.put_line (
               '    sys.dbms_backup_restore.applyDatafileTo(dfnumber =>   '
            || i_file_cursor.df_file
            || ' ,toname => '''
            || i_file_cursor.fname
            || ''',fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0,recid => 0, stamp => 0);');
      END LOOP;

      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (
            '  sys.dbms_backup_restore.restoreSetPiece(handle => '''
         || '&&1'
         || '.bak'
         || ''',tag => null, fromdisk => true, recid => 0, stamp => 0) ;');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  Done: RestoreSetPiece'');');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (
         '  sys.dbms_backup_restore.restoreBackupPiece(done => done, params => null, outhandle => outhandle,outtag => outtag, failover => failover);');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''Done: RestoreBackupPiece'');');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line ('  sys.dbms_backup_restore.restoreCancel(TRUE);');
      DBMS_OUTPUT.put_line ('  sys.dbms_backup_restore.deviceDeallocate;');
      DBMS_OUTPUT.put_line ('  END;');
      DBMS_OUTPUT.put_line ('  /');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line ('exit');
      DBMS_OUTPUT.put_line ('EOF');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
END;
/
spool off
exit;"
sql_exec_script "$i_run_sql"   "$1" "$2"
chkerr $? "Failed ! Exec rman_rollback_incre Backset $1 And Outfile Name $2"
}

rman_roll_script()
{
        display "for_hangle_file" "Open Handle File : $HANDLE_FILE " "for_hangle_file"
        i_number=0
        for backupset_filename in $(cat $SQL_SPOOL)
        do
                display "rman_roll_script" "******************************************************************************"
                display "rman_roll_script" "Begin ! Create Backupset Roll Shell $backupset_filename" "rman_roll_script"
                i_number=$(($i_number+1))
                #ǰ���ű���·����
        roll_out_file=${ROLL_OUT}_`echo $i_number`.sh
        #ǰ���ű����ļ���
        #roll_out_filename=rman_roll_`echo $SHELL_DATE`_`echo $i_number`.sh
        roll_out_filename=`echo  ${roll_out_file}|awk -F  '/' '{print $NF}'`
        display "rman_roll_script" "Begin ! Script name is : $ROLL_OUT_file" "rman_roll_script"
        #����rman_rollback_incr����ǰ����־
        rman_rollback_incre $backupset_filename $roll_out_file
        display "convert_backupset" "Success !Create Backupset Roll Shell $backupset_filename" "convert_backupset"
        #�ϴ�ǰ���ű���Ŀ�������
        ftp_file ${LOG_PATH} ${REMOTE_SHELL_HOME} ${roll_out_filename} >>/dev/null 2>&1
        #���FTP��־���ϴ��ļ��Ƿ���Զ������
        check_ftp_error_file ${REMOTE_SHELL_HOME} ${roll_out_filename}
        display "rman_roll_script" "Begin ! Output Roll Scripts Into ${TOTAL_ROLL_SHELL}" "rman_roll_script"
        #��ǰ���ű�д�뵽�ܵ�ǰ���ű���ȥ
        echo "nohup sh ${REMOTE_SHELL_HOME}/${roll_out_filename} 2>&1 >${REMOTE_SHELL_HOME}/${roll_out_filename}.log &" >>$TOTAL_ROLL_SHELL
        chkerr $? "Failed ! Output Roll Scripts Into ${TOTAL_ROLL_SHELL}"
        display "rman_roll_script" "Success !  Output Roll Scripts Into ${TOTAL_ROLL_SHELL}" "rman_roll_script"
        done
                total_roll_shell_file_name=`echo  ${TOTAL_ROLL_SHELL}|awk -F  '/' '{print $NF}'`
                ftp_file ${LOG_PATH} ${REMOTE_SHELL_HOME} ${total_roll_shell_file_name} >>/dev/null 2>&1
                check_ftp_error_file ${REMOTE_SHELL_HOME} ${total_roll_shell_file_name}

}
total()
{
        ping_test
        ssh_test
        dir_exists ${LOCAL_BACKSET}
        dir_exists ${REMOTE_BACKSET} 'R'
        dir_exists ${REMOTE_SHELL_HOME} 'R'
        file_exists ${OLD_CURRENT_SCN}
        get_old_scn_value
        get_scn_value
        rman_incre_bakcup
        sql_recover
        move_scn_file
        get_handle_file
        put_hangle_file
        for_hangle_file
        rman_roll_script
}

total