#!/bin/bash
#
# 删除在指定路径下N分钟前生成的归档文件
# sh rm_archive_logfile.sh
# test on linux
# http://www.htz.pw
# 认真就输 QQ:7343696

delete_archive_logfile()
{
   if [ $# != 2 ];then
           echo "USAGE: $0 ARCH_PATH  DATE_M"
           exit;
   fi

   SYSTEM=`uname -s`
   ARCH_PATH=$1;

   LOGFILE=rm_archive_logfile_`date +"%Y%m%d_%H%M%S"`.txt



   if [ $SYSTEM = "Linux" ] ; then
           . ~/.bash_profile;
   else
           . ~/.profile;
   fi

   if [ ! -d "$ARCH_PATH" ];then
                printf "ARCH_PATH IS WRONG;\n";
                exit;
   fi

   if [ `find $ARCH_PATH  -name '*.dbf' -mmin +$2 -type f -user oracle|wc -l` -ge 1 ];then
                printf "begin remove archive log file;\n";
                #find $ARCH_PATH  -name '*.dbf' -mmin +$2 -user oracle -type f -exec rm {} \;
                printf "end remove archive log file;\n";
        rman target / << EOF
                crosscheck archivelog all;
                delete noprompt expired archivelog like '$1/%';
                #
                #delete noprompt archivelog until time 'sysdate-$2/1440' like '$1/%.dbf';
                #delete noprompt archivelog until time 'sysdate-5/1440' backed up 1 times to device type disk;
                #
                list archivelog until time 'sysdate-$2/1440'  like '$1/%';
EOF
				if [ `find $ARCH_PATH  -name '*.dbf' -mmin +$2 -type f -user oracle|wc -l` -ge 1 ];then
						printf "rm archive logfile failed\n";
						printf "list  archive logfile shoud rm\n";
						find $ARCH_PATH  -name '*.dbf' -mmin +$2 -type f -user oracle -exec ls -l {} \;
						exit;
				fi
   else
                printf "no archive logfile will remove\n";
   fi
}

delete_archive_logfile /tmp 1