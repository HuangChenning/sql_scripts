set linesize 130
set pagesize 999

alter session set cursor_sharing=exact;

col filename new_value filename
SELECT 'check_'||instance_NAME||'_'||host_name||'_'||to_char(sysdate,'yyyymmdd')||'.log' filename FROM v$instance;
spool &filename

prompt ****************************************
prompt [TITLE] SESSIONTIMEZONE
prompt ****************************************
COL SESSIONTIMEZONE FOR A30
SELECT SESSIONTIMEZONE FROM DUAL;
prompt ****************************************
prompt [TITLE] REDO LOG
prompt ****************************************
SELECT DISTINCT ROUND(BYTES / 1024 / 1024, 2)||' MB * '||
		COUNT(*) OVER(PARTITION BY BYTES, COUNT(*))|| ' GROUPS * ' ||
		COUNT(*)||' MEMBERS' REDO_MEMBER
  FROM V$LOG A, V$LOGFILE B
 WHERE A.GROUP# = B.GROUP#
 GROUP BY A.GROUP#, BYTES;
prompt ****************************************
prompt [TITLE] SGA
prompt ****************************************  
COL NAME FOR A30
COL "value(Byte)" FOR A60
SELECT NAME, TO_CHAR(VALUE) "value(Byte)"
  FROM V$SGA
UNION ALL
SELECT NAME, VALUE
  FROM V$PARAMETER
 WHERE NAME IN
       ('shared pool_size', 'large_pool_size', 'java_pool_size', 'lock_sga');       
prompt ****************************************
prompt [TITLE] SPFILE?
prompt **************************************** 
col "Parameter_File" for a50
SELECT NVL(VALUE, 'pfile') "Parameter_File"
  FROM V$PARAMETER
 WHERE NAME = 'spfile'; 
prompt ****************************************
prompt [TITLE] db version
prompt ****************************************
COL VERSION FOR A80
SELECT PRODUCT || ' ' || VERSION || ' - ' || STATUS version
  FROM PRODUCT_COMPONENT_VERSION
 WHERE PRODUCT LIKE '%Oracle%';       
prompt ****************************************
prompt [TITLE] PARAMETER
prompt **************************************** 
COL NAME FOR A30
COL pvalue FOR A60
SELECT NAME, RTRIM(VALUE) "pvalue"
  FROM V$PARAMETER
 WHERE ISDEFAULT = 'FALSE'
 ORDER BY NAME;
prompt ****************************************
prompt [TITLE] number and size of datafile
prompt **************************************** 
SELECT SUM(FILE_COUNT) FILE_COUNT,
       SUM(FILE_SIZE) / 1024 / 1024 / 1024 "FILE_SIZE(GB)"
  FROM (SELECT COUNT(*) FILE_COUNT, SUM(BYTES) FILE_SIZE
	  FROM V$DATAFILE
	UNION ALL
	SELECT COUNT(*), SUM(BYTES) FROM V$TEMPFILE);
prompt ****************************************
prompt [TITLE] number of tablespace 
prompt **************************************** 
SELECT COUNT(*) FROM dba_tablespaces;
prompt ****************************************
prompt [TITLE] number of controlfile 
prompt **************************************** 
SELECT COUNT(*) FROM v$controlfile;
prompt ****************************************
prompt [TITLE] CHARACTERSET 
prompt **************************************** 
SELECT max(decode(parameter,'NLS_LANGUAGE',VALUE))||'_'|| 
       max(decode(parameter,'NLS_TERRITORY',VALUE))||'.'|| 
       max(decode(parameter,'NLS_CHARACTERSET',VALUE)) CHARACTERSET
  FROM V$NLS_PARAMETERS
 WHERE PARAMETER IN ('NLS_LANGUAGE', 'NLS_TERRITORY', 'NLS_CHARACTERSET');
prompt ****************************************
prompt [TITLE] DB CONFIGURE
prompt ****************************************
COL "DB Name" FOR A15
COL "Global Name" FOR A15
COL "Host Name" FOR A15
COL "Instance Name" FOR A15
COL "Restricted Mode" FOR A15
COL "Archive Log Mode" FOR A15
SELECT A.NAME "DB Name",
       E.GLOBAL_NAME "Global Name",
       C.HOST_NAME "Host Name",
       C.INSTANCE_NAME "Instance Name",
       DECODE(C.LOGINS, 'RESTRICTED', 'YES', 'NO') "Restricted Mode",
       A.LOG_MODE "Archive Log Mode"
  FROM V$DATABASE A, V$VERSION B, V$INSTANCE C, GLOBAL_NAME E
 WHERE B.BANNER LIKE '%Oracle%';
prompt ****************************************************************************************************************************
prompt
prompt
prompt ****************************************
prompt [TITLE] CONTROLFILE
prompt ****************************************
col NAME for a50
SELECT NAME, STATUS FROM V$CONTROLFILE;
prompt ****************************************
prompt [TITLE] REDOFILE
prompt **************************************** 
COL GROUP# FOR 999
COL "Redo File" FOR A30
COL TYPE FOR A10
COL STATUS FOR A10
COL "Size(MB)" FOR 999,999,999,999
SELECT F.GROUP#,
       F.MEMBER "Redo File",
       F.TYPE,
       L.STATUS,
       L.BYTES / 1024 / 1024 "Size(MB)"
  FROM V$LOG L, V$LOGFILE F
 WHERE L.GROUP# = F.GROUP#; 
prompt ****************************************
prompt [TITLE] DATAFILE
prompt ****************************************
COL TABLESPACE_NAME FOR A30
COL FILE_NAME FOR A40
COL "Total Size(MB)" FOR 999,999,999,999
COL "Auto" FOR A5
SELECT TABLESPACE_NAME,
       FILE_NAME,
       BYTES / 1024 / 1024 "Total Size(MB)",
       AUTOEXTENSIBLE "Auto"
  FROM DBA_DATA_FILES
 ORDER BY TABLESPACE_NAME, FILE_ID;
prompt ****************************************
prompt [TITLE] TABLESPACE
prompt **************************************** 
SELECT D.TABLESPACE_NAME "Name",
       D.STATUS "Status",
       D.CONTENTS "Type",
       TO_CHAR(NVL(A.BYTES / 1024 / 1024, 0), '99G999G990D900') "Size (MB)",      
       TO_CHAR(NVL(A.BYTES - NVL(F.BYTES, 0), 0) / 1024 / 1024,
	       '99G999G990D900') "Used (MB)",
       TO_CHAR(NVL((A.BYTES - NVL(F.BYTES, 0)) / A.BYTES * 100, 0),
	       '990D00') "Used％"
  FROM SYS.DBA_TABLESPACES D,
       (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES
	  FROM DBA_DATA_FILES
	 GROUP BY TABLESPACE_NAME) A,
       (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES
	  FROM DBA_FREE_SPACE
	 GROUP BY TABLESPACE_NAME) F
 WHERE D.TABLESPACE_NAME = A.TABLESPACE_NAME(+)
   AND D.TABLESPACE_NAME = F.TABLESPACE_NAME(+); 
prompt ****************************************
prompt [TITLE] USER FOR TEMPSPACE ON SYSTEM
prompt ****************************************  
SELECT USERNAME FROM DBA_USERS WHERE TEMPORARY_TABLESPACE = 'SYSTEM';
prompt ****************************************
prompt [TITLE] USER FOR DEFAULT TABLESPACE ON SYSTEM
prompt ****************************************  
SELECT USERNAME
  FROM DBA_USERS
 WHERE DEFAULT_TABLESPACE = 'SYSTEM'
   AND USERNAME <> 'SYS'; 
