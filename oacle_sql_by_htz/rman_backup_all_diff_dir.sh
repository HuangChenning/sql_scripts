#!/usr/bin/bash
#脚本使用了默认的RMAN配置参数
#如果在生产环境运行，请确保RMAN的参数文件是配置正确的，满足自己的需求
SHELL_HOME=/home/oracle
RMAN_IMAGE_DIR1=/backup/rman
RMAN_IMAGE_DIR2=/databackup/rman
RMAN_DATA=`date '+%Y%m%d%H'`
if [ ! -d "$SHELL_HOME/log" ]
then
        mkdir -p $SHELL_HOME/log
fi



RMAN_LOG_FILE=${SHELL_HOME}/log/${0}_${RMAN_DATA}.out
if [ -f "$RMAN_LOG_FILE" ]
then
        rm -f "$RMAN_LOG_FILE"

fi

if [ ! -d "$RMAN_IMAGE_DIR1" ]
then
        echo "$RMAN_IMAGE_DIR1 is not exits and will be exit" >>$RMAN_LOG_FILE
fi
if [ ! -d "$RMAN_IMAGE_DIR2" ]
then
        echo "$RMAN_IMAGE_DIR2 is not exits and will be exit" >>$RMAN_LOG_FILE
fi

echo "rman image output directory:${RMAN_IMAGE_DIR1}">>$RMAN_LOG_FILE
echo "rman image output directory:${RMAN_IMAGE_DIR2}">>$RMAN_LOG_FILE

echo Script $0 >> $RMAN_LOG_FILE
echo ==== started on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE

INCR_DATA=`date '+%A'`

if [ "$INCR_DATA" = "Sunday" ]
then
        echo "Full backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=0"
        TAG_NAME="HOT_DB_BK_LEVEL_0_"$RMAN_DATA
else
        echo "Differential incremental backup requested" >> $RMAN_LOG_FILE
        BACKUP_TYPE="INCREMENTAL LEVEL=1"
        TAG_NAME="HOT_DB_BK_LEVEL_1_"$RMAN_DATA
fi

echo "BACKUP_TYPE">> $RMAN_LOG_FILE
echo ${BACKUP_TYPE} >> $RMAN_LOG_FILE

ORACLE_HOME=$ORACLE_HOME
export ORACLE_HOME
ORACLE_SID=$ORACLE_SID
export ORACLE_SID
RMAN=$ORACLE_HOME/bin/rman
TARGET_CONNECT_STR=sys/oracle
$RMAN target $TARGET_CONNECT_STR nocatalog msglog $RMAN_LOG_FILE append << EOF
RUN {
ALLOCATE CHANNEL ch00 TYPE DISK FORMAT '${RMAN_IMAGE_DIR1}/bk_%s_%p_%t';
ALLOCATE CHANNEL ch01 TYPE DISK FORMAT '${RMAN_IMAGE_DIR2}/bk_%s_%p_%t';
#如果这里是RAC需要注意，如果ARCH没有放到共享存储上或者节点间不可以访问时，我们需要在crosscheck archivelog后指定归档路径
CROSSCHECK ARCHIVELOG ALL;

CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
BACKUP
    $BACKUP_TYPE
    SKIP INACCESSIBLE
    TAG $TAG_NAME
    FILESPERSET 2
    # recommended format
    DATABASE;
    sql 'alter system archive log current';
RELEASE CHANNEL ch00;
RELEASE CHANNEL ch01; 
ALLOCATE CHANNEL ch00 TYPE DISK FORMAT '${RMAN_IMAGE_DIR1}/al_%s_%p_%t';
ALLOCATE CHANNEL ch01 TYPE DISK FORMAT '${RMAN_IMAGE_DIR2}/al_%s_%p_%t';
BACKUP
   filesperset 20
   TAG $TAG_NAME
   ARCHIVELOG ALL DELETE INPUT;
RELEASE CHANNEL ch00;
RELEASE CHANNEL ch01;
ALLOCATE CHANNEL ch00 TYPE DISK FORMAT '${RMAN_IMAGE_DIR1}/cont_%s_%p_%t';
BACKUP
    # recommended format
    TAG $TAG_NAME
    CURRENT CONTROLFILE;
RELEASE CHANNEL ch00;
}
exit
EOF


echo ==== End on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE
