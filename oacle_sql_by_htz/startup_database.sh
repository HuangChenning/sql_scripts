#!/bin/bash


########2019-03-01 by cj
#####存在的问题：
#####1.未判断家目录，家目录默认为oracle环境中配置的ORACLE_HOME
#####2.single instance数据库监听启动不准确
#####3.脚本仅检查了RAC的service
#####4.脚本只能启动家目录下全部数据库,或单独指定一个数据库进行启动

#####脚本功能
#####1.脚本只适用于启动11g和12c数据库
#####2.脚本会自动检查listener,RAC的service,Hugepages
#####3.脚本会自动启动12C中的PDB

#####脚本执行方法
#####1.如直接执行,不添加任何参数，则会启动默认家目录下所有的数据库
#####2.后续跟参数./startup_database.sh cs，cs代表数据库的unique_name


#######2019-03-05 by cj
#######1.使用oracle用户执行脚本
#######2.修改大页检查，12C中，alter日志中大页信息不同
#######3.可以指定任一数据库进行启动
#######4.监听注册情况

####问题
#####1.未判断家目录，家目录默认为oracle环境中配置的ORACLE_HOME
#####2.single instance数据库监听启动不准确
#####3.脚本仅检查了RAC的service
#####4.disable的监听无法启动


########2019-03-06 by cj
########1.添加-h帮助选项
########2.添加选项-i,单独启动某个实例
########3.添加选项-a,启动数据库，加all参数可以启动默认目录下所有数据库
########3.添加选项-s判断是否启动服务
########4.添加bug功能，前台展示信息，后台日志中包含命令和命令结果
########5.前台信息展示添加时间



log=start_up_`date +%Y%m%d`.log
> $log

function database_status()
{
sid=$1

echo "####### database_status #######" >> $log
echo "DB_STATUS=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select open_mode from v\$database;
exit;
EOF"\` >> $log

DB_STATUS=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select open_mode from v\\\$database;
exit;
EOF`

echo $DB_STATUS >> $log

	if [ "$DB_STATUS" == "READ WRITE" ];then
		echo  "######## Database $sid is $DB_STATUS ########"
	else
		echo  "######## Database $sid is $DB_STATUS ########"
	fi
}

function pdb_fetures()
{
sid=$1

echo "####### pdb_fetures #######" >> $log

echo "CDB=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select CDB from v\$database;
exit;
EOF\`" >> $log

CDB=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select CDB from v\\\$database;
exit;
EOF`

echo $CDB >> $log
#######check_cdb_features
	if [ "$CDB" == "YES" ];then
		start_pdb $sid
	else
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo  "######## The PDB feature is not enabled ########"
	fi
}

function start_pdb()
{
sid=$1

echo "####### start_pdb #######" >> $log

echo "PDB=(\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select name from v\$pdbs where name not in ('PDB\$SEED');
exit;
EOF\`)" >> $log

PDB=(`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select name from v\\\$pdbs where name not in ('PDB\\\$SEED');
exit;
EOF`)

echo $PDB >> $log

	for a in ${PDB[@]};do

echo "PDB_STATUS=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select open_mode from v\$pdbs where name = '$a';
exit;
EOF\`" >> $log

PDB_STATUS=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select open_mode from v\\\$pdbs where name = '$a';
exit;
EOF`

echo $PDB_STATUS >> $log

		if [ "$PDB_STATUS" == "READ WRITE" ];then
			echo `date +%Y-%m-%d\ %H:%M:%S`
			echo "######## PDB $a is $PDB_STATUS ########"
			continue
		else
			echo `date +%Y-%m-%d\ %H:%M:%S`
			echo "######## Begin startup PDB $a ########"

echo "export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba'<<EOF
alter pluggable database $a open;
EOF" >> $log

export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba'<<EOF >> $log
alter pluggable database $a open;
EOF

			echo "######## PDB $a has been started ########"
		fi
	done
}