prompt ****************************************
prompt [TITLE] PUBLICE SYN Point does not exist
prompt ****************************************
COL SYNONYM_NAME FOR A30
COL TABLE_OWNER FOR A30
COL TABLE_NAME FOR A30
SELECT S.SYNONYM_NAME, S.TABLE_OWNER, S.TABLE_NAME
  FROM SYS.DBA_SYNONYMS S
 WHERE NOT EXISTS (SELECT 'x'
	  FROM SYS.DBA_OBJECTS O
	 WHERE O.OWNER = S.TABLE_OWNER
	   AND O.OBJECT_NAME = S.TABLE_NAME)
   AND DB_LINK IS NULL
   AND S.OWNER = 'PUBLIC'
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] PRIVATE SYN Point does not exist
prompt ****************************************  
COL OWNER FOR A20
SELECT S.OWNER, S.SYNONYM_NAME, S.TABLE_OWNER, S.TABLE_NAME
  FROM SYS.DBA_SYNONYMS S
 WHERE NOT EXISTS (SELECT 'x'
	  FROM SYS.DBA_OBJECTS O
	 WHERE O.OWNER = S.TABLE_OWNER
	   AND O.OBJECT_NAME = S.TABLE_NAME)
   AND DB_LINK IS NULL
   AND S.OWNER <> 'PUBLIC'
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] Useless ROLE
prompt ****************************************  
SELECT ROLE
  FROM DBA_ROLES R
 WHERE ROLE NOT IN
       ('CONNECT', 'RESOURCE', 'DBA', 'SELECT_CATALOG_ROLE',
	'EXECUTE_CATALOG_ROLE', 'DELETE_CATALOG_ROLE', 'EXP_FULL_DATABASE',
	'WM_ADMIN_ROLE', 'IMP_FULL_DATABASE', 'RECOVERY_CATALOG_OWNER',
	'AQ_ADMINISTRATOR_ROLE', 'AQ_USER_ROLE', 'GLOBAL_AQ_USER_ROLE',
	'OEM_MONITOR', 'HS_ADMIN_ROLE')
   AND NOT EXISTS
 (SELECT 1 FROM DBA_ROLE_PRIVS P WHERE P.GRANTED_ROLE = R.ROLE);   
prompt ****************************************
prompt [TITLE] Useless Profile
prompt ****************************************  
SELECT DISTINCT PROFILE
  FROM DBA_PROFILES
MINUS
SELECT DISTINCT PROFILE FROM DBA_USERS;
SELECT PB.OWNER, PB.OBJECT_NAME
  FROM DBA_OBJECTS PB
 WHERE PB.OBJECT_TYPE = 'PACKAGE BODY'
   AND NOT EXISTS (SELECT 1
	  FROM DBA_OBJECTS P
	 WHERE P.OBJECT_TYPE = 'PACKAGE'
	   AND P.OWNER = PB.OWNER
	   AND P.OBJECT_NAME = PB.OBJECT_NAME)
 ORDER BY 1, 2;
prompt ****************************************
prompt [TITLE] DISABLED CONSTRAINTS
prompt ****************************************  
COL OWNER           FOR A30
COL TABLE_NAME      FOR A30
COL CONSTRAINT_NAME FOR A30
COL CONSTRAINT_TYPE FOR A30
SELECT OWNER, TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
  FROM DBA_CONSTRAINTS
 WHERE STATUS = 'DISABLED'
 ORDER BY 1, 2, 3;
prompt ****************************************
prompt [TITLE] DISABLED TRIGGERS
prompt ****************************************  
COL OWNER FOR A30
COL TABLE_NAME FOR A30
COL TRIGGER_NAME FOR A30
SELECT OWNER, NVL(TABLE_NAME, '<system trigger>') TABLE_NAME, TRIGGER_NAME
  FROM DBA_TRIGGERS
 WHERE STATUS = 'DISABLED'
 ORDER BY 1, 2, 3;
prompt ****************************************
prompt [TITLE] INVALID OBJECTS
prompt **************************************** 
col OBJECT_NAME for a30
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
  FROM DBA_OBJECTS
 WHERE STATUS = 'INVALID'
 ORDER BY 1, 2, 3;
prompt ****************************************
prompt [TITLE] RESOURCE_LIMIT
prompt ****************************************
col RESOURCE_NAME for a30  
SELECT /*+rule*/*
  FROM V$RESOURCE_LIMIT
 WHERE MAX_UTILIZATION /  DECODE(to_number(LIMIT_VALUE),0,1,to_number(LIMIT_VALUE)) > 0.9
   AND LIMIT_VALUE NOT LIKE '%UNLIMITED%';
select * from V$RESOURCE_LIMIT;
prompt ****************************************
prompt [TITLE] FAILED JOB
prompt ****************************************   
col WHAT for a30
SELECT JOB,
       TO_CHAR(LAST_DATE, 'yyyy-mm-dd hh24:mi:ss') "Last Date",
       TO_CHAR(THIS_DATE, 'yyyy-mm-dd hh24:mi:ss') "This Date",
       BROKEN,
       FAILURES,
       SCHEMA_USER,
       WHAT
  FROM DBA_JOBS
 WHERE BROKEN = 'Y'
    OR FAILURES > 0;
prompt ****************************************
prompt [TITLE] OVERDUE JOB
prompt ****************************************  
SELECT /*+rule */JOB,
       TO_CHAR(LAST_DATE, 'yyyy-mm-dd hh24:mi:ss') "Last Date",
       TO_CHAR(THIS_DATE, 'yyyy-mm-dd hh24:mi:ss') "This Date",
       BROKEN,
       FAILURES,
       SCHEMA_USER,
       WHAT
  FROM DBA_JOBS
 WHERE JOB NOT IN (SELECT JOB FROM DBA_JOBS_RUNNING)
   AND BROKEN = 'N'
   AND NEXT_DATE < SYSDATE;
prompt ****************************************
prompt [TITLE] NON STATISTICS ON TABLE
prompt ****************************************     
SELECT DISTINCT OWNER "Schema"
  FROM DBA_TABLES
 WHERE NUM_ROWS IS NULL
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] NON STATISTICS ON TABLE PARTITION
prompt ****************************************  
SELECT DISTINCT TABLE_OWNER "Schema"
  FROM DBA_TAB_PARTITIONS
 WHERE NUM_ROWS IS NULL
   AND TABLE_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] NON STATISTICS ON INDEX
prompt ****************************************  
SELECT DISTINCT OWNER "Schema"
  FROM DBA_INDEXES
 WHERE LEAF_BLOCKS IS NULL
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] NON STATISTICS ON INDEX PARTITION
prompt ****************************************  
SELECT DISTINCT INDEX_OWNER "Schema"
  FROM DBA_IND_PARTITIONS
 WHERE LEAF_BLOCKS IS NULL
   AND INDEX_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
 ORDER BY 1;
prompt ****************************************
prompt [TITLE] TABLE FOR NON PK
prompt ****************************************   
SELECT OWNER, TABLE_NAME
  FROM DBA_TABLES
 WHERE OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
MINUS
SELECT OWNER, TABLE_NAME
  FROM DBA_CONSTRAINTS
 WHERE CONSTRAINT_TYPE = 'P'
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB');
prompt ****************************************
prompt [TITLE] FK FOR NO INDEX
prompt ****************************************  	
col OWNER for a30                                                        
col TABLE_NAME for a30                                                           
col CONSTRAINT_NAME for a30                                              
col COLUMN_NAME for a30         
SELECT ACC.OWNER, ACC.TABLE_NAME, ACC.CONSTRAINT_NAME, ACC.COLUMN_NAME
  FROM ALL_CONS_COLUMNS ACC, ALL_CONSTRAINTS AC
 WHERE AC.CONSTRAINT_NAME = ACC.CONSTRAINT_NAME
   AND AC.CONSTRAINT_TYPE = 'R'
   AND ACC.OWNER NOT IN ('SYS', 'SYSTEM')
   AND (ACC.OWNER, ACC.TABLE_NAME, ACC.COLUMN_NAME, ACC.POSITION) IN
       (SELECT ACC.OWNER, ACC.TABLE_NAME, ACC.COLUMN_NAME, ACC.POSITION
	  FROM ALL_CONS_COLUMNS ACC, ALL_CONSTRAINTS AC
	 WHERE AC.CONSTRAINT_NAME = ACC.CONSTRAINT_NAME
	   AND AC.CONSTRAINT_TYPE = 'R'
	MINUS
	SELECT TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION
	  FROM ALL_IND_COLUMNS)
 ORDER BY ACC.OWNER, ACC.TABLE_NAME, ACC.CONSTRAINT_NAME, ACC.COLUMN_NAME;
prompt ****************************************************************************************************************************
prompt
prompt
prompt ****************************************
prompt [TITLE] backup check -- datafile
prompt ****************************************  
select 'FILE_ID='||FILE_ID||' 2天内未备份' FROM (
SELECT FILE_ID FROM DBA_DATA_FILES
MINUS
SELECT DISTINCT FILE# FROM V$BACKUP_DATAFILE WHERE COMPLETION_TIME > SYSDATE - 2);

prompt ****************************************
prompt [TITLE] backup check -- archivelog
prompt ****************************************  
SELECT NAME,first_time FROM v$archived_log WHERE deleted<>'YES' AND FIRST_TIME BETWEEN SYSDATE - 100 AND SYSDATE;

prompt ****************************************************************************************************************************
prompt
prompt
prompt ****************************************
prompt [TITLE] LC_Reload_Ratio
prompt ****************************************             
SELECT ROUND((SUM(RELOADS) / SUM(PINS)) * 100, 4) "LC_Reload_Ratio%"
  FROM V$LIBRARYCACHE;
prompt ****************************************
prompt [TITLE] DC_Miss_Ratio
prompt ****************************************   
SELECT ROUND((((SUM(GETMISSES)) / SUM(GETS)) * 100), 4) "DC_Miss_Ratio%"
  FROM V$ROWCACHE;
prompt ****************************************
prompt [TITLE] SHARED_POOL_ADVICE
prompt ****************************************  	
SELECT SHARED_POOL_SIZE_FOR_ESTIMATE "Shared Pool Size(estimate)",
       SHARED_POOL_SIZE_FACTOR       "Factor",
       ESTD_LC_SIZE                  "Libarary Cache Size",
       ESTD_LC_TIME_SAVED            "time Saved"
  FROM V$SHARED_POOL_ADVICE;
prompt ****************************************
prompt [TITLE] SHARED_POOL
prompt ****************************************   
SELECT ROUND(SUM(A.BYTES) / (1024 * 1024), 2) "Used(MB)",
       ROUND(MAX(P.VALUE) / (1024 * 1024), 2) "Size(MB)",
       ROUND((MAX(P.VALUE) / (1024 * 1024)) -
	     (SUM(A.BYTES) / (1024 * 1024)),
	     2) "Avail(MB)",
       ROUND((SUM(A.BYTES) / MAX(P.VALUE)) * 100, 2) "Used(%)"
  FROM V$SGASTAT A,
       (SELECT DECODE(SIGN(INSTR(UPPER(VALUE), 'K') +
			   INSTR(UPPER(VALUE), 'M')),
		      0,
		      VALUE,
		      1,
		      DECODE(SIGN(INSTR(UPPER(VALUE), 'K')),	     
			     1,
			     TO_NUMBER(1024 *
				       RTRIM(SUBSTR(VALUE,
						    1,
						    INSTR(UPPER(VALUE), 'K') - 1))),
			     TO_NUMBER(1024 * 1024 *
				       RTRIM(SUBSTR(VALUE,
						    1,
						    INSTR(UPPER(VALUE), 'M') - 1))))) VALUE
	  FROM V$PARAMETER
	 WHERE NAME LIKE 'shared_pool_size') P
 WHERE A.NAME IN ('reserved stopper', 'table definiti', 'dictionary cache',
	'library cache', 'sql area', 'PL/SQL DIANA', 'SEQ S.O.');
prompt ****************************************
prompt [TITLE] BC_Hit_Ratio
prompt ****************************************   
SELECT ROUND(100 *
	     (1 - (PHYSICAL_READS / (DB_BLOCK_GETS + CONSISTENT_GETS))),
	     4) "BC_Hit_Ratio"
  FROM V$BUFFER_POOL_STATISTICS
 WHERE NAME = 'DEFAULT';
prompt ****************************************
prompt [TITLE] DB_CACHE_ADVICE
prompt ****************************************  
SELECT NAME "Pool Name",
       BLOCK_SIZE,
       SIZE_FOR_ESTIMATE "Buffer Size",
       SIZE_FACTOR "Factor",
       ESTD_PHYSICAL_READ_FACTOR "Phy_Read_Factor",
       ESTD_PHYSICAL_READS "ESTD_PHY_READS"
  FROM V$DB_CACHE_ADVICE
 WHERE ADVICE_STATUS = 'ON';
prompt ****************************************
prompt [TITLE] SoftParse_Hit_Ratio
prompt ****************************************  
SELECT ROUND(1 - MAX(DECODE(NAME, 'parse count (hard)', VALUE)) /
	     MAX(DECODE(NAME, 'parse count (total)', VALUE)),
	     2) "SoftParse_Hit_Ratio%"
  FROM V$SYSSTAT
 WHERE NAME IN ('parse count (total)', 'parse count (hard)');
prompt ****************************************
prompt [TITLE] Disk_Sort_Ratio％
prompt ****************************************  
SELECT A.VALUE "Sort(Disk)",
       B.VALUE "Sort(Memory)",
       ROUND(100 * (A.VALUE /
	     DECODE((A.VALUE + B.VALUE), 0, 1, (A.VALUE + B.VALUE))),
	     2) "Disk_Sort_Ratio％"
  FROM V$SYSSTAT A, V$SYSSTAT B
 WHERE A.NAME = 'sorts (disk)'
   AND B.NAME = 'sorts (memory)';
prompt ****************************************
prompt [TITLE] Log Buffer latch Contention
prompt ****************************************    
COL "Redo Name" FOR A20
SELECT NAME "Redo Name",
       GETS,
       MISSES,
       IMMEDIATE_GETS,
       IMMEDIATE_MISSES,
       DECODE(GETS, 0, 0, ROUND(MISSES / GETS * 100, 3)) "Miss_Ratio％",
       DECODE(IMMEDIATE_GETS + IMMEDIATE_MISSES,
	      0,
	      0,	      
	      ROUND(IMMEDIATE_MISSES / (IMMEDIATE_GETS + IMMEDIATE_MISSES) * 100,
		    3)) "Immediate Misses Ratio%"
  FROM V$LATCH
 WHERE NAME IN ('redo allocation', 'redo copy');
prompt ****************************************
prompt [TITLE] TOP 10 WAIT
prompt ****************************************
col event for a40  
SELECT *
  FROM (SELECT EVENT,
	       SUM(DECODE(WAIT_TIME, 0, 0, 1)) "Prev",
	       SUM(DECODE(WAIT_TIME, 0, 1, 0)) "Curr",
	       COUNT(*) "Total"
	  FROM V$SESSION_WAIT
	 GROUP BY EVENT
	 ORDER BY 4 DESC)
 WHERE ROWNUM <= 10;
prompt ****************************************
prompt [TITLE] BACKGROUND PROCESS WAIT
prompt ****************************************  
col event for a30
SELECT event,total_waits,total_timeouts,time_waited,average_wait
  FROM (SELECT ROWNUM RN, A.*
	  FROM V$SESSION_EVENT A
	 WHERE SID IN (SELECT SID FROM V$SESSION WHERE TYPE = 'BACKGROUND'
	   AND EVENT NOT IN(SELECT EVENT FROM perfstat.stats$idle_event))
	 ORDER BY TIME_WAITED DESC)
 WHERE ROWNUM <= 10;
prompt ****************************************
prompt [TITLE] TOP 10 PHYSICAL READ SQL
prompt ****************************************  
SELECT *
  FROM (SELECT PARSING_USER_ID EXECUTIONS,
	       SORTS,
	       COMMAND_TYPE,
	       DISK_READS,
	       SQL_TEXT
	  FROM V$SQLAREA
	 ORDER BY DISK_READS DESC)
 WHERE ROWNUM <= 10;
prompt ****************************************
prompt [TITLE] MORE BUFFER GETS SQL
prompt ****************************************  
SELECT * FROM(
SELECT BUFFER_GETS,
       EXECUTIONS,
       BUFFER_GETS / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) GETS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE BUFFER_GETS > 50000
 ORDER BY BUFFER_GETS DESC)
 WHERE ROWNUM<=10;
