#!/bin/bash
#�˽ű���������Ҫ������VXFS�����У����ݿ��ԭ����9I����ֱ��������10G���ϵİ汾����ʹ��DG���������ģ�����
#9I��û��ODM�����������ļ���VXFS�д�����Ƭ����Ҫ��10G���ϻ�����ͨ��rman copy����������ODM���������ļ���
#���������AIX�Ѿ�������������LINUX 5.11,SF5.1ģ���ʱ��EXTENT��32M,������û�ж���Ӱ��
#��ʵ��9i�����ݻ�ԭ��VXFS������ʱ�����ǽ�����VXFS�ļ�ϵͳ����initial_extent_size��max_seqio_extent_size
#�����������ﵽ�ֶ�ָ��VXFS���Ĵ�С��
#fsmap���fsadm����
#��SF 5.1�Ժ����ͨ��fsadm������������֯�ļ�
#��ͬ����ִ�е�ʱ����Ҫ�滻db_file_name_convert�������
#ִ�нű���ʱ����Ҫ����������Ѿ��е�COPY�������ļ�����Ȼ���ܳ����ļ��Ѿ����ڵı���
#�ű��ǰ�/data01/oradata/�е��ļ����ݵ�/data02/oradata,/data14 copy��/data01���Դ�����
LOG_RUN_ENABLED=1                          
LOG_RUN_FILE=file_run_`echo $1`.log
LOG_RMAN_FILE=rman_run_`echo $1`.log
LOG_SQL_ERRORS=1    
LOG_UNSUPP_FILE=SQL_POOL_`echo $1`.log                   
LOG_SQL_EXETMP=SQL_EXETMP_`echo $1`.sql 
LOG_ERR_FILE=err_file.log 
stage=0                                 
task=0                                                          
groupid=$1
fildid=0
###############################################################################
# NAME:        display
# ������ʾ��־���� ʱ�� ������ ����
###############################################################################
display()
{
        DE=`date +"%Y-%m-%d %H:%M:%S"`
        printf "%18s %30s : %s\n" "${DE}" "$2" "$1"
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
  fail "$2"
  #��ʧ�ܵ��ļ����������ݣ��������������ж������Ľ����Ƿ����쳣������쳣���˳���ǰ���̡�
  output_err_file
  exit $1
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
        display "Output Failed Info Into Error File" "output_err_file"
        echo "faild">>$LOG_ERR_FILE
        display "Success ! Output Failed Info Into Error File" "output_err_file"
}

