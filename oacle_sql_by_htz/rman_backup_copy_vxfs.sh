#!/bin/bash
#此脚本的作用主要用于在VXFS环境中，数据库从原来的9I环境直接升级到10G以上的版本或者使用DG方案升级的，由于
#9I中没有ODM，所以数据文件在VXFS中存在碎片，需要在10G以上环境中通过rman copy命令来条用ODM重新数据文件。
#这个现象在AIX已经遇到，但是在LINUX 5.11,SF5.1模拟的时候EXTENT是32M,对性能没有多少影响
#其实在9i的数据还原到VXFS环境的时候，我们建议在VXFS文件系统配置initial_extent_size，max_seqio_extent_size
#两个参数来达到手动指定VXFS区的大小。
#fsmap命令，fsadm命令
#在SF 5.1以后可以通过fsadm命令在线重组织文件
#不同环境执行的时候需要替换db_file_name_convert这个参数

LOG_RUN_ENABLED=1                          
LOG_RUN_FILE=file_run_`echo $1`.log
LOG_RMAN_FILE=rman_run_`echo $1`.log
LOG_SQL_ERRORS=1                       
LOG_SQL_EXETMP=SQL_EXETMP_`echo $1`.sql  
stage=0                                 
task=0                                 
suppress=0                             
suppresst=0                           
suppressl=0                          
groupid=$1
fildid=0
###############################################################################
# NAME:        display
# 用于显示日志内容 时间 函数名 内容
###############################################################################
display()
{
	DE=`date +"%Y-%m-%d %H:%M:%S"`
	printf "%18s %30s : %s\n" "${DE}" "$2" "$1"
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
  fail "$2"
  exit $1
fi
}

###############################################################################
# NAME:        sql_exec
# 执行SQL脚本
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
backup as copy db_file_name_convert('/oracle/htz1/','/oracle/htz2/','/oracle/htz2/','/oracle/htz3/','/oracle/htz3/','/oracle/htz4/','/oracle/htz4/','/oracle/htz5/','/oracle/htz5/','/oracle/htz6/','/oracle/htz6/','/oracle/htz7/','/oracle/htz7/','/oracle/htz8/','/oracle/htz8/','/oracle/htz9/','/oracle/htz9/','/oracle/htz10/','/oracle/htz10/','/oracle/htz1/') datafile $i_fileid;
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
fi

return $l_se_ret
}

###############################################################################
# NAME:        rman_swith_datafile
# 用于切换数据文件到之前的COPY的数据文件，但是需要数据文件是offline的状态
# 所以需要OFFLINE成功后，才可以切换
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
fi

return $l_se_ret
}

###############################################################################
# NAME:        rman_delete_datafile
# 用于删除COPY的数据文件，只要在满足条件的时候才会删除
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
fi

return $l_se_ret
}
###############################################################################
# NAME:        db_create_htz_dbfile_table
#
# DESCRIPTION: 
#   在SYSTEM用户下面创建htz_dbfile表，用于存放需要迁移的数据文件 
#
###############################################################################
db_create_htz_dbfile_table()
{
# 创建 htz_dbfile表，用于存放需要迁移的数据文件，与迁移数据文件的状态
i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from dba_tables where owner='SYSTEM' and table_name='HTZ_DBFILE';
      exit;"
display "Query Table : system.htz_dbfile is exists" "$FUNCNAME"
sql_exec "$i_run_sql"
# 判断HTZ_DBFILE表是否存在，如果不存在，自动创建表
i_run_val=`echo $sql_out`
if [ "$i_run_val" = "0" ]; then
		display "Create Table : system.htz_dbfile On Owner : system" "$FUNCNAME"
		i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off 
      whenever sqlerror exit sql.sqlcode 
      create table system.htz_dbfile (group_id number,file_id number,file_name varchar2(100),file_status varchar2(100),ddate varchar2(20));
      insert into system.htz_dbfile(group_id,file_id,file_name,file_status) select mod(file_id,6)+1,file_id,file_name,'CREATED' from dba_data_files where tablespace_name  in (select tablespace_name from dba_tablespaces where CONTENTS='PERMANENT') and tablespace_name not in ('SYSTEM','SYSAUX','USERS');
      exit;"
     sql_exec "$i_run_sql"
     chkerr $? "Failed to Create Table : system.htz_dbfile" 
     display "Succeed ! Create Table : system.htz_dbfile."   "$FUNCNAME"
fi
}
###############################################################################
# NAME:        get_group_id
#
# DESCRIPTION: 
#  用于判断输入的GROUPID在SYSTEM.HTZ_DBFILE中是否存在，如果存在继续下面操作，如果不存在，则推出
#
###############################################################################
get_group_id()
{
			i_groupid=$1
	    i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where  group_id=$groupid and rownum<2;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "failed to get file_id" 
      i_file_count=`echo $sql_out`
      #如果count(*)换回的值大于0，就代表GROUP存在，如果等于0，则推出
      
      if [  "$i_file_count" -eq "0" ];then
      	   display "****GROUP_ID $groupid Is Not Exists,Please Input right Group Id****" "$FUNCNAME"
      	   exit;
      fi
      
}
###############################################################################
# NAME:        get_file_id
#
# DESCRIPTION: 
#   获取当前需要操作的文件的ID号 
#
###############################################################################
get_file_id()
{
			#这里先判断是否还存在没有迁移的数据文件，如果存在开始继续执行COPY操作。
	    i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "failed to get file_id" 
      i_file_count=`echo $sql_out`
      #如果count(*)换回的值大于0，就代表还有需要COPY的数据文件
      
      if [  "$i_file_count" -gt "0" ];then
           i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
           whenever sqlerror exit sql.sqlcode 
           select file_id from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
           exit;"
           sql_exec "$i_run_sql"
           chkerr $? "failed to get file_id" 
           #将需要COPY的数据文件的FILE_ID复制给fileid这个变量。
           fileid=`echo $sql_out` 
      	   #echo $fileid
      	   
           display "Get File Id Is $fileid" "$FUNCNAME"
      else
      	   display "****GROUP_ID $groupid All Datafile Copy  Finish****" "$FUNCNAME"
      	   exit;
      fi
      
}
###############################################################################
# NAME:        update_htz_dbfile_status
#
# DESCRIPTION: 
#   在system.htz_dbfile表中更新文件的状态，每一步操作都会更新文件的状态 
###############################################################################
update_htz_dbfile_status()
{
	 i_file_id=$1
	 i_file_status=$2
	 i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      update system.htz_dbfile a set a.file_status='$i_file_status' where a.group_id=$groupid and a.file_id=$i_file_id;
      exit;"
   display "Begin Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status" "$FUNCNAME"
   sql_exec "$i_run_sql"
   chkerr $? "Failed ! Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status $i_file_status"  
   display "Succeed ! Update Groupid $groupid and FILE Id $i_file_id File Status $i_file_status" "$FUNCNAME"
}
###############################################################################
# NAME:        copy_datafile
#
# DESCRIPTION: 
#   使用RMAN命令COPY数据文件到相应的路径 
###############################################################################
copy_datafile()
{
  i_file_id=$1
  display "Begin Backup Datafile $i_file_id" "$FUNCNAME"
  rman_exec "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  #echo "_______________________________________________________________"
  #echo $l_last_set
  #echo "_______________________________________________________________"
  if [ "$l_last_set" -eq "0" ];then
  display "Succeed !  Backup Datafile $i_file_id" "$FUNCNAME"
  else
  update_htz_dbfile_status "$i_file_id" "CREATED"
  exit
  fi
}