prompt ****************************************
prompt [TITLE] MORE DISK READS SQL
prompt ****************************************  
SELECT * FROM (
SELECT DISK_READS,
       EXECUTIONS,
       DISK_READS / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) READS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE DISK_READS > 10000
 ORDER BY DISK_READS DESC)
 WHERE ROWNUM <= 10;
prompt ****************************************
prompt [TITLE] MORE ROWS PORCESSED SQL
prompt ****************************************  
SELECT * FROM (
SELECT ROWS_PROCESSED,
       EXECUTIONS,
       ROWS_PROCESSED / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) ROWS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE ROWS_PROCESSED > 10000
 ORDER BY ROWS_PROCESSED DESC)
 WHERE ROWNUM <= 10; 
prompt ****************************************
prompt [TITLE] MORE EXPENSIVE SQL
prompt ****************************************
SELECT * FROM (  
SELECT BUFFER_GETS,
       LPAD(ROWS_PROCESSED ||
	    DECODE(USERS_OPENING + USERS_EXECUTING, 0, ' ', '*'),
	    20) "rows_processed",
       EXECUTIONS,
       LOADS,     
       (DECODE(ROWS_PROCESSED, 0, 1, 1)) * BUFFER_GETS /
       DECODE(ROWS_PROCESSED, 0, 1, ROWS_PROCESSED) AVG_COST,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE DECODE(ROWS_PROCESSED, 0, 1, 1) * BUFFER_GETS /
       DECODE(ROWS_PROCESSED, 0, 1, ROWS_PROCESSED) > 10000ORDER BY 5 DESC
) WHERE ROWNUM <=10;
       
set linesize 130
col OWNER for a15
col OBJECT_NAME for a30
col SUBOBJECT_NAME for a30
col OBJECT_TYPE for a10
col STATISTIC_NAME for a20
col VALUE for 999,999,999,999
prompt ****************************************
prompt [TITLE] HIGH ITL WAIT OBJECTS
prompt ****************************************  
SELECT OWNER,
       OBJECT_NAME,
       SUBOBJECT_NAME,
       OBJECT_TYPE,
       STATISTIC_NAME,
       VALUE
  FROM V$SEGMENT_STATISTICS
 WHERE STATISTIC_NAME = 'ITL waits'
   AND VALUE > 100
 ORDER BY VALUE DESC;
 
prompt ****************************************
prompt [TITLE] HIGH ROW LOCK OBJECTS
prompt ****************************************  
SELECT OWNER,
       OBJECT_NAME,
       SUBOBJECT_NAME,
       OBJECT_TYPE,
       STATISTIC_NAME,
       VALUE
  FROM V$SEGMENT_STATISTICS
 WHERE STATISTIC_NAME = 'row lock waits'
   AND VALUE > 100
 ORDER BY VALUE DESC;

prompt ****************************************
prompt [TITLE] BIG INDEX
prompt ****************************************  
col OWNER       for a15                     
col INDEX_NAME  for a30                                                                        
col INDEX_MB    for 999,999,999   
col TABLE_OWNER for a15                   
col TABLE_NAME  for a30                                                                        
col TABLE_MB    for 999,999,999   
SELECT OWNER,SEGMENT_NAME INDEX_NAME,MB INDEX_MB,TABLE_OWNER,TABLE_NAME,TABLE_MB
  FROM (SELECT OWNER,SEGMENT_NAME,MB,TABLE_OWNER,TABLE_NAME,RN,COU,TYPE,
     	       LAG(MB, RN - 1, 0) OVER(PARTITION BY TABLE_OWNER, TABLE_NAME ORDER BY RN) TABLE_MB
	  FROM (SELECT OWNER,SEGMENT_NAME,MB,TABLE_OWNER,TABLE_NAME,TYPE,
	               ROW_NUMBER() OVER(PARTITION BY TABLE_OWNER, TABLE_NAME ORDER BY TYPE DESC) RN,
                       COUNT(*) OVER(PARTITION BY TABLE_OWNER, TABLE_NAME) COU
                  FROM (SELECT OWNER,SEGMENT_NAME,MB,NVL(TABLE_OWNER, OWNER) TABLE_OWNER,NVL(TABLE_NAME, SEGMENT_NAME) TABLE_NAME,NVL2(TABLE_NAME, 'INDEX', 'TABLE') TYPE
                          FROM (SELECT AA.*, BB.TABLE_OWNER, BB.TABLE_NAME
                                  FROM (SELECT A.OWNER,
                                               A.SEGMENT_NAME,
                                               SUM(BYTES / 1024 / 1024) MB
                                          FROM DBA_SEGMENTS A
                                        -- WHERE OWNER = 'QYW'
                                         WHERE OWNER NOT IN('SYS','SYSTEM','MONITOR','ETL','FILEDB','MGMT_VIEW','OUTLN','DBSNMP','WMSYS','EXFSYS','SYSMAN','TSMSYS','DIP')
                                         GROUP BY A.OWNER, A.SEGMENT_NAME) AA,
                                       DBA_INDEXES BB
                                 WHERE AA.SEGMENT_NAME = BB.INDEX_NAME(+)) AAA)))
 WHERE COU > 1 AND RN > 1 AND TABLE_MB>100 AND MB/TABLE_MB > 0.5; 