###############################################################################
# NAME:        _err_file
#
# DESCRIPTION: 
# �жϴ����ļ��Ƿ�������
###############################################################################
chk_err_file()
{
   if [ -f $LOG_ERR_FILE ];then
     if [ `wc -l $LOG_ERR_FILE |awk '{print $1}'` -gt 0 ];then
        display "Error File Is Not Empty,One Session is Abort" "chk_err_file";
      exit 0
     fi
   fi
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
# NAME:        rman_exec
###############################################################################
rman_exec()
{
i_fileid=$1
rman target / nocatalog  msglog $LOG_RMAN_FILE append  << EOF
run {
allocate channel d1 type disk;
allocate channel d2 type disk;
allocate channel d3 type disk;
allocate channel d4 type disk;
backup as copy db_file_name_convert('/data01/oradata/','/data02/oradata/','/data02/oradata/','/data03/oradata/','/data03/oradata/','/data04/oradata/','/data04/oradata/','/data05/oradata/','/data05/oradata/','/data06/oradata/','/data06/oradata/','/data07/oradata/','/data07/oradata/','/data08/oradata/','/data08/oradata/','/data09/oradata/','/data09/oradata/','/data10/oradata/','/data10/oradata/','/data11/oradata/','/data11/oradata/','/data12/oradata/','/data12/oradata/','/data13/oradata/','/data13/oradata/','/data14/oradata/','/data14/oradata/','/data01/oradata/') datafile $i_fileid;
release channel d1;
release channel d2;
release channel d3;
release channel d4;
}
exit;
EOF

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
# NAME:        rman_swith_datafile
# �����л������ļ���֮ǰ��COPY�������ļ���������Ҫ�����ļ���offline��״̬
# ������ҪOFFLINE�ɹ��󣬲ſ����л�
###############################################################################
rman_switch_datafile()
{
i_fileid=$1
rman target / nocatalog  msglog $LOG_RMAN_FILE append  << EOF
switch datafile $i_fileid to copy;
exit;
EOF

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
# NAME:        rman_delete_datafile
# ����ɾ��COPY�������ļ���ֻҪ������������ʱ��Ż�ɾ��
###############################################################################
rman_delete_datafile()
{
i_fileid=$1
rman target / nocatalog  msglog $LOG_RMAN_FILE append << EOF
run {
allocate channel d1 type disk;
delete noprompt  copy of datafile $i_fileid;
release channel d1;
}
exit;
EOF

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
# NAME:        db_create_htz_dbfile_table
#
# DESCRIPTION: 
#   ��SYSTEM�û����洴��htz_dbfile�����ڴ����ҪǨ�Ƶ������ļ� 
#
###############################################################################
db_create_htz_dbfile_table()
{
# ���� htz_dbfile�����ڴ����ҪǨ�Ƶ������ļ�����Ǩ�������ļ���״̬
i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from dba_tables where owner='SYSTEM' and table_name='HTZ_DBFILE';
      exit;"
display "Query Table : system.htz_dbfile is whether or not exists" "db_create_htz_dbfile_table"
sql_exec "$i_run_sql"
# �ж�HTZ_DBFILE���Ƿ���ڣ���������ڣ��Զ�������
i_run_val=`echo $sql_out`
display "Begin Exec db_create_htz_dbfile_table"
if [ "$i_run_val" = "0" ]; then
      #echo "11111111111111111111111111111111111111111111111111"
      display "Create Table : system.htz_dbfile On Owner : system" "db_create_htz_dbfile_table"
      i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off 
      whenever sqlerror exit sql.sqlcode 
      create table system.htz_dbfile (group_id number,file_id number,file_name varchar2(100),file_status varchar2(100),ddate varchar2(20));
      insert into system.htz_dbfile(group_id,file_id,file_name,file_status) 
      select mod(substr(file_name, 6, 2), 6) + 1,file_id, file_name, 'CREATED'
       from dba_data_files
      where tablespace_name in
            (select tablespace_name
               from dba_tablespaces
              where CONTENTS = 'PERMANENT')
        and file_id in
            (select file#
               from v\$datafile
              where creation_time < to_date('2019-12-01', 'yyyy-mm-dd'))
        and tablespace_name not in ('SYSTEM', 'SYSAUX', 'USERS');
      exit;"
     sql_exec "$i_run_sql"
     chkerr $? "Failed to Create Table : system.htz_dbfile" 
     display "Succeed ! Create Table : system.htz_dbfile."   "db_create_htz_dbfile_table"
fi
display "End Exec db_create_htz_dbfile_table"
}
###############################################################################
# NAME:        get_group_id
#
# DESCRIPTION: 
#  �����ж������GROUPID��SYSTEM.HTZ_DBFILE���Ƿ���ڣ�������ڼ��������������������ڣ����Ƴ�
#
###############################################################################
get_group_id()
{
      display "Begin Exec get_group_id "  "get_group_id"
      i_groupid=$1
      i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where  group_id=$groupid and rownum<2;
      exit;"
      sql_exec "$i_run_sql"
      #echo "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
      chkerr $? "failed to get file_id" 
      i_file_count=`echo $sql_out`
      #���count(*)���ص�ֵ����0���ʹ���GROUP���ڣ��������0�����Ƴ�
      if [  "$i_file_count" -eq "0" ];then
           display "****GROUP_ID $groupid Is Not Exists,Please Input right Group Id****" "get_group_id"
           exit;
      fi
      
}
###############################################################################
# NAME:        get_file_id
#
# DESCRIPTION: 
#   ��ȡ��ǰ��Ҫ�������ļ���ID�� 
#
###############################################################################
get_file_id()
{
      #�������ж��Ƿ񻹴���û��Ǩ�Ƶ������ļ���������ڿ�ʼ����ִ��COPY������
      i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "failed to get file_id" 
      i_file_count=`echo $sql_out`
      #���count(*)���ص�ֵ����0���ʹ�������ҪCOPY�������ļ�
      
      if [  "$i_file_count" -gt "0" ];then
           i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
           whenever sqlerror exit sql.sqlcode 
           select file_id from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
           exit;"
           sql_exec "$i_run_sql"
           chkerr $? "failed to get file_id" 
           #����ҪCOPY�������ļ���FILE_ID���Ƹ�fileid���������
           fileid=`echo $sql_out` 
           #echo $fileid
           
           display "Get File Id Is $fileid" "get_file_id"
      else
           display "****GROUP_ID $groupid All Datafile Copy  Finish****" "get_file_id"
           exit;
      fi
      
}
###############################################################################
# NAME:        update_htz_dbfile_status
#
# DESCRIPTION: 
#   ��system.htz_dbfile���и����ļ���״̬��ÿһ��������������ļ���״̬ 
###############################################################################
update_htz_dbfile_status()
{
         i_file_id=$1
         i_file_status=$2
         i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      update system.htz_dbfile a set a.file_status='$i_file_status' where a.group_id=$groupid and a.file_id=$i_file_id;
      exit;"
   display "Begin Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status" "update_htz_dbfile_status"
   sql_exec "$i_run_sql"
   chkerr $? "Failed ! Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status $i_file_status"  
   display "Succeed ! Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status" "update_htz_dbfile_status"
}
###############################################################################
# NAME:        copy_datafile
#
# DESCRIPTION: 
#   ʹ��RMAN����COPY�����ļ�����Ӧ��·�� 
###############################################################################
copy_datafile()
{
  i_file_id=$1
  display "Begin Backup Datafile $i_file_id" "copy_datafile"
  rman_exec "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  #echo "_______________________________________________________________"
  #echo $l_last_set
  #echo "_______________________________________________________________"
  if [ "$l_last_set" -eq "0" ];then
  display "Succeed !  Backup Datafile $i_file_id" "copy_datafile"
  else
  update_htz_dbfile_status "$i_file_id" "CREATED"
  exit
  fi
}


###############################################################################
# NAME:        off_datafile
#
# DESCRIPTION: 
#   ��copy_datafile�ɹ��������ļ�OFFLINE 
###############################################################################
off_datafile()
{
        i_file_id=$1
        update_htz_dbfile_status "$i_file_id" "OFFLINE"
        i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      alter database datafile $i_file_id offline;
      exit;"
  display "Begin Offline Datafile $i_file_id" "off_datafile"
  sql_exec "$i_run_sql"
  chkerr $? "failed to offline datafile $i_file_id"
  display "Succeed ! Offline Datafile $i_file_id" "off_datafile"   
}
###############################################################################
# NAME:        switch_datafile
#
# DESCRIPTION: 
#   ʹ��RMAN ��switch datafile to copy��ִ�� 
###############################################################################

switch_datafile()
{
        i_file_id=$1
        update_htz_dbfile_status "$i_file_id" "SWITCH"
        display "Begin Switch Datafile $i_file_id to Copy" "switch_datafile"
        rman_switch_datafile "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  if [ "$l_last_set" -eq "0" ];then
  display "Succeed ! Switch Datafile $i_file_id to Copy" "switch_datafile"
  else
  #���switchʧ�ܺ󣬻��Զ���ԭ���������ļ�ONLINE��
  online_datafile "$i_file_id" 
  fi
}

online_datafile()
{
        i_file_id=$1
        update_htz_dbfile_status "$i_file_id" "ONLINE"
        i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      recover datafile $i_file_id;
      alter database datafile $i_file_id online;
      exit;"
  display "Bgein Online Datafile $i_file_id" "online_datafile"
  sql_exec "$i_run_sql"
  chkerr $? "Failed ! Online Datafile $i_file_id"
  display "Succeed ! Online Datafile $i_file_id" "online_datafile"   
}

delete_datafile()
{
        i_file_id=$1
        update_htz_dbfile_status "$i_file_id" "DELETE"
        i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      select count(*) from v\$datafile where file#=$i_file_id and (status not in ('ONLINE') or name in (select file_name from system.htz_dbfile where file_id=$i_file_id));
      exit;"
  display "query datafile $i_file_id status and file name ,if name not change and status not online ,exit shell" "delete_datafile"
  sql_exec "$i_run_sql"
  chkerr $? "query datafile $i_file_id status and file name" 
  #echo "-----------------------------------------------------------"
  #echo $i_count
  #echo "-----------------------------------------------------------"
  i_count=`echo $sql_out`
  if [ "$i_count" -gt "0" ];then
        display "Datafile $i_file_id Status  not Online or File Name not change" "delete_datafile"
  else
    display "Begin Delete Copy Datafile $i_file_id" "delete_datafile"
    rman_delete_datafile "$i_file_id" >/dev/null
    chkerr $? "Failed ! Delete Copy Datafile $i_file_id"
    display "Succeed ! Begin Delete Copy Datafile $i_file_id" "delete_datafile" 
    update_htz_dbfile_status "$i_file_id" "FINISH"
  fi    
}

show_switch_datafile()
{
        i_run_sql="set pagesize 0 lines 200 feedback off verify off heading off echo off tab off timing off
            col file_name for a50
            col name for a50
            col file_status for a10
            col status for a10
            col group_id for 999 heading 'GID'
            col file_id for 9999 heading 'FID'
            spool $LOG_UNSUPP_FILE
            select lpad('ID',2,0)||'.'||lpad('FID',4,0)||'.'||rpad('OLD_NAME',40)||'.'||rpad('CURRENT_NAME',40)||'.'||rpad('MIG_STATUS',10)||'.'||rpad('CUR_STATUS',10) from dual
            union all
            select lpad(a.group_id,2,0)||'.'||lpad(a.file_id,4,0)||'.'||rpad(a.file_name,40)||'.'||rpad(b.name,40)||'.'||rpad(a.file_status,10)||'.'||rpad(b.status,10) from system.htz_dbfile a ,v\$datafile b where a.file_id=b.file# and a.file_status in ('FINISH')  and a.group_id=$groupid;
            spool off;
            exit;"
  display "Query Finished Datafile Info" "show_switch_datafile"
  sql_exec "$i_run_sql"
  chkerr $? "Failed !  Query Finished Datafile Info"   
  #cat  $LOG_UNSUPP_FILE

  while read i_line
  do
        display "$i_line" "show_switch_datafile"
  done < $LOG_UNSUPP_FILE
  display "Finish ! Show Spool Off File" "show_switch_datafile"
  display "Delete Spool Off File" "show_switch_datafile"
  rm -rf $LOG_UNSUPP_FILE
  #if [ "$i_count" -gt "0" ];then
  #     display "Datafile $i_file_id Status  not Online or File Name not change" "$FUNCNAME"
  #else
  #  display "Begin Delete Copy Datafile $i_file_id" "$FUNCNAME"
  #  rman_delete_datafile "$i_file_id" >/dev/null
  #  chkerr $? "Failed ! Delete Copy Datafile $i_file_id"
  #  display "Succeed ! Begin Delete Copy Datafile $i_file_id" "$FUNCNAME" 
  #  update_htz_dbfile_status "$i_file_id" "FINISH"
  #fi   
}

db_create_htz_dbfile_table
#echo "222222222222222222222222222222222222222222222222"
chk_err_file
#echo "333333333333333333333333333333333333333333333333"
all_exec()
{
      display "Begin Exec all_exec " "all_exec"
      get_group_id "$groupid"
      #echo "12312312321313"
      i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "Failed Query  File Id" 
      i_fileid_count=`echo $sql_out`
      #echo "------------------------------"
      if [  "$i_fileid_count" -eq "0" ];then
           display "****GROUP_ID $groupid all finish****" "all_exec"   
           show_switch_datafile
           exit;
      else
          i_count_file_id=1
        while [ ${i_count_file_id} -le ${i_fileid_count} ]
          do 
          display "                                                                        " "all_exec"
          display "************************************************************************" "all_exec"
          chk_err_file
          get_file_id
          update_htz_dbfile_status "$fileid" "COPYING"
          copy_datafile $fileid
          off_datafile "$fileid"
          switch_datafile "$fileid"
          online_datafile "$fileid"
          delete_datafile "$fileid"
          display "************************************************************************" "all_exec"
          let i_count_file_id+=1;
          done
          display "****GROUP_ID $groupid all finish****" "all_exec"
          show_switch_datafile
      fi    
}

all_exec