SHELL_HOME=/home/oracle
RMAN_IMAGE_DIR=/soft/rman
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



echo "rman image output directory:${RMAN_IMAGE_DIR}">>$RMAN_LOG_FILE

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
ALLOCATE CHANNEL ch00 TYPE DISK;
ALLOCATE CHANNEL ch01 TYPE DISK;
# crosscheck archivelog 
#CROSSCHECK ARCHIVELOG ALL;
# crosscheck backup image
#CROSSCHECK BACKUP;
#DELETE OBSOLETE BACKUP IMAGE
#DELETE NOPROMPT OBSOLETE;
#DELETE EXPIRED BACKUP IMAGE
#DELETE NOPROMPT EXPIRED BACKUP; 
    sql 'alter system archive log current';
BACKUP
   filesperset 20
   TAG $TAG_NAME
   FORMAT '${RMAN_IMAGE_DIR}/al_%s_%p_%t'
#   ARCHIVELOG ALL DELETE INPUT;
   ARCHIVELOG ALL ;
BACKUP
    # recommended format
    TAG $TAG_NAME
    FORMAT '${RMAN_IMAGE_DIR}/cntrl_%s_%p_%t'
    CURRENT CONTROLFILE;
RELEASE CHANNEL ch00;
RELEASE CHANNEL ch01;
}
exit
EOF


echo ==== End on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE
