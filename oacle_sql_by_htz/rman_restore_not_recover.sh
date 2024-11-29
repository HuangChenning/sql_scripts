SHELL_HOME=/home/oracle
CON_FILE=/soft/rman/cntrl_41_1_897950706
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



echo "rman restore output directory:${RMAN_IMAGE_DIR}">>$RMAN_LOG_FILE

echo Script $0 >> $RMAN_LOG_FILE
echo ==== started on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE




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
RESTORE CONTROLFILE FROM '$CON_FILE';
ALTER DATABASE MOUNT;
SET UNTIL SCN 10518245;
RESTORE DATABASE;
RELEASE CHANNEL ch00;
RELEASE CHANNEL ch01;
}
exit
EOF


echo ==== End on `date` ==== >> $RMAN_LOG_FILE
echo >> $RMAN_LOG_FILE
