#!/bin/bash
LOG_RUN_ENABLED=1                           # output to logfile enabled
LOG_RUN_FILE=file_run.log
LOG_RMAN_FILE=rman_run_`echo $1`.log
LOG_SQL_ERRORS=1                        # 1 to display sql error context
LOG_SQL_EXETMP=SQL_EXETMP.sql               # save sql text
stage=0                                 # current stage in the script
task=0                                  # current task within a stage 
suppress=0                              # suppress all output
suppresst=0                             # suppress terminal output
suppressl=0                             # supporess logfile output
groupid=$1
fildid=0
###############################################################################
# NAME:        display
#
# DESCRIPTION: 
#   Display message to console and logfile, if enabled.  The suppress global,
#   if set, will suppress all output.  The $LOG_PHYSRU_ENABLED global controls
#   whether the message is also written to the log file.
#
# INPUT(S):
#   Arguments:
#     $1: message to display
#
#   Globals:
#     $stage $task $suppress $suppresst $suppressl $LOG_PHYSRU_ENABLED $LOG_RUN_FILE
#
# RETURN:
#   None
#
###############################################################################
display()
{
if [ "$suppress" -eq "1" ]; then
  return 0
else
  ts=`date "+%Y-%m-%d %H:%M.%S"`
  if [ "$suppresst" -eq "0" ]; then
    echo -e "$ts $2 $1"
  fi
  if [ "$suppressl" -eq "0" ]; then  
    if [ "$LOG_RUN_ENABLED" -eq "1" ]; then
      echo -e "$ts funcname $2 $1" >> $LOG_RUN_FILE
    fi
  fi
  return 0
fi
}

###############################################################################
# NAME:        display_raw
#
# DESCRIPTION: 
#   Similar to the display routine but without timestamp or stage (just echo)
# 
# INPUT(S):
#   Arguments:
#     $1: message to display
#
#   Globals:
#     $suppress $LOG_PHYSRU_ENABLED $LOG_RUN_FILE
#
# RETURN:
#   None
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
#
# DESCRIPTION: 
#   Execute a sql string via the supplied credentials and tns service.  The exit
#   code from sqlplus is returned from this routine.  Note that this return value
#   varies across platforms and should not be relied on beyond simple 
#   success/failure distinction.  The output from the sql script is stored in 
#   the sql_out global variable, and should not be modified in any way.  This
#   routine will also handle displaying the output and entire sql script should
#   a failure occur during execution.
#
# INPUT(S):
#   Arguments:
#     $1: sql string to execute
#
#   Globals:
#     sql_out:  raw output from sql script 
#
# RETURN:
#   status returned from sqlplus
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
# NAME:        rman_swith_datafile
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
# INPUT(S):
#   Arguments:
#     $1
#
#   Globals:
#     sql_out:  raw output from sql script 
#
###############################################################################
db_create_htz_dbfile_table()
{
# 创建 htz_dbfile表，用于存放需要迁移的数据文件，与迁移数据文件的状态
i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from dba_tables where owner='SYSTEM' and table_name='HTZ_DBFILE';
      exit;"
display "query system.htz_dbfile" "$FUNCNAME"
sql_exec "$i_run_sql"
# 判断HTZ_DBFILE表是否存在，如果不存在，自动创建表
i_run_val=`echo $sql_out`
if [ "$i_run_val" = "0" ]; then
		display "Create htz_dbfile on system" "$FUNCNAME"
		i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off 
      whenever sqlerror exit sql.sqlcode 
      create table system.htz_dbfile (group_id number,file_id number,file_name varchar2(100),file_status varchar2(100),ddate varchar2(20));
      insert into system.htz_dbfile(group_id,file_id,file_name,file_status) select mod(file_id,6)+1,file_id,file_name,'CREATED' from dba_data_files where tablespace_name  in (select tablespace_name from dba_tablespaces where CONTENTS='PERMANENT') and tablespace_name not in ('SYSTEM','SYSAUX','USERS');
      exit;"
     sql_exec "$i_run_sql"
     chkerr $? "failed to create table system.htz_dbfile" 
     display "\"system.htz_dbfile create success\""   "$FUNCNAME"
fi
}