function check_hugepages_11g()
{
sid=$1

echo "####### check_hugepages_11g #######" >> $log


echo "UNIQUE_NAME=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\$parameter WHERE name = 'db_unique_name';
exit;
EOF\`" >> $log

UNIQUE_NAME=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\\\$parameter WHERE name = 'db_unique_name';
exit;
EOF`

echo $UNIQUE_NAME >> $log

######HugePages detailed information
A=`export ORACLE_SID=$sid&&tail -500 \$ORACLE_BASE/diag/rdbms/\$UNIQUE_NAME/\$sid/trace/alert_\$sid.log | grep Large\ Pages\ Information -A8`

######HugePages usage
B=(`export ORACLE_SID=$sid&&tail -500 \$ORACLE_BASE/diag/rdbms/\$UNIQUE_NAME/\$sid/trace/alert_\$sid.log | grep Total\ Shared\ Global\ Region\ in\ Large\ Pages | awk 'BEGIN{ FS="(" ; RS=")" } NF>1 { print $NF }'`)
C=`echo ${B[*]} | awk -F " " '{print $NF}'`

######OS configuration
D=`cat /proc/meminfo  | grep HugePages_Total | cut -d ':' -f 2 | sed 's/^[ \t]*//g'`

echo "A=\`export ORACLE_SID=$sid&&tail -500 $ORACLE_BASE/diag/rdbms/$UNIQUE_NAME/$sid/trace/alert_$sid.log | grep Large\ Pages\ Information -A8\`">> $log
echo $A >> $log

echo "D=\`cat /proc/meminfo  | grep HugePages_Total | cut -d ':' -f 2 | sed 's/^[ \t]*//g'\`" >> $log
echo $D >> $log

if [ $D -eq 0 ];then
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## OS don't configure HugePages ########"
else
	if [ "$C" = "100%" ];then
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo "######## $aa Hugepages succeed ########"
		echo "######## $aa HugePages detailed information ########"
		echo "$A"
		echo "######## $aa Check Hugepages end ########"
	else
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo "######## Database don't use Hugepages"
	fi
fi
}

function check_hugepages_12c()
{
sid=$1

echo "####### check_hugepages_12c #######" >> $log

echo "UNIQUE_NAME=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\$parameter WHERE name = 'db_unique_name';
exit;
EOF\`" >> $log

UNIQUE_NAME=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\\\$parameter WHERE name = 'db_unique_name';
exit;
EOF`

echo $UNIQUE_NAME >> $log

######HugePages detailed information
A=`export ORACLE_SID=$sid&&tail -500 \$ORACLE_BASE/diag/rdbms/\$UNIQUE_NAME/\$sid/trace/alert_\$sid.log | grep PAGESIZE\ \ AVAILABLE_PAGES -A4`

B=(`export ORACLE_SID=$sid&&tail -500 \$ORACLE_BASE/diag/rdbms/\$UNIQUE_NAME/\$sid/trace/alert_\$sid.log | grep PAGESIZE\ \ AVAILABLE_PAGES -A4 | grep -v "^[0-9]" | sed 's/[ ][ ]*/,/g' | cut -d ',' -f 3`)
C=`echo ${B[*]} | awk -F " " '{print $NF}'`

######OS configuration
D=`cat /proc/meminfo  | grep HugePages_Total | cut -d ':' -f 2 | sed 's/^[ \t]*//g'`

echo "A=\`export ORACLE_SID=$sid&&tail -500 \$ORACLE_BASE/diag/rdbms/\$UNIQUE_NAME/\$sid/trace/alert_\$sid.log | grep PAGESIZE\ \ AVAILABLE_PAGES -A4\`" >> $log
echo "D=\`cat /proc/meminfo  | grep HugePages_Total | cut -d ':' -f 2 | sed 's/^[ \t]*//g'\`" >> $log

echo $A >> $log
echo $D >> $log


if [ $D -eq 0 ];then
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## OS don't configure HugePages ########"
elif [ "$D" == "$C" ];then
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## $UNIQUE_NAME Hugepages succeed ########"
	echo "######## $UNIQUE_NAME HugePages detailed information ########"
	echo "$A"
	echo "######## $UNIQUE_NAME Check Hugepages end ########"
else
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## Database don't use Hugepages"
	echo "$A"
fi
}