prompt ****************************************
prompt [TITLE] AAS FOR STATSPACK
prompt **************************************** 
set linesize 260
SET pagesize 50
col SNAP_TIME for a15
col NEXT_SNAP_TIME for a15
--AAS
SELECT to_char(AA.SNAP_TIME,'yyyymmdd hh24MI') SNAP_TIME,
       to_char(AA.NEXT_SNAP_TIME,'yyyymmdd hh24MI') NEXT_SNAP_TIME,
       ROUND(CPU_TIME, 0) CPU_TIME,
       ROUND(TIME_WAITED, 0) TIME_WAITED,
       ROUND((CPU_TIME + TIME_WAITED) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) AAS,
       ROUND((CPU_TIME) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) CPU_AAS,
       ROUND((TIME_WAITED) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) WAIT_AAS       
  FROM (SELECT SNAP_ID,
               SNAP_TIME,
               NEXT_SNAP_TIME,
               NEXT_TIME_WAITED - TIME_WAITED TIME_WAITED
          FROM (SELECT SNAP_ID,
                       LEAD(SNAP_ID) OVER(ORDER BY SNAP_ID) NEXT_SNAP_ID,
                       SNAP_TIME,
                       LEAD(SNAP_TIME) OVER(ORDER BY SNAP_ID) NEXT_SNAP_TIME,
                       TIME_WAITED,
                       LEAD(TIME_WAITED) OVER(ORDER BY SNAP_ID) NEXT_TIME_WAITED
                  FROM (SELECT A.SNAP_ID,
                               B.SNAP_TIME,
                               SUM(TIME_WAITED_MICRO) / 1000000 TIME_WAITED
                          FROM PERFSTAT.STATS$SYSTEM_EVENT A,
                               PERFSTAT.STATS$SNAPSHOT     B
                         WHERE A.SNAP_ID = B.SNAP_ID
                            -- 时间范围
                           AND B.SNAP_TIME BETWEEN SYSDATE - 30 AND SYSDATE
                           AND b.instance_number=(SELECT instance_number FROM v$instance)
                           AND A.EVENT NOT IN
                               (SELECT EVENT FROM PERFSTAT.STATS$IDLE_EVENT)
                         GROUP BY A.SNAP_ID, B.SNAP_TIME))) AA,
       (SELECT SNAP_ID,
               SNAP_TIME,
               LEAD(SNAP_TIME) OVER(ORDER BY SNAP_ID) NEXT_SNAP_TIME,
               NAME,
               (LEAD(VALUE) OVER(ORDER BY SNAP_ID) - VALUE) / 100 CPU_TIME
          FROM (SELECT A.SNAP_ID, B.SNAP_TIME, A.NAME, A.VALUE
                  FROM PERFSTAT.STATS$SYSSTAT A, PERFSTAT.STATS$SNAPSHOT B
                 WHERE A.SNAP_ID = B.SNAP_ID
                   AND b.instance_number=(SELECT instance_number FROM v$instance)
                    -- 时间范围
                   AND B.SNAP_TIME BETWEEN SYSDATE - 30 AND SYSDATE
                   AND NAME = 'CPU used by this session')) BB
 WHERE AA.SNAP_ID = BB.SNAP_ID;
--WAIT AAS
col event1 FOR a30
col event2 FOR a30
col event3 FOR a30
SELECT *
  FROM (SELECT to_char(SNAP_TIME,'yyyymmdd hh24MI') SNAP_TIME,
               to_char(NEXT_SNAP_TIME,'yyyymmdd hh24MI') NEXT_SNAP_TIME,
               EVENT EVENT1,
               TIME_WAITED TIME_WAITED1,
               AAS AAS1,
               RATIO RATIO1,
               LEAD(EVENT, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) EVENT2,
               LEAD(TIME_WAITED, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) TIME_WAITED2,
               LEAD(AAS, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) AAS2,
               LEAD(RATIO, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) RATIO2,
               LEAD(EVENT, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) EVENT3,
               LEAD(TIME_WAITED, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) TIME_WAITED3,
               LEAD(AAS, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) AAS3,
               LEAD(RATIO, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) RATIO3,
               RN
          FROM (SELECT SNAP_TIME,
                       NEXT_SNAP_TIME,
                       EVENT,
                       TIME_WAITED,
                       ROUND(TIME_WAITED /
                             ((NEXT_SNAP_TIME - SNAP_TIME) * 24 * 60 * 60),
                             2) AAS,
                       ROUND(TIME_WAITED / TOTAL_TIME_WAITED * 100, 2) RATIO,
                       RN
                  FROM (SELECT SNAP_TIME,
                               NEXT_SNAP_TIME,
                               EVENT,
                               TIME_WAITED,
                               SUM(TIME_WAITED) OVER(PARTITION BY SNAP_TIME) TOTAL_TIME_WAITED,
                               ROW_NUMBER() OVER(PARTITION BY SNAP_TIME ORDER BY TIME_WAITED DESC) RN
                          FROM (SELECT AA.SNAP_TIME,
                                       BB.SNAP_TIME NEXT_SNAP_TIME,
                                       AA.EVENT,
                                       ROUND(BB.TIME_WAITED - AA.TIME_WAITED, 2) TIME_WAITED
                                  FROM (SELECT A.SNAP_ID,
                                               B.SNAP_TIME,
                                               A.EVENT,
                                               A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
                                               dense_rank() OVER(ORDER BY B.SNAP_ID) DS
                                          FROM PERFSTAT.STATS$SYSTEM_EVENT A,
                                               PERFSTAT.STATS$SNAPSHOT     B
                                         WHERE A.SNAP_ID = B.SNAP_ID
                                           AND B.INSTANCE_NUMBER = (SELECT instance_number FROM v$instance)
                                            -- 时间范围
                                           AND B.SNAP_TIME BETWEEN SYSDATE - 30 AND
                                               SYSDATE
                                           AND A.EVENT NOT IN
                                               (SELECT EVENT
                                                  FROM PERFSTAT.STATS$IDLE_EVENT)) AA,
                                       (SELECT A.SNAP_ID,
                                               B.SNAP_TIME,
                                               A.EVENT,
                                               A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
                                               dense_rank() OVER(ORDER BY B.SNAP_ID) DS
                                          FROM PERFSTAT.STATS$SYSTEM_EVENT A,
                                               PERFSTAT.STATS$SNAPSHOT     B
                                         WHERE A.SNAP_ID = B.SNAP_ID
                                           AND B.INSTANCE_NUMBER = (SELECT instance_number FROM v$instance)
                                            -- 时间范围
                                           AND B.SNAP_TIME BETWEEN SYSDATE - 30 AND
                                               SYSDATE
                                           AND A.EVENT NOT IN
                                               (SELECT EVENT
                                                  FROM PERFSTAT.STATS$IDLE_EVENT)) BB
                                 WHERE AA.DS = BB.DS - 1
                                   AND AA.EVENT = BB.EVENT))
                 WHERE RN <= 3))
 WHERE RN = 1;
