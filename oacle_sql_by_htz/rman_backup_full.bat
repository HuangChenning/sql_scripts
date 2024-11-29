@echo off

@set LOG_DATE=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%

@set RMAN_LOG_FILE="%0%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%.out"


@if exist %RMAN_LOG_FILE% del %RMAN_LOG_FILE%




@set BACKUPDIR=d:\rmanbackup
@if  not exist %BACKUPDIR% md %BACKUPDIR%

@set ORACLE_HOME=D:\app\Administrator\product\11.2.0\dbhome_1


@set ORACLE_SID=htztest


@set TARGET_CONNECT_STR=sys/manager

@set RMAN=%ORACLE_HOME%\bin\rman.exe


@echo ==== started on %DATE% ==== >> %RMAN_LOG_FILE%
@echo Script name: %0 >> %RMAN_LOG_FILE%



@set BACKUP_TYPE=INCREMENTAL Level=0


@(
echo RUN {
echo ALLOCATE CHANNEL ch00 TYPE DISK;
echo ALLOCATE CHANNEL ch01 TYPE DISK;
echo CROSSCHECK ARCHIVELOG ALL;
echo CROSSCHECK BACKUP;
echo DELETE NOPROMPT OBSOLETE;
echo DELETE NOPROMPT EXPIRED BACKUP;
echo BACKUP
echo       %BACKUP_TYPE%
echo       FORMAT '%BACKUPDIR%\bk_u%%u_s%%s_p%%p_t%%t_%LOG_DATE%'
echo       DATABASE;
echo sql 'alter system archive log current';
echo RELEASE CHANNEL ch00;
echo RELEASE CHANNEL ch01;
echo # Backup all archive logs
echo ALLOCATE CHANNEL ch00 TYPE DISK;
echo ALLOCATE CHANNEL ch01 TYPE DISK;
echo BACKUP
echo       FILESPERSET 20
echo       FORMAT '%BACKUPDIR%\arch_s%%s_p%%p_%LOG_DATE%'
echo       ARCHIVELOG ALL DELETE INPUT;
echo RELEASE CHANNEL ch00;
echo RELEASE CHANNEL ch01;
echo ALLOCATE CHANNEL ch00 TYPE DISK;
echo BACKUP
echo       CURRENT CONTROLFILE FORMAT '%BACKUPDIR%\ctrl_s%%s_p%%p_%LOG_DATE%';
echo RELEASE CHANNEL ch00;
echo }
) | %RMAN% target %TARGET_CONNECT_STR% nocatalog msglog '%RMAN_LOG_FILE%' append