function check_service()
{
sid=$1

echo "####### check_hugepages_12c #######" >> $log

echo "UNIQUE_NAME=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\$parameter WHERE name = 'db_unique_name';
exit;
EOF\`" >> $log

UNIQUE_NAME=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\\\$parameter WHERE name = 'db_unique_name';
exit;
EOF`

echo $UNIQUE_NAME >> $log

echo "cluster=\`export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\$parameter WHERE name = 'cluster_database';
exit;
EOF\`" >> $log

cluster=`export ORACLE_SID=$sid&&\$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
SELECT LOWER(VALUE) FROM v\\\$parameter WHERE name = 'cluster_database';
exit;
EOF`

echo $cluster >> $log

echo `date +%Y-%m-%d\ %H:%M:%S`
echo "######## Begin check $UNIQUE_NAME service ########"

if [ "$cluster" = "true" ];then
    echo "srv=(\`srvctl config service -d $UNIQUE_NAME | grep -i Service\ name | cut -d ' ' -f 3\`)" >> $log
	srv=(`srvctl config service -d $UNIQUE_NAME | grep -i Service\ name | cut -d ' ' -f 3`)
    echo $srv >> $log

    if [ "$srv" == "" ];then
		echo `date +%Y-%m-%d\ %H:%M:%S`
        echo "######## Database unconfigured service ########"
	else
		for c in ${srv[@]};do

            echo "run_inst=\`srvctl status service -d $UNIQUE_NAME | grep Service\ $c | cut -d ' ' -f 7\`" >> $log
        	run_inst=`srvctl status service -d $UNIQUE_NAME | grep Service\ $c | cut -d ' ' -f 7`
            echo $run_inst >> $log
            echo "config_inst=\`srvctl config service -d $UNIQUE_NAME -s $c | grep Preferred | cut -d ' ' -f 3\`" >> $log
        	config_inst=`srvctl config service -d $UNIQUE_NAME -s $c | grep Preferred | cut -d ' ' -f 3`
            echo $config_inst >> $log


        	if [ "$config_inst" == "$run_inst" ];then
				echo "######## $c is running normally ########"
        	else
        		echo `date +%Y-%m-%d\ %H:%M:%S`
				echo "######## $c is wrong operation ########"
				echo "######## Begin relocate service $c ########"
                echo "srvctl relocate service -d $UNIQUE_NAME -service $c -oldinst $run_inst -newinst $config_inst" >> $log
				srvctl relocate service -d $UNIQUE_NAME -service $c -oldinst $run_inst -newinst $config_inst
				echo "######## Relocate service $c end ########"
        	fi
		done
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo "######## Check $UNIQUE_NAME service end ########"
	fi
else
	echo "######## NoRAC unchecked service ########"
fi
}


function database_start()
{
sid=$1

echo "####### database_start #######" >> $log

echo "export ORACLE_SID=\`$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
startup;
exit;
EOF\`" >> $log

export ORACLE_SID=$sid&&$ORACLE_HOME/bin/sqlplus -s '/ as sysdba' <<EOF >> $log
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
startup;
exit;
EOF

}


function database_restart_start()
{

echo "####### database_restart_start #######" >> $log

sid=`srvctl config database -d $db | grep -i instance | cut -d ' ' -f 3`

echo "srvctl start database -d $db" >> $log
srvctl start database -d $db
}



function database_rac_start()
{

echo "####### database_rac_start #######" >> $log

host=`hostname`
sid=`srvctl status instance -d $db -n $host | cut -d ' ' -f 2`

echo "srvctl start database -d $db" >> $log
srvctl start database -d $db
}


function startup_instance_databaes()
{

sid=$1

DB_VERSION=`sqlplus -v | cut -d ' ' -f 3 | cut -d . -f 1`

if [ $DB_VERSION -eq 12 ];then
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## Begin startup database 12c $sid ########"
	database_start $sid
	if [ $? = 0 ];then
		database_status $sid
		pdb_fetures $sid
	else
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo  "######## Database 12c $sid start failure ########"
		exit 1
	fi
	check_hugepages_12c $sid

#######check_version_11g
elif [ $DB_VERSION -eq 11 ];then
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## Begin startup database 11g $sid ########"
	database_start $sid
	if [ $? = 0 ];then
		database_status $sid
	else
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo "######## Database 11g $aa start failure ########"
		exit 1
	fi
	check_hugepages_11g $sid
else
	echo `date +%Y-%m-%d\ %H:%M:%S`
	echo "######## Confirm the database version ########"
fi

}



function start_db_database()
{

db=$1
#######check_version_12c

ASM=`ps -ef | grep asm | grep smon`
DB_VERSION=`sqlplus -v | cut -d ' ' -f 3 | cut -d . -f 1`



if [ $DB_VERSION -eq 12 ];then
#######check_single_instance_database
	if [ "$ASM" = "" ];then
		sid=`ls \$ORACLE_BASE/diag/rdbms/\$db | grep -v -i "mif$"`
		echo `date +%Y-%m-%d\ %H:%M:%S`
		echo "######## Begin startup single instance database 12c $db ########"
		database_start $sid

#######check_datbase_status
        if [ $? = 0 ];then
			database_status $sid
			pdb_fetures $sid
		else
			echo  "######## Database 12c $db is $DB_STATUS ########"
		fi
		check_hugepages_12c $sid
    else
        aa=(`srvctl config database`)
        restart=`ps -ef | grep crsd | grep d.bin`

#######check_restart_database or RAC
		if [ "$restart" = "" ];then
			echo `date +%Y-%m-%d\ %H:%M:%S`
			echo "######## Begin startup restart database 12c $db ########"
			database_restart_start
			if [ $? = 0 ];then
			    database_status $sid
			    pdb_fetures $sid
		    else
		        echo  "######## Database 12c $db start failure ########"
		    fi
		    check_hugepages_12c $sid
		else
			echo `date +%Y-%m-%d\ %H:%M:%S`
		    echo "######## Begin startup RAC database 12c $db ########"
		    database_rac_start
		    if [ $? = 0 ];then
		        database_status $sid
		        pdb_fetures $sid
            else
                    echo "######## Database 12c $db start failure ########"
            fi
            check_hugepages_12c $sid
        fi
    fi

#######check_version_11g
elif [ $DB_VERSION -eq 11 ];then

#######check_single_instance_database
    if [ "$ASM" = "" ];then
 		sid=`ls \$ORACLE_BASE/diag/rdbms/\$db | grep -v -i "mif$"`
 		echo `date +%Y-%m-%d\ %H:%M:%S`
 		echo "######## Begin startup single instance database 11c $sid ########"
 		database_start $sid

 		if [ $? = 0 ];then
 		    database_status $sid
 		else
 		    echo "Database 11g $db start failure"
 		fi
 		check_hugepages_11g $sid
    else
        restart=`ps -ef | grep crsd | grep d.bin`

#######check_restart_database or RAC
 		if [ "$restart" = "" ];then
 			echo `date +%Y-%m-%d\ %H:%M:%S`
 		    echo "######## Begin startup restart database 11g $db ########"
 		    database_restart_start

 		    if [ $? = 0 ];then
 		        database_status $sid
 		    else
 		        echo "######## Database 11g $db start failure ########"
 		    fi
 		    check_hugepages_11g $sid
 		else
 			echo `date +%Y-%m-%d\ %H:%M:%S`
 		    echo "######## Begin startup RAC database 11g $db ########"
 		    database_rac_start
 		    if [ $? = 0 ];then
 		        database_status $sid
 		    else
 		        echo "######## Database 11g $db start failure ########"
 		    fi
 		    check_hugepages_11g $sid
 		fi
    fi
else
    echo "Confirm the database version"
fi

}

function start_all_database()
{

#######check_version_12c

ASM=`ps -ef | grep asm | grep smon`
DB_VERSION=`sqlplus -v | cut -d ' ' -f 3 | cut -d . -f 1`


if [ $DB_VERSION -eq 12 ];then
#######check_single_instance_database
    if [ "$ASM" = "" ];then
        aa=(`ls \$ORACLE_BASE/diag/rdbms/`)
        for db in ${aa[@]};do
            sid=`ls \$ORACLE_BASE/diag/rdbms/\$db | grep -v -i "mif$"`
            echo `date +%Y-%m-%d\ %H:%M:%S`
            echo "######## Begin startup single instance database 12c $sid ########"
            database_start $sid

#######check_datbase_status
                if [ $? = 0 ];then
                    database_status $sid
                    pdb_fetures $sid
                else
                    echo  "######## Database 12c $db is $DB_STATUS ########"
                fi
            done
            check_hugepages_12c $sid
    else
        aa=(`srvctl config database`)
        restart=`ps -ef | grep crsd | grep d.bin`
        for db in ${aa[@]};do

#######check_restart_database or RAC
            if [ "$restart" = "" ];then
            	echo `date +%Y-%m-%d\ %H:%M:%S`
                echo "######## Begin startup restart database 12c $db ########"
                database_restart_start
                if [ $? = 0 ];then
                    database_status $sid
                    pdb_fetures $sid
#######check_cdb_features
                else
                    echo  "######## Database 12c $db start failure ########"
                    continue
                fi
                check_hugepages_12c $sid
            else
            	echo `date +%Y-%m-%d\ %H:%M:%S`
                echo "######## Begin startup RAC database 12c $db ########"
                database_rac_start
                if [ $? = 0 ];then
                    database_status $sid
                    pdb_fetures $sid
                else
                    echo "######## Database 12c $db start failure ########"
                    continue
                fi
                check_hugepages_12c $sid
                check_service $sid
            fi
        done
    fi

#######check_version_11g
elif [ $DB_VERSION -eq 11 ];then

#######check_single_instance_database
    if [ "$ASM" = "" ];then
        aa=(`ls \$ORACLE_BASE/diag/rdbms/`)
        for db in ${aa[@]};do
            sid=`ls \$ORACLE_BASE/diag/rdbms/\$db | grep -v -i "mif$"`
            echo `date +%Y-%m-%d\ %H:%M:%S`
            echo "######## Begin startup single instance database 11c $sid ########"
            database_start $sid

            if [ $? = 0 ];then
                database_status $sid
            else
                echo "Database 11g $db start failure"
                continue
            fi
            check_hugepages_11g $sid
        done
    else
		aa=(`srvctl config database`)
        restart=`ps -ef | grep crsd | grep d.bin`
        for db in ${aa[@]};do

#######check_restart_database or RAC
            if [ "$restart" = "" ];then
            	echo `date +%Y-%m-%d\ %H:%M:%S`
                echo "######## Begin startup restart database 11g $db ########"
                database_restart_start

                if [ $? = 0 ];then
                    database_status $sid
                else
                    echo "######## Database 11g $db start failure ########"
                    continue
                fi
                check_hugepages_11g $sid
            else
            	echo `date +%Y-%m-%d\ %H:%M:%S`
                echo "######## Begin startup RAC database 11g $db ########"
                database_rac_start
                if [ $? = 0 ];then
                    database_status $sid
                else
                    echo "######## Database 11g $db start failure ########"
                    continue
                fi
                check_hugepages_11g $sid
                check_service $sid
            fi
        done
    fi
else
    echo "Confirm the database version"
fi

}


function check_listener()
{

echo `date +%Y-%m-%d\ %H:%M:%S`
declare -a tns
t=0
flag=0

echo "####### check_listener #######" >> $log
lsn_start=(`ps -ef|grep tns|grep -v grep|grep -v ASM|grep -v MGMTLSNR | grep -v SCAN | grep -v root | awk '{print \$9}'|sort -n`)
oracle=`ps -ef | grep smon | grep asm`

echo "lsn_start=(`ps -ef|grep tns|grep -v grep|grep -v ASM|grep -v MGMTLSNR | grep -v SCAN | grep -v root | awk '{print \$9}'|sort -n`)" >> $log
echo "oracle=`ps -ef | grep smon | grep asm`"  >> $log

if [ "$oracle" = "" ];then
	if [ -f "$ORACLE_HOME/network/admin/listener.ora" ];then
	    lsn=(`cat \$ORACLE_HOME/network/admin/listener.ora | grep "=\$" | grep -v "(" |cut -d '=' -f 1| sort -n`)
	    echo "lsn=(`cat \$ORACLE_HOME/network/admin/listener.ora | grep "=\$" | grep -v "(" |cut -d '=' -f 1| sort -n`)" >> $log
	    for e in "${lsn[@]}";do
	        for f in "${lsn_start[@]}";do
	            if [[ "${e}" == "${f}" ]]; then
	                flag=1
	                break
	            fi
	        done
	        if [[ $flag -eq 0 ]];then
	            tns[t]=$e
	            t=$((t+1))
	        else
	            flag=0
	        fi
	    done
	else
		echo "####### Please confirm listener configuration file #######"
	fi
    if [ ${#tns[@]} -eq 0 ];then
        for e in ${lsn_start[@]};do
            echo "######## $e listener has been startup ########"
        done
    else
        for e in ${tns[@]};do
            for f in ${lsn_start[@]};do
                echo "######## $f listener has been startup ########"
            done
            echo "######## Begin start listener $e ########"

            echo "srvctl start listener -listener $e" >> $log
            srvctl start listener -listener $e
            echo "######## Check Listener $e ########"
            echo "srvctl start listener -listener $e" >> $log
            srvctl status listener -listener $e
            echo "######## Check Listener $e end ########"
        done
    fi
else
    lsn=(`\$ORACLE_HOME/bin/srvctl config listener | grep -i name | cut -d ' ' -f 2`)
    echo "lsn=(`\$ORACLE_HOME/bin/srvctl config listener | grep -i name | cut -d ' ' -f 2`)" >> $log
    for e in "${lsn[@]}";do
        for f in "${lsn_start[@]}";do
            if [[ "${e}" == "${f}" ]]; then
                flag=1
                break
            fi
        done
        if [[ $flag -eq 0 ]];then
            tns[t]=$e
            t=$((t+1))
        else
            flag=0
        fi
    done
    if [ ${#tns[@]} -eq 0 ];then
        for e in ${lsn_start[@]};do
            echo "######## $e listener has been startup ########"
        done
    else
        for e in ${tns[@]};do
            for f in ${lsn_start[@]};do
                echo "######## $f listener has been startup ########"
            done
            	echo "######## Begin start listener $e ########"
                echo "srvctl start listener -listener $e" >> $log
            	srvctl start listener -listener $e
            	echo "######## Check Listener $e ########"
                echo "srvctl start listener -listener $e" >> $log
            	srvctl status listener -listener $e
            	echo "######## Check Listener $e end ########"
        done
    fi
fi
}


function listener_register()
{
########Listener register
echo `date +%Y-%m-%d\ %H:%M:%S`

tns_start=(`ps -ef|grep tns|grep -v grep|grep -v ASM|grep -v MGMTLSNR | grep -v SCAN | grep -v root | awk '{print \$9}'|sort -n`)
for g in ${tns_start[*]};do
	echo "######## $g registe detail ########"
	lsnrctl status $g
done
}


while getopts ":hi:sa:"  arg
do
case $arg in

h)
if [ "$1" = "-h" ];then
echo "
Support:
	OS:Support Linux 6 and Linux 7
	Oracle:Support ORACLE 11G and ORACLE 12C

USAGE:
	./start_database.sh -i <ORACLE_SID> : Start current instance
	./start_database.sh -i <ORACLE_SID> -s : Start current instance and Check service status and relocate service in RAC;
	./start_database.sh -s : Check service status and relocate service in RAC;
	./start_database.sh -a <UNIQUE_NAME> : Start current database or start all node database in RAC;
	./start_database.sh -a <UNIQUE_NAME> -s :Start current database or start all node database in RAC,and Check service status and relocate service in RAC;
	./start_database.sh -a all : Start all instance in default ORACLE_HOME and Check service status and relocate service in RAC;

OPTIONS:
	-a:Startup all instance database,start rac database; Example: \"-a all\" or  \"-a <sid>\"
	-i:Option decide start instance; Example: -i cs1
	-s:Option decide start recloted; Example: -s
	-h:Option provide scrip help
"
else
    echo "Please input opthion \"-h\" for more infomation"
    exit
fi
;;

i)
	a=($*)
	for i in "${a[@]}";do
		if [ "$i" = "-h" ];then
			b=1
			break
		elif [ "$i" = "-a" ];then
			b=2
			break
		else
			b=0
			continue
		fi
	done
	if [ $b -eq 0 ];then
		check_listener
		sid=$OPTARG
		startup_instance_databaes $sid
		listener_register

	else
		echo "Error:\"-i\" option parameter error,Try '-h' for more information;"
		exit
	fi
	;;
s)
	a=($*)
	for i in "${a[@]}";do
		if [ "$i" = "-h" ];then
			b=1
			break
		else
			b=0
			continue
		fi
	done
	if [ $b -eq 0 ];then
		for i in "${a[@]}";do
			if [ "$i" = "-i" ];then
				if [ "$1" = '-i' ];then
					check_service $sid
					break
				else
					echo "Please priority execute \"-a\" or \"-i\";"
					exit
				fi
			elif [ "$i" = "-a" ];then
				if [ "$1" = "-a" ];then
					check_service $sid
					break
				else
					echo "Please priority execute \"-a\" or \"-i\";"
					exit
				fi
			elif [ $# -eq 1 ];then
					if [ "$1" = '-s' ];then
						echo "Please input SID:"
						read sid
						check_service $sid
						break

					else
						echo "Error:\"-s\" option parameter error,Try '-h' for more information;"
						exit
					fi
			else
				echo "Error:\"-s\" option parameter error,Try '-h' for more information;"
				exit
			fi
		done
	else
		echo "Error:\"-s\" option parameter error,Try '-h' for more information;"
		exit
	fi
	;;
a)
	a=($*)
	for i in "${a[@]}";do
		if [ "$i" = "-h" ];then
			b=1
			break
		elif [ "$i" = "-i" ];then
			b=2
			break
		else
			b=0
			continue
		fi
	done
	if [ $b -eq 0 ];then
		if [ "$1" = "-a" ];then
			if [ $# = 2 ];then
				if [ "$2" = "all" ];then
					check_listener
					start_all_database
					listener_register
				else
					check_listener
					sid=$OPTARG
					start_db_database $sid
				fi
			else
				if [ "$3" = "-s" ];then
					if [ "$2" = "all" ];then
						echo "Error:\"-a\" option parameter error,Try '-h' for more information;"
						exit
					else
						check_listener
						sid=$OPTARG
						start_db_database $sid
						listener_register
					fi
				else
					echo "Error:\"-a\" option parameter error,Try '-h' for more information;"
					exit
				fi
			fi
		else
			echo "Error:\"-a\" option parameter error,Try '-h' for more information;"
			exit
		fi
	else
		echo "Error:\"-a\" option parameter error,Try '-h' for more information;"
		exit
	fi
	;;

\?)
    echo "Try '-h' for more information"
    exit
	;;
esac
done