prompt ****************************************
prompt [TITLE] AAS FOR AWR
prompt ****************************************   
--AAS
SELECT to_char(AA.SNAP_TIME,'yyyymmdd hh24mi') SNAP_TIME,
       to_char(AA.NEXT_SNAP_TIME,'yyyymmdd hh24mi') NEXT_SNAP_TIME,
       TRUNC((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60) DB_TIME,
       ROUND(CPU_TIME, 0) CPU_TIME,
       ROUND(TIME_WAITED, 0) TIME_WAITED,
       ROUND((CPU_TIME + TIME_WAITED) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) AAS,
       ROUND((CPU_TIME) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) CPU_AAS,
       ROUND((TIME_WAITED) /
             ((AA.NEXT_SNAP_TIME - AA.SNAP_TIME) * 24 * 60 * 60),
             0) WAIT_AAS 
  FROM (SELECT SNAP_ID,
               SNAP_TIME,
               NEXT_SNAP_TIME,
               NEXT_TIME_WAITED - TIME_WAITED TIME_WAITED
          FROM (SELECT SNAP_ID,
                       LEAD(SNAP_ID) OVER(ORDER BY SNAP_ID) NEXT_SNAP_ID,
                       SNAP_TIME,
                       LEAD(SNAP_TIME) OVER(ORDER BY SNAP_ID) NEXT_SNAP_TIME,
                       TIME_WAITED,
                       LEAD(TIME_WAITED) OVER(ORDER BY SNAP_ID) NEXT_TIME_WAITED
                  FROM (SELECT A.SNAP_ID,
                               to_date(to_char(end_interval_time,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
                               SUM(TIME_WAITED_MICRO) / 1000000 TIME_WAITED
                          FROM dba_hist_system_event A,
                               dba_hist_snapshot     B
                         WHERE A.SNAP_ID = B.SNAP_ID
                           AND B.instance_number=(SELECT instance_number FROM v$instance)
                            -- 时间范围
                           AND B.end_interval_time BETWEEN SYSDATE - 7 AND SYSDATE
                           AND a.wait_class <> 'Idle'
                         GROUP BY A.SNAP_ID, B.end_interval_time))) AA,
       (SELECT SNAP_ID,
               SNAP_TIME,
               LEAD(SNAP_TIME) OVER(ORDER BY SNAP_ID) NEXT_SNAP_TIME,
               NAME,
               (LEAD(VALUE) OVER(ORDER BY SNAP_ID) - VALUE) / 100 CPU_TIME
          FROM (SELECT A.SNAP_ID, to_date(to_char(end_interval_time,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') SNAP_TIME, A.stat_NAME NAME, A.VALUE
                  FROM dba_hist_sysstat A, dba_hist_snapshot B
                 WHERE A.SNAP_ID = B.SNAP_ID
                   AND B.instance_number=(SELECT instance_number FROM v$instance)
                    -- 时间范围
                   AND B.end_interval_time BETWEEN SYSDATE - 7 AND SYSDATE
                   AND stat_NAME = 'CPU used by this session')) BB
 WHERE AA.SNAP_ID = BB.SNAP_ID AND aa.next_snap_time IS NOT NULL;     
--event
col event1 FOR a30
col event2 FOR a30
col event3 FOR a30
SELECT *
  FROM (SELECT TO_CHAR(SNAP_TIME,'YYYYMMDD HH24MI') SNAP_TIME,
               TO_CHAR(NEXT_SNAP_TIME,'YYYYMMDD HH24MI') NEXT_SNAP_TIME,
               EVENT EVENT1,
               TIME_WAITED TIME_WAITED1,
               AAS AAS1,
               RATIO RATIO1,
               LEAD(EVENT, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) EVENT2,
               LEAD(TIME_WAITED, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) TIME_WAITED2,
               LEAD(AAS, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) AAS2,
               LEAD(RATIO, 1, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) RATIO2,
               LEAD(EVENT, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) EVENT3,
               LEAD(TIME_WAITED, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) TIME_WAITED3,
               LEAD(AAS, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) AAS3,
               LEAD(RATIO, 2, 0) OVER(PARTITION BY SNAP_TIME ORDER BY RN) RATIO3,
               RN
          FROM (SELECT SNAP_TIME,
                       NEXT_SNAP_TIME,
                       EVENT,
                       TIME_WAITED,
                       ROUND(TIME_WAITED /
                             ((NEXT_SNAP_TIME - SNAP_TIME) * 24 * 60 * 60),
                             2) AAS,
                       ROUND(TIME_WAITED / TOTAL_TIME_WAITED * 100, 2) RATIO,
                       RN
                  FROM (SELECT SNAP_TIME,
                               NEXT_SNAP_TIME,
                               EVENT,
                               TIME_WAITED,
                               SUM(TIME_WAITED) OVER(PARTITION BY SNAP_TIME) TOTAL_TIME_WAITED,
                               ROW_NUMBER() OVER(PARTITION BY SNAP_TIME ORDER BY TIME_WAITED DESC) RN
                          FROM (SELECT AA.SNAP_TIME,
                                       BB.SNAP_TIME NEXT_SNAP_TIME,
                                       AA.EVENT,
                                       ROUND(BB.TIME_WAITED - AA.TIME_WAITED, 2) TIME_WAITED
                                  FROM (SELECT A.SNAP_ID,
                                               to_date(to_char(end_interval_time,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
                                               A.event_name EVENT,
                                               A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
                                               dense_rank() OVER(ORDER BY B.SNAP_ID) DS
                                          FROM dba_hist_system_event A,
                                               dba_hist_snapshot     B
                                         WHERE A.SNAP_ID = B.SNAP_ID
                                           AND B.instance_number=(SELECT instance_number FROM v$instance)
                                            -- 时间范围
                                           AND B.end_interval_time BETWEEN SYSDATE - 7 AND
                                               SYSDATE
                                           AND a.wait_class <> 'Idle') AA,
                                       (SELECT A.SNAP_ID,
                                               to_date(to_char(end_interval_time,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
                                               A.event_name EVENT,
                                               A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
                                               dense_rank() OVER(ORDER BY B.SNAP_ID) DS
                                          FROM dba_hist_system_event A,
                                               dba_hist_snapshot     B
                                         WHERE A.SNAP_ID = B.SNAP_ID
                                           AND B.instance_number=(SELECT instance_number FROM v$instance)
                                            -- 时间范围
                                           AND B.end_interval_time BETWEEN SYSDATE - 7 AND
                                               SYSDATE
                                           AND a.wait_class <> 'Idle') BB
                                 WHERE AA.DS = BB.DS - 1
                                   AND AA.EVENT = BB.EVENT))
                 WHERE RN <= 3))
 WHERE RN = 1; 
 
set linesize 130
prompt ****************************************************************************************************************************
prompt 
prompt 
prompt ****************************************
prompt [TITLE] alert.log check
prompt ****************************************
BREAK ON THEDATE
SET LINESIZE 150
SET PAGESIZE 9999
COL MSG_LINE FOR A130
COL THEDATE FOR A15
col INSTANCE_NUMBER new_value IID noprint
select '_'||INSTANCE_NUMBER INSTANCE_NUMBER from v$instance;

SELECT TO_CHAR(THEDATE,'YYYYMMDDHH24MISS') THEDATE,MSG_LINE
  FROM (SELECT *
          FROM (SELECT LINENO,
                       MSG_LINE,
                       THEDATE,
                       MAX(CASE
                             WHEN ORA_ERROR LIKE 'ORA-%' OR ORA_ERROR LIKE '% cannot %'THEN
                              RTRIM(SUBSTR(ORA_ERROR, 1, INSTR(ORA_ERROR, ' ') - 1),
                                    ':')
                             ELSE
                              NULL
                           END) OVER(PARTITION BY THEDATE) ORA_ERROR
                  FROM (SELECT LINENO,
                               MSG_LINE,
                               MAX(THEDATE) OVER(ORDER BY LINENO) THEDATE,
                               LEAD(MSG_LINE) OVER(ORDER BY LINENO) ORA_ERROR
                          FROM (SELECT ROWNUM LINENO,
                                       SUBSTR(MSG_LINE, 1, 132) MSG_LINE,
                                       CASE
                                         WHEN MSG_LINE LIKE
                                              '___ ___ __ __:__:__ ____' THEN
                                          TO_DATE(MSG_LINE,
                                                  'Dy Mon DD hh24:mi:ss yyyy')
                                         ELSE
                                          NULL
                                       END THEDATE
                                  FROM ALERT_FILE_EXT&IID))))
 WHERE ORA_ERROR IS NOT NULL
   AND THEDATE > SYSDATE-120
 ORDER BY THEDATE 
/
prompt ****************************************************************************************************************************
prompt 
prompt 
prompt ****************************************
prompt [TITLE] TABLESPACE FOR DATAFILE
prompt ****************************************
set pagesize 100   
COL "TableSpace Name" FOR A20
COL "File Name" FOR A30
col "Size (MB)" for a15
col "Used (MB)" for a15
col "Used %" for a15
SELECT A.TABLESPACE_NAME "TableSpace Name",
       A.FILE_NAME "File Name",
       A.STATUS "Status",
       A.AUTOEXTENSIBLE "Auto",
       TO_CHAR(NVL(A.BYTES / 1024 / 1024, 0), '99G999G990D900') "Size (MB)",
       TO_CHAR(NVL(A.BYTES - NVL(F.BYTES, 0), 0) / 1024 / 1024,
	       '99G999G990D900') "Used (MB)",
       TO_CHAR(NVL((A.BYTES - NVL(F.BYTES, 0)) / A.BYTES * 100, 0),
	       '990D00') "Used %"
  FROM DBA_DATA_FILES A,
       (SELECT FILE_ID, SUM(BYTES) BYTES
	  FROM DBA_FREE_SPACE
	 GROUP BY FILE_ID) F
 WHERE A.FILE_ID = F.FILE_ID(+)
 ORDER BY A.TABLESPACE_NAME, A.FILE_ID;
prompt ****************************************
prompt [TITLE] TEMPSPACE FOR PERM DATAFILE
prompt **************************************** 
SELECT TABLESPACE_NAME, CONTENTS
  FROM DBA_TABLESPACES
 WHERE CONTENTS = 'TEMPORARY'
   AND TABLESPACE_NAME NOT IN (SELECT TABLESPACE_NAME FROM DBA_TEMP_FILES);
prompt ****************************************
prompt [TITLE] TABLESPACE FOR OFFLINE
prompt ****************************************    
SELECT F.TABLESPACE_NAME, F.FILE_NAME, D.STATUS
  FROM DBA_DATA_FILES F, V$DATAFILE D
 WHERE D.STATUS = 'OFFLINE'
   AND F.FILE_ID = FILE#(+);
prompt ****************************************
prompt [TITLE] TABLESPACE FOR RECOVER
prompt ****************************************     
SELECT F.TABLESPACE_NAME, F.FILE_NAME
  FROM DBA_DATA_FILES F, V$RECOVER_FILE R
 WHERE F.FILE_ID = R.FILE#; 
prompt ****************************************
prompt [TITLE] 50+ EXTENTS AND 30% FRAGMENT
prompt ****************************************  
SELECT S.TABLESPACE_NAME,
       ROUND(100 * F.HOLE_COUNT / (F.HOLE_COUNT + S.SEG_COUNT)) PCT_FRAGMENTED,
       S.SEG_COUNT SEGMENTS,
       F.HOLE_COUNT HOLES
  FROM (SELECT TABLESPACE_NAME, COUNT(*) SEG_COUNT
	  FROM DBA_SEGMENTS
	 GROUP BY TABLESPACE_NAME) S,
       (SELECT TABLESPACE_NAME, COUNT(*) HOLE_COUNT
	  FROM DBA_FREE_SPACE
	 GROUP BY TABLESPACE_NAME) F
 WHERE S.TABLESPACE_NAME = F.TABLESPACE_NAME
   AND S.TABLESPACE_NAME IN
       (SELECT TABLESPACE_NAME
	  FROM DBA_TABLESPACES
	 WHERE CONTENTS = 'PERMANENT')
   AND S.TABLESPACE_NAME NOT IN ('SYSTEM')
   AND 100 * F.HOLE_COUNT / (F.HOLE_COUNT + S.SEG_COUNT) > 30
   AND S.SEG_COUNT > 50;
prompt ****************************************
prompt [TITLE] IO FOR TABLESPACE
prompt ****************************************  
col TS_NAME for a20
SELECT T.NAME      TS_NAME,
       F.NAME      FILE_NAME,
       S.PHYRDS    PHY_READS,
       S.PHYBLKRD  PHY_BLOCKREADS,
       S.PHYWRTS   PHY_WRITES,
       S.PHYBLKWRT PHY_BLOCKWRITES
  FROM GV$TABLESPACE T, GV$DATAFILE F, GV$FILESTAT S
 WHERE T.TS# = F.TS#
   AND F.FILE# = S.FILE#
 ORDER BY S.PHYRDS DESC, S.PHYWRTS DESC;
prompt ****************************************
prompt [TITLE] IO FOR DATAFILE
prompt ****************************************   
SELECT TS.NAME "Table Space",
       D.NAME "File Name",
       FS.PHYRDS "Phys Rds",
       DECODE(FSTOT.SUM_PH_RDS,
	      0,
	      0,	      
	      ROUND(100 * FS.PHYRDS / FSTOT.SUM_PH_RDS, 2)) "% Phys Rds",
       FS.PHYWRTS "Phys Wrts",
       DECODE(FSTOT.SUM_PH_WRTS,
	      0,
	      0,	      
	      ROUND(100 * FS.PHYWRTS / FSTOT.SUM_PH_WRTS, 2)) "% Phys Wrts"
  FROM V$FILESTAT FS,
       V$DATAFILE D,
       V$TABLESPACE TS,
       (SELECT SUM(PHYRDS) SUM_PH_RDS,
	       SUM(PHYWRTS) SUM_PH_WRTS,
	       SUM(PHYBLKRD) SUM_BL_RDS,
	       SUM(PHYBLKWRT) SUM_BL_WRTS
	  FROM V$FILESTAT) FSTOT
 WHERE D.FILE# = FS.FILE#
   AND D.TS# = TS.TS#;
prompt ****************************************
prompt [TITLE] EXTENT EXTEND CHECK
prompt ****************************************   
col segment_name for a30  
SELECT INITCAP(SEGMENT_TYPE) "Type",
       OWNER,
       SEGMENT_NAME,
       BYTES,
       NEXT_EXTENT,
       ROUND(100 * NEXT_EXTENT / BYTES) "Percent(Next/Bytes)"
  FROM DBA_SEGMENTS
 WHERE ((ROUND(100 * NEXT_EXTENT / BYTES) < 10) OR
       (ROUND(100 * NEXT_EXTENT / BYTES) >= 200))
   AND SEGMENT_TYPE NOT IN ('ROLLBACK', 'TEMPORARY', 'CACHE', 'TYPE2 UNDO')
 ORDER BY 2, 3, 1;
prompt ****************************************
prompt [TITLE] SEGMENT USE > 90% SEGMENT MAX 
prompt ****************************************  
col SEGMENT_NAME for a30
SELECT SEGMENT_TYPE,
       OWNER,
       SEGMENT_NAME,
       TABLESPACE_NAME,
       PARTITION_NAME,
       ROUND(BYTES / 1024 / 1024) "Size(MB)",
       EXTENTS,
       MAX_EXTENTS
  FROM DBA_SEGMENTS
 WHERE SEGMENT_TYPE NOT IN ('ROLLBACK', 'TEMPORARY', 'CACHE', 'TYPE2 UNDO')
   AND EXTENTS >= (1 - (10 / 100)) * MAX_EXTENTS
   AND MAX_EXTENTS > 1
 ORDER BY BYTES / MAX_EXTENTS DESC;
prompt ****************************************
prompt [TITLE] SEGMENT WITH >100 EXTENTS 
prompt ****************************************  
col PARTITION_NAME for a20
SELECT SEGMENT_TYPE, OWNER, SEGMENT_NAME, EXTENTS, PARTITION_NAME
  FROM DBA_SEGMENTS
 WHERE SEGMENT_TYPE NOT IN ('ROLLBACK', 'TEMPORARY', 'CACHE', 'TYPE2 UNDO')      
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB')
   AND EXTENTS > 100;
/*  太慢
prompt ****************************************
prompt TABLESPACE FULL,SO OBJECT CANN'T EXTEND  
prompt ****************************************     
SELECT A.TABLESPACE_NAME,
       A.OWNER,
       DECODE(A.PARTITION_NAME,
	      NULL,
	      A.SEGMENT_NAME,
	      A.SEGMENT_NAME || '.' || A.PARTITION_NAME) "Segment Name",
       A.EXTENTS,
       ROUND(NEXT_EXTENT / 1024) NEXT_EXTENT_KB,
       ROUND(B.FREE / 1024) TS_FREE_KB,
       ROUND(C.MOREBYTES / 1024 / 1024) TS_GROWTH_MB
  FROM DBA_SEGMENTS A,
       (SELECT DF.TABLESPACE_NAME, NVL(MAX(FS.BYTES), 0) FREE
	  FROM DBA_DATA_FILES DF, DBA_FREE_SPACE FS
	 WHERE DF.FILE_ID = FS.FILE_ID(+)
	 GROUP BY DF.TABLESPACE_NAME) B,
       (SELECT TABLESPACE_NAME,
	       MAX(MAXBYTES - BYTES) MOREBYTES,
	       SUM(DECODE(AUTOEXTENSIBLE, 'YES', 1, 0)) AUTOEXTENSIBLE
	  FROM DBA_DATA_FILES
	 GROUP BY TABLESPACE_NAME) C
 WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME
   AND A.TABLESPACE_NAME = C.TABLESPACE_NAME
   AND ((C.AUTOEXTENSIBLE = 0) OR
       ((C.AUTOEXTENSIBLE > 0) AND (A.NEXT_EXTENT > C.MOREBYTES)))
   AND A.NEXT_EXTENT > B.FREE
 ORDER BY 1;
*/
prompt ****************************************
prompt [TITLE] TABLE HAVE 6+ INDEX
prompt ****************************************  
SELECT TABLE_OWNER, TABLE_NAME, COUNT(*) INDEX_COUNT
  FROM DBA_INDEXES
 WHERE TABLE_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB') HAVING
 COUNT(*) > 6
 GROUP BY TABLE_OWNER, TABLE_NAME
 ORDER BY 3 DESC;
prompt ****************************************
prompt [TITLE] LOCK OBJECTS CHECK
prompt **************************************** 
COL TABLE_NAME FOR A30
COL SESSION_ID FOR 999999
COL SERIAL# FOR 999999
COL ACTION FOR A20
col OSUSER for a20 
COL AP_PROCESS_ID FOR 999999
COL DB_PROCESS_ID FOR 999999
SELECT DOB.OBJECT_NAME TABLE_NAME,
       LO.SESSION_ID,
       VSS.SERIAL#,
       VSS.ACTION ACTION,
       VSS.OSUSER OSUSER,
       VSS.PROCESS AP_PROCESS_ID,
       VPS.SPID DB_PROCESS_ID
  FROM V$LOCKED_OBJECT LO, DBA_OBJECTS DOB, V$SESSION VSS, V$PROCESS VPS
 WHERE LO.OBJECT_ID = DOB.OBJECT_ID
   AND LO.SESSION_ID = VSS.SID
   AND VSS.PADDR = VPS.ADDR
 ORDER BY 2, 3, DOB.OBJECT_NAME;
prompt ****************************************
prompt [TITLE] TOP IO WAIT OBJECTS
prompt ****************************************  
-- SELECT /*+ rule */
--  EVENT, SEGMENT_TYPE, SEGMENT_NAME, FILE_ID, BLOCK_ID, BLOCKS
--   FROM DBA_EXTENTS, GV$SESSION_WAIT
--  WHERE P1TEXT = 'file#'
--    AND P2TEXT = 'block#'
--    AND P1 = FILE_ID
--    AND P2 BETWEEN BLOCK_ID AND BLOCK_ID + BLOCKS
--  ORDER BY SEGMENT_TYPE, SEGMENT_NAME;
prompt ****************************************
prompt [TITLE] HARD PARSE
prompt ****************************************  
SELECT PLAN_HASH_VALUE, COU
  FROM (SELECT PLAN_HASH_VALUE, COU, ROWNUM RN
	  FROM (SELECT PLAN_HASH_VALUE, COUNT(*) COU
		  FROM V$SQL
		 WHERE PLAN_HASH_VALUE > 0
		 GROUP BY PLAN_HASH_VALUE
		 ORDER BY 2 DESC))
 WHERE RN <= 5; 
prompt ****************************************
prompt [TITLE] KEEP OBJECTS
prompt ****************************************  
-- col owner for a30
-- col object_name for a30
-- col SUBOBJECT_NAME for a30
-- SELECT AA.OWNER,
--        AA.OBJECT_NAME,
--        AA.SUBOBJECT_NAME,
--        C.BYTES / 1024 / 1024 MB,
--        TOUCH_COU
--   FROM (SELECT B.OWNER,
-- 	       B.OBJECT_NAME,
-- 	       B.SUBOBJECT_NAME,
-- 	       COUNT(A.TCH) TOUCH_COU
-- 	  FROM X$BH A, DBA_OBJECTS B
-- 	 WHERE A.OBJ = B.DATA_OBJECT_ID
-- 	 GROUP BY B.OWNER, B.OBJECT_NAME, B.SUBOBJECT_NAME) AA,
--        DBA_SEGMENTS C
--  WHERE AA.OWNER = C.OWNER
--    AND AA.OBJECT_NAME = C.SEGMENT_NAME
--    AND nvl(AA.SUBOBJECT_NAME,'1') = nvl(C.PARTITION_NAME,'1')
--    AND C.BYTES / 1024 / 1024 <= 1024
--    AND AA.OWNER NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'WMSYS')
--    AND TOUCH_COU > 1000
--  ORDER BY TOUCH_COU DESC;
prompt ****************************************
prompt [TITLE] KEEP SHARED_POOL OBJECTS
prompt ****************************************  
col name for a50
-- SELECT OWNER, NAME, SHARABLE_MEM, KEPT
--   FROM V$DB_OBJECT_CACHE
--  WHERE SHARABLE_MEM > 102400
--    AND KEPT = 'NO'
--    AND UPPER(SUBSTR(NAME, 1, 20)) NOT LIKE 'SELECT %'
--  ORDER BY SHARABLE_MEM DESC;
prompt ****************************************
prompt [TITLE] ROW CACHE MISS
prompt ****************************************  
SELECT PARAMETER,
       COUNT(GETS) GETS,
       COUNT(GETMISSES) GETMISSES,
       COUNT(GETMISSES) / COUNT(GETS) MISS_RATIO
  FROM V$ROWCACHE
 GROUP BY PARAMETER
HAVING COUNT(GETMISSES) / COUNT(GETS) > 0.1
 ORDER BY 4;

prompt ****************************************
prompt [TITLE] mlog check
prompt ****************************************  
select * from sys.slog$ where snaptime < sysdate -60;

prompt ****************************************
prompt [TITLE] lock check
prompt ****************************************  
select * from v$lock;

spool off

exit