###############################################################################
# NAME:        off_datafile
#
# DESCRIPTION: 
#   将copy_datafile成功的数据文件OFFLINE 
###############################################################################
off_datafile()
{
	i_file_id=$1
	update_htz_dbfile_status "$i_file_id" "OFFLINE"
	i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      alter database datafile $i_file_id offline;
      exit;"
  display "Begin Offline Datafile $i_file_id" "$FUNCNAME"
  sql_exec "$i_run_sql"
  chkerr $? "failed to offline datafile $i_file_id"
  display "Succeed ! Offline Datafile $i_file_id" "$FUNCNAME"   
}
###############################################################################
# NAME:        switch_datafile
#
# DESCRIPTION: 
#   使用RMAN 的switch datafile to copy来执行 
###############################################################################

switch_datafile()
{
	i_file_id=$1
	update_htz_dbfile_status "$i_file_id" "SWITCH"
	display "Begin Switch Datafile $i_file_id to Copy" "$FUNCNAME"
	rman_switch_datafile "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  if [ "$l_last_set" -eq "0" ];then
  display "Succeed ! Switch Datafile $i_file_id to Copy" "$FUNCNAME"
  else
  #如果switch失败后，会自动将原来的数据文件ONLINE的
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
  display "Bgein Online Datafile $i_file_id" "$FUNCNAME"
  sql_exec "$i_run_sql"
  chkerr $? "Failed ! Online Datafile $i_file_id"
  display "Succeed ! Online Datafile $i_file_id" "$FUNCNAME"   
}

delete_datafile()
{
	i_file_id=$1
	update_htz_dbfile_status "$i_file_id" "DELETE"
	i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      select count(*) from v\$datafile where file#=$i_file_id and (status not in ('ONLINE') or name in (select file_name from system.htz_dbfile where file_id=$i_file_id));
      exit;"
  display "query datafile $i_file_id status and file name ,if name not change and status not online ,exit shell" "$FUNCNAME"
  sql_exec "$i_run_sql"
  chkerr $? "query datafile $i_file_id status and file name" 
  #echo "-----------------------------------------------------------"
  #echo $i_count
  #echo "-----------------------------------------------------------"
  i_count=`echo $sql_out`
  if [ "$i_count" -gt "0" ];then
  	display "Datafile $i_file_id Status  not Online or File Name not change" "$FUNCNAME"
  else
    display "Begin Delete Copy Datafile $i_file_id" "$FUNCNAME"
    rman_delete_datafile "$i_file_id" >/dev/null
    chkerr $? "Failed ! Delete Copy Datafile $i_file_id"
    display "Succeed ! Begin Delete Copy Datafile $i_file_id" "$FUNCNAME" 
    update_htz_dbfile_status "$i_file_id" "FINISH"
  fi	
}

db_create_htz_dbfile_table
all_exec()
{
	    get_group_id "$groupid"
	    i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "Failed Query  File Id" 
      i_fileid_count=`echo $sql_out`
      #echo "------------------------------"
      #echo $i_fileid_count
      if [  "$i_fileid_count" -eq "0" ];then
      	   display "****GROUP_ID $groupid all finish****" "$FUNCNAME"
      	
      	   exit;
      else
          i_count_file_id=1
        while [ ${i_count_file_id} -le ${i_fileid_count} ]
          do 
          get_file_id
          display "                                                                        " "$FUNCNAME"
          display "************************************************************************" "$FUNCNAME"
          update_htz_dbfile_status "$fileid" "COPYING"
          copy_datafile $fileid
          off_datafile "$fileid"
          switch_datafile "$fileid"
          online_datafile "$fileid"
          delete_datafile "$fileid"
          display "************************************************************************" "$FUNCNAME"
          let i_count_file_id+=1;
          done
      fi
    display "****GROUP_ID $groupid all finish****" "$FUNCNAME"
      
}

all_exec 