get_file_id()
{
	    i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "failed to get file_id" 
      i_file_count=`echo $sql_out`
      if [  "$i_file_count" -gt "0" ];then
           i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
           whenever sqlerror exit sql.sqlcode 
           select file_id from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid and rownum<2;
           exit;"
           sql_exec "$i_run_sql"
           chkerr $? "failed to get file_id" 
           fileid=`echo $sql_out` 
      	   #echo $fileid
           display "get file_id is $fileid" "$FUNCNAME"
      else
      	   display "not find fileid" "$FUNCNAME"
      	   exit;
      fi
      
}

update_htz_dbfile_status()
{
	 i_file_id=$1
	 i_file_status=$2
	 i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      update system.htz_dbfile a set a.file_status='$i_file_status' where a.group_id=$groupid and a.file_id=$i_file_id;
      exit;"
   display "begin update system.htz_dbfile groupid $groupid and fileid $i_file_id file_status $i_file_status" "$FUNCNAME"
   sql_exec "$i_run_sql"
   chkerr $? "failed to update system.htz_dbfile groupid $groupid and fileid $i_file_id file_status $i_file_status"  
   display "finish update system.htz_dbfile groupid $groupid and fileid $i_file_id file_status $i_file_status" "$FUNCNAME"
}

copy_datafile()
{
  i_file_id=$1
  display "begin backup as copy datafile $i_file_id" "$FUNCNAME"
  rman_exec "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  #echo "_______________________________________________________________"
  #echo $l_last_set
  #echo "_______________________________________________________________"
  if [ "$l_last_set" -eq "0" ];then
  display "finish backup as copy datafile $i_file_id" "$FUNCNAME"
  else
  update_htz_dbfile_status "$i_file_id" "CREATED"
  exit
  fi
}



off_datafile()
{
	i_file_id=$1
	update_htz_dbfile_status "$i_file_id" "OFFLINE"
	i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode
      alter database datafile $i_file_id offline;
      exit;"
  display "begin offline datafile $i_file_id" "$FUNCNAME"
  sql_exec "$i_run_sql"
  chkerr $? "failed to offline datafile $i_file_id"
  display "finish offline datafile  $i_file_id" "$FUNCNAME"   
}


switch_datafile()
{
	i_file_id=$1
	update_htz_dbfile_status "$i_file_id" "SWITCH"
	display "begin switch datafile $i_file_id to copy" "$FUNCNAME"
	rman_switch_datafile "$i_file_id" >/dev/null
  l_last_set=`echo $?`
  if [ "$l_last_set" -eq "0" ];then
  display "finish switch datafile $i_file_id to copy" "$FUNCNAME"
  else
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
  display "begin online datafile $i_file_id" "$FUNCNAME"
  sql_exec "$i_run_sql"
  chkerr $? "failed to online datafile $i_file_id"
  display "finish online datafile  $i_file_id" "$FUNCNAME"   
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
  	display "datafile $i_file_id status  not online or file name not change" "$FUNCNAME"
  else
    display "begin delete copy datafile $i_file_id" "$FUNCNAME"
    rman_delete_datafile "$i_file_id" >/dev/null
    chkerr $? "failed to delete copy  datafile $i_file_id"
    display "finish delete copy datafile $i_file_id" "$FUNCNAME" 
    update_htz_dbfile_status "$i_file_id" "FINISH"
  fi	
}

db_create_htz_dbfile_table
all_exec()
{
	    i_run_sql="set pagesize 0 feedback off verify off heading off echo off tab off timing off
      whenever sqlerror exit sql.sqlcode 
      select count(*) from system.htz_dbfile where file_status not in  ('FINISH') and group_id=$groupid;
      exit;"
      sql_exec "$i_run_sql"
      chkerr $? "failed to get file_id" 
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
          update_htz_dbfile_status "$fileid" "COPYING"
          copy_datafile $fileid
          off_datafile "$fileid"
          switch_datafile "$fileid"
          online_datafile "$fileid"
          delete_datafile "$fileid"
          let i_count_file_id+=1;
          done
      fi
    display "****GROUP_ID $groupid all finish****" "$FUNCNAME"
      
}

all_exec 