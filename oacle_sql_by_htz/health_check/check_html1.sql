-------------------------------------------------------------
-- health check script 
-- by zhangqiaoc
-- westzq@gmail.com
-------------------------------------------------------------

set termout off
set feedback off

set markup HTML ON HEAD " -
<style type='text/css'> - 
  body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
  p {   font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
        table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; -
        padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; white-space:nowrap;} -
  th {  font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; -
        padding:0px 0px 0px 0px;} -
  h1 {  font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
  h2 {  font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; -
        background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
</style> -
<title>SQL*Plus Report</title>" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP OFF PREFORMAT OFF

set pagesize 200

alter session set cursor_sharing=exact;
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

col filename new_value filename
SELECT instance_NAME||'_'||'check_'||host_name||'_'||to_char(sysdate,'yyyymmdd')||'.html' filename FROM v$instance;
spool &filename

---------------------------------------------------
------ [TITLE] BaseInfo
---------------------------------------------------
BREAK ON NAME
prompt <a name="BASEINFO"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>BaseInfo</b></font><hr align="left" width="460">
SELECT 'Instance Name' NAME,Instance_Name||'['||to_char(startup_time,'yyyy-mm-dd hh24:mi:ss')||']' VALUE FROM gv$instance
UNION ALL
SELECT 'Server Name',VALUE FROM v$parameter WHERE NAME = 'service_names'
UNION ALL
SELECT 'Usage','OLTP' FROM dual
UNION ALL
SELECT 'RDBMS Version/Release',banner  FROM v$version WHERE banner LIKE 'Oracle Database%' OR banner LIKE '%Enterprise%'
UNION ALL
SELECT 'SQL*Net Version/Release',banner  FROM v$version WHERE banner LIKE 'NLSRTL%'
UNION ALL
SELECT 'DB Total Size',SUM(BYTES)/1024/1024||' MB' FROM V$DATAFILE
UNION ALL
--SELECT 'DB Free Size',SUM(BYTES) / 1024 / 1024 ||' MB' FROM DBA_FREE_SPACE
--UNION ALL
SELECT parameter,VALUE FROM v$nls_parameters WHERE parameter ='NLS_TERRITORY'
UNION ALL
SELECT parameter,VALUE FROM v$nls_parameters WHERE parameter ='NLS_LANGUAGE'
UNION ALL
SELECT parameter,VALUE FROM v$nls_parameters WHERE parameter ='NLS_CHARACTERSET'
UNION ALL
SELECT parameter,VALUE FROM v$nls_parameters WHERE parameter ='NLS_NCHAR_CHARACTERSET'
UNION ALL
SELECT NAME,VALUE FROM v$parameter WHERE NAME = 'db_block_size'
UNION ALL
SELECT 'Number of Tablespaces',to_char(COUNT(*)) FROM dba_tablespaces
UNION ALL
SELECT 'Number of Datafiles',to_char(COUNT(*)) FROM V$DATAFILE
UNION ALL
SELECT 'TEMP Tablespace Size',B.NAME||':'||SUM(A.BYTES) / 1024 / 1024 "SIZE(MB)"
  FROM V$TEMPFILE A, V$TABLESPACE B
 WHERE A.TS# = B.TS#
 GROUP BY B.NAME
UNION ALL
SELECT 'UNDO Tablespace Size', B.TABLESPACE_NAME||':'||sum(A.BYTES) / 1024 / 1024 "SIZE(MB)"
   FROM DBA_DATA_FILES A, DBA_TABLESPACES B
  WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME
    AND B.CONTENTS = 'UNDO'
    GROUP BY B.TABLESPACE_NAME
UNION ALL
SELECT 'Number of control files',to_char(COUNT(*)) FROM v$controlfile
UNION ALL 
SELECT DISTINCT 'Redo Log Configure',
                ROUND(BYTES / 1024 / 1024, 2) || ' MB * ' || COUNT(*) OVER(PARTITION BY BYTES, COUNT(*)) || ' GROUPS * ' || COUNT(*) || ' MEMBERS' REDO_MEMBER
  FROM V$LOG A, V$LOGFILE B
 WHERE A.GROUP# = B.GROUP#
 GROUP BY A.GROUP#, BYTES
UNION ALL
SELECT 'Are the on-line redo logs the same size?',decode(COUNT(DISTINCT bytes),1,'Yes','No') FROM v$log
UNION ALL
SELECT 'Are the redo logs being multiplexed by Oracle?',decode(min(COUNT(*)),1,'NO','YES') FROM v$logfile GROUP BY group#
UNION ALL
SELECT 'Are members of each redo log group on a separate disk?',NULL FROM dual
UNION ALL
SELECT 'Are the redo logs on separate disks from the database files?',NULL FROM dual
UNION ALL
SELECT 'Are the redo logs on separate disks from the archive files?','YES' FROM dual
UNION ALL
SELECT 'Redo Log Generation Rate','INST' || INST_ID || ':' ||
       TRUNC(BYTES / 1024/1024 * CNT / (TIME * 24 * 60 * 60))||' mb/s'
  FROM (SELECT INST_ID,
               MAX(FIRST_TIME) - MIN(FIRST_TIME) TIME,
               COUNT(*) - 1 CNT,
               MAX(BYTES) BYTES
          FROM GV$LOG
         GROUP BY INST_ID)
UNION ALL
SELECT 'Archiving Enabled?',decode(log_mode,'ARCHIVELOG','YES','NO') FROM v$database
UNION ALL
SELECT 'Number of Concurrent Users',to_char(COUNT(*)) FROM v$session WHERE status='ACTIVE' AND USERNAME IS NOT NULL
UNION ALL
SELECT 'User Access Method','TNS' FROM dual
UNION ALL
SELECT 'Availability Requirements','7*24' FROM dual;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
clear breaks;
---------------------------------------------------
------ [TITLE] REGISTRY
---------------------------------------------------  
prompt <a name="REGISTRY"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Registry</b></font><hr align="left" width="460">
SELECT comp_id,
       comp_name,
       version,
       status,
       modified,
       control
  FROM dba_registry;
SELECT * FROM dba_registry_history;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] SGA
---------------------------------------------------  
prompt <a name="SGA"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SGA</b></font><hr align="left" width="460">
SELECT NAME, TO_CHAR(VALUE) "value(Byte)"
  FROM V$SGA
UNION ALL
SELECT NAME, VALUE
  FROM V$PARAMETER
 WHERE NAME IN
       ('shared pool_size', 'large_pool_size', 'java_pool_size', 'lock_sga');       
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] SPFILE?
--------------------------------------------------- 
prompt <a name="SPFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Spfile?</b></font><hr align="left" width="460">
SELECT NVL(VALUE, 'pfile') "Parameter_File"
  FROM V$PARAMETER
 WHERE NAME = 'spfile'; 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] PARAMETER
--------------------------------------------------- 
prompt <a name="PARAMETER"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Parameter</b></font><hr align="left" width="460">
SELECT NAME, RTRIM(VALUE) "pvalue"
  FROM V$PARAMETER
 WHERE ISDEFAULT = 'FALSE'
 ORDER BY NAME;

SELECT '[LISTENER*TAF]' || NAME, RTRIM(VALUE) "pvalue"
  FROM V$PARAMETER
 WHERE NAME IN ('cluster_database', 'cluster_database_instances',
	'local_listener', 'remote_listener')
 ORDER BY NAME;
SELECT '[BLOCKCHECKING]' || NAME, RTRIM(VALUE) "pvalue"
  FROM V$PARAMETER
 WHERE NAME IN ('db_block_checking', 'db_block_checksum')
 ORDER BY NAME; 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] backup check -- datafile
---------------------------------------------------  
prompt <a name="BACKUPDF1"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Backup Check(2 day)</b></font><hr align="left" width="460">
SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME
  FROM DBA_DATA_FILES
 WHERE FILE_ID IN (SELECT FILE_ID
		     FROM DBA_DATA_FILES
		   MINUS
		   SELECT DISTINCT FILE#
		     FROM V$BACKUP_DATAFILE
		    WHERE COMPLETION_TIME > SYSDATE - 2);
prompt <center><a class="noLink" href="#top">Top</a></center><p>

prompt <a name="BACKUPDF2"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Backup Check(7 day)</b></font><hr align="left" width="460">
SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME
  FROM DBA_DATA_FILES
 WHERE FILE_ID IN (SELECT FILE_ID
		     FROM DBA_DATA_FILES
		   MINUS
		   SELECT DISTINCT FILE#
		     FROM V$BACKUP_DATAFILE
		    WHERE COMPLETION_TIME > SYSDATE - 7);
prompt <center><a class="noLink" href="#top">Top</a></center><p>

prompt <a name="BACKUPDF3"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Backup Check(15 day)</b></font><hr align="left" width="460">
SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME
  FROM DBA_DATA_FILES
 WHERE FILE_ID IN (SELECT FILE_ID
		     FROM DBA_DATA_FILES
		   MINUS
		   SELECT DISTINCT FILE#
		     FROM V$BACKUP_DATAFILE
		    WHERE COMPLETION_TIME > SYSDATE - 15);
prompt <center><a class="noLink" href="#top">Top</a></center><p>

prompt <a name="BACKUPDF4"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Backup Check(30 day)</b></font><hr align="left" width="460">
SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME
  FROM DBA_DATA_FILES
 WHERE FILE_ID IN (SELECT FILE_ID
		     FROM DBA_DATA_FILES
		   MINUS
		   SELECT DISTINCT FILE#
		     FROM V$BACKUP_DATAFILE
		    WHERE COMPLETION_TIME > SYSDATE - 30);
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] backup check -- archivelog
---------------------------------------------------  
prompt <a name="BACKUPLOG"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archivelog Backup Check</b></font><hr align="left" width="460">
SELECT NAME,first_time FROM v$archived_log WHERE deleted<>'YES' AND FIRST_TIME < SYSDATE-1;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] RMAN tuning 
---------------------------------------------------  
prompt <a name="RMANTUNING"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN tuning</b></font><hr align="left" width="460">
SELECT INST_ID, NAME, VALUE, ISDEFAULT
  FROM GV$PARAMETER
 WHERE NAME IN
       ('large_pool_size', 'backup_tape_io_slaves', 'dbwr_io_slaves');
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] CONTROLFILE
---------------------------------------------------
prompt <a name="CONTROLFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ControlFile</b></font><hr align="left" width="460">
SELECT NAME, STATUS FROM V$CONTROLFILE;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] REDOFILE
--------------------------------------------------- 
prompt <a name="REDOFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo File Info</b></font><hr align="left" width="460">
SELECT F.GROUP#,
       F.MEMBER "Redo File",
       F.TYPE,
       L.STATUS,
       L.BYTES / 1024 / 1024 "Size(MB)"
  FROM V$LOG L, V$LOGFILE F
 WHERE L.GROUP# = F.GROUP#; 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] RedoLogSwitch
--------------------------------------------------- 
prompt <a name="REODLOGSWITCH"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Log Switches</b></font><hr align="left" width="460">
COLUMN DAY   FORMAT a75              HEADING 'Day / Time'  ENTMAP off
COLUMN H00   FORMAT 999,999B         HEADING '00'          ENTMAP off
COLUMN H01   FORMAT 999,999B         HEADING '01'          ENTMAP off
COLUMN H02   FORMAT 999,999B         HEADING '02'          ENTMAP off
COLUMN H03   FORMAT 999,999B         HEADING '03'          ENTMAP off
COLUMN H04   FORMAT 999,999B         HEADING '04'          ENTMAP off
COLUMN H05   FORMAT 999,999B         HEADING '05'          ENTMAP off
COLUMN H06   FORMAT 999,999B         HEADING '06'          ENTMAP off
COLUMN H07   FORMAT 999,999B         HEADING '07'          ENTMAP off
COLUMN H08   FORMAT 999,999B         HEADING '08'          ENTMAP off
COLUMN H09   FORMAT 999,999B         HEADING '09'          ENTMAP off
COLUMN H10   FORMAT 999,999B         HEADING '10'          ENTMAP off
COLUMN H11   FORMAT 999,999B         HEADING '11'          ENTMAP off
COLUMN H12   FORMAT 999,999B         HEADING '12'          ENTMAP off
COLUMN H13   FORMAT 999,999B         HEADING '13'          ENTMAP off
COLUMN H14   FORMAT 999,999B         HEADING '14'          ENTMAP off
COLUMN H15   FORMAT 999,999B         HEADING '15'          ENTMAP off
COLUMN H16   FORMAT 999,999B         HEADING '16'          ENTMAP off
COLUMN H17   FORMAT 999,999B         HEADING '17'          ENTMAP off
COLUMN H18   FORMAT 999,999B         HEADING '18'          ENTMAP off
COLUMN H19   FORMAT 999,999B         HEADING '19'          ENTMAP off
COLUMN H20   FORMAT 999,999B         HEADING '20'          ENTMAP off
COLUMN H21   FORMAT 999,999B         HEADING '21'          ENTMAP off
COLUMN H22   FORMAT 999,999B         HEADING '22'          ENTMAP off
COLUMN H23   FORMAT 999,999B         HEADING '23'          ENTMAP off
COLUMN TOTAL FORMAT 999,999,999      HEADING 'Total'       ENTMAP off  
SELECT
    '<div align="center"><font color="#336699"><b>' || SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH:MI:SS'),1,5)  || '</b></font></div>'  DAY
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'00',1,0)) H00
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'01',1,0)) H01
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'02',1,0)) H02
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'03',1,0)) H03
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'04',1,0)) H04
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'05',1,0)) H05
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'06',1,0)) H06
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'07',1,0)) H07
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'08',1,0)) H08
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'09',1,0)) H09
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'10',1,0)) H10
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'11',1,0)) H11
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'12',1,0)) H12
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'13',1,0)) H13
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'14',1,0)) H14
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'15',1,0)) H15
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'16',1,0)) H16
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'17',1,0)) H17
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'18',1,0)) H18
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'19',1,0)) H19
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'20',1,0)) H20
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'21',1,0)) H21
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'22',1,0)) H22
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'23',1,0)) H23
  , COUNT(*)                                                                      TOTAL
FROM
  v$log_history  a
GROUP BY SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH:MI:SS'),1,5)
/
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
---------------------------------------------------
------ [TITLE] Time For Arch
--------------------------------------------------- 
prompt <a name="REODLOGSWITCH"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Time For Arch</b></font><hr align="left" width="460">
select * from(
SELECT NAME,
       BLOCKS * BLOCK_SIZE / 1024 / 1024 SIZE_MB,
       TRUNC((A.COMPLETION_TIME - A.NEXT_TIME) * 24 * 60 * 60) ARCH_TIME_S,
       BLOCKS * BLOCK_SIZE / 1024 / 1024 /
       DECODE(((A.COMPLETION_TIME - A.NEXT_TIME) * 24 * 60 * 60),
	      0,
	      1,
	      ((A.COMPLETION_TIME - A.NEXT_TIME) * 24 * 60 * 60)) RATE
  FROM V$ARCHIVED_LOG A
 ORDER BY NEXT_TIME DESC)
 where rownum < 31;
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
---------------------------------------------------
------ [TITLE] ARCHIVE PARAMETERS
--------------------------------------------------- 
prompt <a name="ARCHPARA"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ARCHIVE PARAMETERS</b></font><hr align="left" width="460">
SELECT NAME,VALUE FROM v$parameter WHERE NAME LIKE '%archive%' AND VALUE IS NOT NULL;
SELECT rpad(FORCE_LOGGING,15,' ') "FORCE_LOGGING",
       rpad(SUPPLEMENTAL_LOG_DATA_MIN,15,' ') "SUPPLEMENTAL_LOG_DATA_MIN",
       rpad(SUPPLEMENTAL_LOG_DATA_PK ,15,' ')"SUPPLEMENTAL_LOG_DATA_PK",
       rpad(SUPPLEMENTAL_LOG_DATA_UI,15,' ') "SUPPLEMENTAL_LOG_DATA_UI"
  FROM V$DATABASE;
SELECT TABLESPACE_NAME,FORCE_LOGGING "FORCE_LOGGING" FROM DBA_TABLESPACES;
select flashback_on from v$database;
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
---------------------------------------------------
------ [TITLE] FRA USAGE
--------------------------------------------------- 
prompt <a name="FRAUSAGE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>FRA USAGE</b></font><hr align="left" width="460">
  SELECT /*+no_merge(a) no_merge(b)*/
   FILE_TYPE,
   PERCENT_SPACE_USED,
   PERCENT_SPACE_RECLAIMABLE,
   NUMBER_OF_FILES,
   SUM(PERCENT_SPACE_USED) OVER(PARTITION BY 1) PERCENT_TOTAL_USED,
   B.VALUE * (100 - (SUM(PERCENT_SPACE_USED) OVER(PARTITION BY 1))) / 100 / 1024 / 1024 / 1024 TOTAL_FREE_GB
    FROM V$FLASH_RECOVERY_AREA_USAGE A,
	 (SELECT VALUE
	    FROM V$PARAMETER
	   WHERE NAME = 'db_recovery_file_dest_size') B;
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
---------------------------------------------------
------ [TITLE] DATAFILE
---------------------------------------------------
prompt <a name="DATAFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Info</b></font><hr align="left" width="460">
SELECT TABLESPACE_NAME,
       FILE_NAME,
       STATUS,
       AUTOEXTENSIBLE "Auto",
       BYTES / 1024 / 1024 "Total Size(MB)"
  FROM DBA_DATA_FILES
 ORDER BY TABLESPACE_NAME, FILE_ID;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TEMP TABLESPACE
---------------------------------------------------
prompt <a name="TEMPSPACE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TEMP TABLESPACE</b></font><hr align="left" width="460">
SELECT A.TABLESPACE_NAME, A.INITIAL_EXTENT, A.NEXT_EXTENT
  FROM DBA_TABLESPACES A
 WHERE CONTENTS = 'TEMPORARY';
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLESPACE
--------------------------------------------------- 
prompt <a name="TABLESPACE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TableSpace Info</b></font><hr align="left" width="460">
-- SELECT D.TABLESPACE_NAME "Name",
--        D.STATUS "Status",
--        D.CONTENTS "Type",
--        D.logging,
--        D.force_logging,
--        D.extent_management||'['||D.allocation_type||']['||segment_space_management||']' management,
--        TO_CHAR(NVL(A.BYTES / 1024 / 1024, 0), '99G999G990D900') "Size(MB)",      
--        TO_CHAR(NVL(A.BYTES - NVL(F.BYTES, 0), 0) / 1024 / 1024,
--                '99G999G990D900') "Used(MB)",
--        TO_CHAR(NVL((A.BYTES - NVL(F.BYTES, 0)) / A.BYTES * 100, 0),
--                '990D00') "Used％"
--   FROM SYS.DBA_TABLESPACES D,
--        (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES
--           FROM DBA_DATA_FILES
--          GROUP BY TABLESPACE_NAME) A,
--        (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES
--           FROM DBA_FREE_SPACE
--          GROUP BY TABLESPACE_NAME) F
--  WHERE D.TABLESPACE_NAME = A.TABLESPACE_NAME(+)
--    AND D.TABLESPACE_NAME = F.TABLESPACE_NAME(+) 
--  ORDER BY 9 DESC;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLESPACE FOR OFFLINE
---------------------------------------------------    
prompt <a name="TBSFOROFF"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Offline TBS</b></font><hr align="left" width="460">
SELECT F.TABLESPACE_NAME, F.FILE_NAME, D.STATUS
  FROM DBA_DATA_FILES F, V$DATAFILE D
 WHERE D.STATUS = 'OFFLINE'
   AND F.FILE_ID = FILE#(+);
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLESPACE FOR RECOVER
---------------------------------------------------     
prompt <a name="TBSFORRECO"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Recover TBS</b></font><hr align="left" width="460">
SELECT F.TABLESPACE_NAME, F.FILE_NAME
  FROM DBA_DATA_FILES F, V$RECOVER_FILE R
 WHERE F.FILE_ID = R.FILE#; 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Undo Segments
---------------------------------------------------   
prompt <a name="UNDOSEG"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Undo Segment Info</b></font><hr align="left" width="460">
select segment_name,
       tablespace_name,
       initial_extent,
       next_extent,
       min_extents,
       max_extents,
       pct_increase
  from dba_rollback_segs;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Undo Stats
---------------------------------------------------   
prompt <a name="UNDOSEG"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Undo Stats</b></font><hr align="left" width="460">
SELECT *
  FROM (SELECT SEGMENT_NAME,
	       WAITS,
	       GETS,
	       ROUND(100 * (WAITS / GETS), 2) RATIO,
	       SHRINKS,
	       WRAPS,
	       ROUND((A.RSSIZE + 8192) / 1024 / 1024, 2) RSSIZE,
	       ROUND(A.HWMSIZE / 1024 / 1024, 2) HWMSIZE,
	       A.OPTSIZE / 1024 / 1024 OPTMAL,
	       C.INSTANCE_NAME
	  FROM GV$ROLLSTAT A,
	       DBA_ROLLBACK_SEGS B,
	       (SELECT INST_ID, VALUE INSTANCE_NAME
		  FROM GV$PARAMETER
		 WHERE NAME = 'instance_name') C
	 WHERE A.USN = B.SEGMENT_ID
	   AND B.INSTANCE_NUM = C.INST_ID(+)
	 ORDER BY C.INSTANCE_NAME, SEGMENT_NAME);
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] PUBLICE SYN Point does not exist
---------------------------------------------------
prompt <a name="PUBLICSYN"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Public Syn Point Does Not Exist</b></font><hr align="left" width="460">
SELECT S.SYNONYM_NAME, S.TABLE_OWNER, S.TABLE_NAME
  FROM SYS.DBA_SYNONYMS S
 WHERE NOT EXISTS (SELECT 'x'
	  FROM SYS.DBA_OBJECTS O
	 WHERE O.OWNER = S.TABLE_OWNER
	   AND O.OBJECT_NAME = S.TABLE_NAME)
   AND DB_LINK IS NULL
   AND S.OWNER = 'PUBLIC'
 ORDER BY 1;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] PRIVATE SYN Point does not exist
---------------------------------------------------  
prompt <a name="PRIVATESYN"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Private Syn Point Does Not Exist</b></font><hr align="left" width="460">
SELECT S.OWNER, S.SYNONYM_NAME, S.TABLE_OWNER, S.TABLE_NAME
  FROM SYS.DBA_SYNONYMS S
 WHERE NOT EXISTS (SELECT 'x'
	  FROM SYS.DBA_OBJECTS O
	 WHERE O.OWNER = S.TABLE_OWNER
	   AND O.OBJECT_NAME = S.TABLE_NAME)
   AND DB_LINK IS NULL
   AND S.OWNER <> 'PUBLIC'
 ORDER BY 1;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Useless ROLE
---------------------------------------------------  
prompt <a name="USELESSROLE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Useless Role</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Useless Profile
---------------------------------------------------  
prompt <a name="USELESSPROFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Useless Profile</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] DISABLED CONSTRAINTS
---------------------------------------------------  
prompt <a name="DISCONS"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Disable Constraints</b></font><hr align="left" width="460">
SELECT OWNER, TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
  FROM DBA_CONSTRAINTS
 WHERE STATUS = 'DISABLED'
 ORDER BY 1, 2, 3;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] DISABLED TRIGGERS
---------------------------------------------------  
prompt <a name="DISTRIG"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Disable Triggers</b></font><hr align="left" width="460">
SELECT OWNER, NVL(TABLE_NAME, '<system trigger>') TABLE_NAME, TRIGGER_NAME
  FROM DBA_TRIGGERS
 WHERE STATUS = 'DISABLED'
 ORDER BY 1, 2, 3;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] INVALID OBJECTS
--------------------------------------------------- 
prompt <a name="INVALIDOBJ"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Invalid Objects</b></font><hr align="left" width="460">
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
  FROM DBA_OBJECTS
 WHERE STATUS = 'INVALID'
 ORDER BY 1, 2, 3;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] INVALID INDEX
--------------------------------------------------- 
prompt <a name="INVALIDIDX"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Invalid Indexes</b></font><hr align="left" width="460">
SELECT OWNER || '.' || INDEX_NAME INDEX_NAME, STATUS
  FROM DBA_INDEXES
 WHERE STATUS NOT IN ('VALID', 'N/A');
SELECT INDEX_OWNER || '.' || INDEX_NAME INDEX_NAME, PARTITION_NAME, STATUS
  FROM DBA_IND_PARTITIONS
 WHERE STATUS NOT IN ('VALID', 'N/A','USABLE');
SELECT INDEX_OWNER || '.' || INDEX_NAME INDEX_NAME,
       PARTITION_NAME,
       SUBPARTITION_NAME,
       STATUS
  FROM DBA_IND_SUBPARTITIONS
   WHERE STATUS <> 'USABLE' ;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Partition Table with noPartition Index
--------------------------------------------------- 
prompt <a name="PARTABWITHNOPARTIDX"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Table With noPartition Index</b></font><hr align="left" width="460">
SELECT owner,index_name
  FROM DBA_INDEXES
 WHERE (TABLE_OWNER, TABLE_NAME) IN
       (SELECT OWNER, TABLE_NAME FROM DBA_TABLES WHERE PARTITIONED = 'YES')
   AND PARTITIONED = 'NO';
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] RESOURCE_LIMIT
---------------------------------------------------
prompt <a name="RESOURCELIMIT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Resource Limit</b></font><hr align="left" width="460">
SELECT /*+rule*/*
  FROM V$RESOURCE_LIMIT
 WHERE MAX_UTILIZATION /  DECODE(to_number(LIMIT_VALUE),0,1,to_number(LIMIT_VALUE)) > 0.9
   AND LIMIT_VALUE NOT LIKE '%UNLIMITED%';
select * from V$RESOURCE_LIMIT;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] FAILED JOB
---------------------------------------------------   
prompt <a name="FAILEDJOB"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Failed Jobs</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] OVERDUE JOB
---------------------------------------------------  
prompt <a name="OVERDUEJOB"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Overdue Jobs</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] SEHEDULE JOB
---------------------------------------------------  
prompt <a name="SEHEDULE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Schedule Jobs</b></font><hr align="left" width="460">
SELECT OWNER,
       JOB_NAME,
       ENABLED,
       STATE,
       LAST_START_DATE,
       NEXT_RUN_DATE,
       JOB_CREATOR,
       PROGRAM_OWNER || '.' || PROGRAM_NAME PROGRAM_NAME,
       JOB_ACTION
  FROM DBA_SCHEDULER_JOBS;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] 2PC_Pending
---------------------------------------------------  
prompt <a name="PC2"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>2PC Pending</b></font><hr align="left" width="460">
SELECT * FROM dba_2pc_pending;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] NON STATISTICS ON TABLE
---------------------------------------------------     
prompt <a name="NOSTATSONTAB"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noStats On Table</b></font><hr align="left" width="460">
SELECT OWNER, TABLE_NAME, LAST_ANALYZED
  FROM DBA_TABLES
 WHERE (LAST_ANALYZED IS NULL OR LAST_ANALYZED < SYSDATE - 365)
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
   AND table_name NOT LIKE 'MLOG$%'
   AND temporary='N'
 ORDER BY LAST_ANALYZED;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] NON STATISTICS ON TABLE PARTITION
---------------------------------------------------  
prompt <a name="NOSTATSONTABPART"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noStats On Table Partition</b></font><hr align="left" width="460">
SELECT TABLE_OWNER,TABLE_NAME,PARTITION_NAME,LAST_ANALYZED
  FROM DBA_TAB_PARTITIONS
 WHERE (LAST_ANALYZED IS NULL OR LAST_ANALYZED < SYSDATE - 365)
   AND TABLE_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
   AND table_name NOT LIKE 'MLOG$%'
 ORDER BY LAST_ANALYZED;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] NON STATISTICS ON INDEX
---------------------------------------------------  
prompt <a name="NOSTATSONIDX"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noStats On Index</b></font><hr align="left" width="460">
SELECT OWNER,INDEX_NAME,LAST_ANALYZED
  FROM DBA_INDEXES
 WHERE (LAST_ANALYZED IS NULL OR LAST_ANALYZED < SYSDATE - 365)
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
 ORDER BY LAST_ANALYZED;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] NON STATISTICS ON INDEX PARTITION
---------------------------------------------------  
prompt <a name="NOSTATSONIDXPART"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noStats On Idx Partition</b></font><hr align="left" width="460">
SELECT INDEX_OWNER,INDEX_NAME,PARTITION_NAME,LAST_ANALYZED
  FROM DBA_IND_PARTITIONS
 WHERE (LAST_ANALYZED IS NULL OR LAST_ANALYZED < SYSDATE - 365)
   AND INDEX_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
 ORDER BY LAST_ANALYZED;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLE FOR NON PK
---------------------------------------------------   
prompt <a name="NOPKTAB"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noPK Table</b></font><hr align="left" width="460">
SELECT OWNER, TABLE_NAME
  FROM DBA_TABLES
 WHERE OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
   AND table_name NOT LIKE 'MLOG$%'
   AND temporary='N'
MINUS
SELECT OWNER, TABLE_NAME
  FROM DBA_CONSTRAINTS
 WHERE CONSTRAINT_TYPE = 'P'
   AND OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS','APPQOSSYS','OLAPSYS','APEX_030200','EXFSYS','ORDDATA',
        'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB','WMSYS','QUEST_SPM','QUEST','FOGLIGHT','PERFSTAT','SYSMAN','EXFSYS')
   AND table_name NOT LIKE 'MLOG$%';
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] FK FOR NO INDEX
---------------------------------------------------  	       
prompt <a name="NOIDXFK"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>noIdx FK</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] USERINFO
--------------------------------------------------- 
prompt <a name="USERINFO"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Info</b></font><hr align="left" width="460">
break on username on default_tablespace on temporary_tablespace on account_status on profile on default_role
select 	username, 
	default_tablespace, 
	temporary_tablespace,
	granted_role, 
	default_role,
	account_status,
	profile 
   from dba_users u,dba_role_privs r 
  where u.username = r.grantee 
  order by username;
ttitle off;
clear breaks;
break on username 
select 	username, 
	privilege 
   from dba_users u,dba_sys_privs c 
  where u.username = c.grantee 
  order by username;
clear breaks;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Special priv
---------------------------------------------------   
prompt <a name="SPECIALPRIV"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Special Privs</b></font><hr align="left" width="460">
SELECT GRANTEE "User has dba priv" FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE = 'DBA';

SELECT GRANTEE "User has drop_any_table priv" FROM DBA_SYS_PRIVS WHERE PRIVILEGE='DROP ANY TABLE';

SELECT USERNAME "User default tbs in sys" FROM dba_users WHERE default_tablespace IN ('SYSTEM','SYSAUX');

SELECT USERNAME "User temp tbs in sys" FROM dba_users WHERE default_tablespace IN ('SYSTEM','SYSAUX');
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Objects in the SYSTEM Tablespace
---------------------------------------------------   
prompt <a name="OBJINSYSTEM"></a>
prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Objects in the SYSTEM Tablespace</b></font><hr align="left" width="460">
select owner,segment_name,segment_type,ceil(bytes/1024/1024) "SIZE(M)",tablespace_name from dba_segments where tablespace_name='SYSTEM' and owner NOT in ('ORDSYS','WKSYS','WK_TEST','SYS','SYSTEM','SYSMAN','DBSNMP','ANONYMOUS','CTXSYS','OLAPSYS','WMSYS','OUTLN','XDB','CTXSYS','MDSYS','EXFSYS');
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
---------------------------------------------------
------ Password limit
---------------------------------------------------
prompt <a name="PASSWORDLIMIT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Password Limit</b></font><hr align="left" width="460">
select * from USER_PASSWORD_LIMITS;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ Profile
---------------------------------------------------
prompt <a name="PROFILE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Profile Info</b></font><hr align="left" width="460">
select * from dba_profiles order by PROFILE;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] mlog check
---------------------------------------------------  
prompt <a name="MLOG"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Slog Check</b></font><hr align="left" width="460">
select * from sys.slog$ where snaptime < sysdate -60;
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Mlog Check</b></font><hr align="left" width="460">
SELECT *
  FROM (SELECT OWNER, SEGMENT_NAME, TABLESPACE_NAME, BYTES
	  FROM DBA_SEGMENTS
	 WHERE SEGMENT_NAME LIKE 'MLOG%'
	 ORDER BY BYTES desc)
 WHERE ROWNUM < 21;
SELECT LOG_OWNER, MASTER, C.BYTES / 1024 / 1024 SIZE_MB
  FROM DBA_MVIEW_LOGS A, DBA_SEGMENTS C
 WHERE A.LOG_OWNER = C.OWNER
   AND A.LOG_TABLE = C.SEGMENT_NAME
   AND NOT EXISTS (SELECT 1
	  FROM SYS.SLOG$ B
	 WHERE A.LOG_OWNER = B.MOWNER
	   AND A.MASTER = B.MASTER)
 ORDER BY 3 DESC;   
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] lock check
---------------------------------------------------  
prompt <a name="LOCK"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Lock Check</b></font><hr align="left" width="460">
SELECT *
  FROM V$LOCK
 WHERE (TYPE, ID1) IN
       (SELECT DISTINCT TYPE, ID1 FROM V$LOCK WHERE REQUEST > 0)
 ORDER BY TYPE, ID1, lmode;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Hit Ratio
---------------------------------------------------   
prompt <a name="HITRATIO"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Hit Ratio</b></font><hr align="left" width="460">
SELECT 'Buffer Cache HIT%',
       ROUND(100 *
	     (1 - (PHYSICAL_READS / (DB_BLOCK_GETS + CONSISTENT_GETS))),
	     4) "BC_Hit_Ratio"
  FROM V$BUFFER_POOL_STATISTICS
 WHERE NAME = 'DEFAULT'
UNION ALL
SELECT 'Library Cache HIT%',
       ROUND(100 - (SUM(RELOADS) / SUM(PINS)) * 100, 2) "LC_Reload_Ratio%"
  FROM V$LIBRARYCACHE
UNION ALL
SELECT 'Dictionary Cache HIT%',
       ROUND((100 - ((SUM(GETMISSES)) / SUM(GETS)) * 100), 2) "DC_Miss_Ratio%"
  FROM V$ROWCACHE
UNION ALL
SELECT 'Soft Parse HIT%',
       ROUND(1 - MAX(DECODE(NAME, 'parse count (hard)', VALUE)) /
	     MAX(DECODE(NAME, 'parse count (total)', VALUE)),
	     4) * 100 "SoftParse_Hit_Ratio%"
  FROM V$SYSSTAT
 WHERE NAME IN ('parse count (total)', 'parse count (hard)')
UNION ALL
SELECT 'Buffer Sort HIT%',
       ROUND(100 -
	     100 * (A.VALUE /
	     DECODE((A.VALUE + B.VALUE), 0, 1, (A.VALUE + B.VALUE))),
	     2) "Disk_Sort_Ratio％"
  FROM V$SYSSTAT A, V$SYSSTAT B
 WHERE A.NAME = 'sorts (disk)'
   AND B.NAME = 'sorts (memory)';
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] DB_CACHE_ADVICE
---------------------------------------------------  
prompt <a name="DBCACHEADVICE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>DB Cache Advice</b></font><hr align="left" width="460">
SELECT NAME "Pool Name",
       BLOCK_SIZE,
       SIZE_FOR_ESTIMATE "Buffer Size",
       SIZE_FACTOR "Factor",
       ESTD_PHYSICAL_READ_FACTOR "Phy_Read_Factor",
       ESTD_PHYSICAL_READS "ESTD_PHY_READS"
  FROM V$DB_CACHE_ADVICE
 WHERE ADVICE_STATUS = 'ON';
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] SHARED_POOL_ADVICE
---------------------------------------------------  	
prompt <a name="SHAREDPOOLADIVE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Shared Pool Advice</b></font><hr align="left" width="460">
SELECT SHARED_POOL_SIZE_FOR_ESTIMATE "Shared Pool Size(estimate)",
       SHARED_POOL_SIZE_FACTOR       "Factor",
       ESTD_LC_SIZE                  "Libarary Cache Size",
       ESTD_LC_TIME_SAVED            "time Saved"
  FROM V$SHARED_POOL_ADVICE;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] SHARED_POOL
---------------------------------------------------   
prompt <a name="SHAREDPOOLINFO"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Shared Pool Info</b></font><hr align="left" width="460">
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

prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] Log Buffer latch Contention
---------------------------------------------------    
prompt <a name="LOGBUFFERLATCH"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Log Buffer latch Contention</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TOP 10 WAIT
---------------------------------------------------
prompt <a name="TOP10CURR"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TOP 10 Wait(Current)</b></font><hr align="left" width="460">
SELECT *
  FROM (SELECT EVENT,
	       SUM(DECODE(WAIT_TIME, 0, 0, 1)) "Prev",
	       SUM(DECODE(WAIT_TIME, 0, 1, 0)) "Curr",
	       COUNT(*) "Total"
	  FROM V$SESSION_WAIT
	 GROUP BY EVENT
	 ORDER BY 4 DESC)
 WHERE ROWNUM <= 10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>

prompt <a name="TOP10HIST"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TOP 10 Wait(Hist)</b></font><hr align="left" width="460"> 
SELECT *
  FROM (SELECT EVENT, TOTAL_WAITS, TIME_WAITED, AVERAGE_WAIT
	  FROM V$SYSTEM_EVENT
	 ORDER BY TIME_WAITED_MICRO DESC)
 WHERE ROWNUM <= 10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] BACKGROUND PROCESS WAIT
---------------------------------------------------  
prompt <a name="BACKWAIT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>BackGround Process Wait</b></font><hr align="left" width="460">
SELECT event,total_waits,total_timeouts,time_waited,average_wait
  FROM (SELECT ROWNUM RN, A.*
	  FROM V$SESSION_EVENT A
	 WHERE SID IN (SELECT SID FROM V$SESSION WHERE TYPE = 'BACKGROUND'
	   AND EVENT NOT IN(SELECT EVENT FROM perfstat.stats$idle_event))
	 ORDER BY TIME_WAITED DESC)
 WHERE ROWNUM <= 10;

SELECT event,total_waits,total_timeouts,time_waited,average_wait
  FROM (SELECT ROWNUM RN, A.*
	  FROM V$SESSION_EVENT A
	 WHERE SID IN (SELECT SID FROM V$SESSION WHERE TYPE = 'BACKGROUND'
           AND wait_class <> 'Idle')
         ORDER BY TIME_WAITED DESC)
 WHERE ROWNUM <= 10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] MORE BUFFER GETS SQL
---------------------------------------------------  
prompt <a name="TOPSQLBUFFER"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>More Buffer Gets SQL</b></font><hr align="left" width="460">
SELECT * FROM(
SELECT BUFFER_GETS,
       EXECUTIONS,
       BUFFER_GETS / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) GETS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE BUFFER_GETS > 50000
 ORDER BY 3 DESC)
 WHERE ROWNUM<=10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] MORE DISK READS SQL
---------------------------------------------------  
prompt <a name="TOPSQLDISK"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>More Disk Reads SQL</b></font><hr align="left" width="460">
SELECT * FROM (
SELECT DISK_READS,
       EXECUTIONS,
       DISK_READS / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) READS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE DISK_READS > 10000
 ORDER BY 3 DESC)
 WHERE ROWNUM <= 10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] MORE ROWS PORCESSED SQL
---------------------------------------------------  
prompt <a name="TOPSQLROWS"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>More Rows Processed SQL</b></font><hr align="left" width="460">
SELECT * FROM (
SELECT ROWS_PROCESSED,
       EXECUTIONS,
       ROWS_PROCESSED / DECODE(EXECUTIONS, 0, 1, EXECUTIONS) ROWS_PER_EXEC,
       HASH_VALUE,
       SQL_TEXT
  FROM V$SQLAREA
 WHERE ROWS_PROCESSED > 10000
 ORDER BY 3 DESC)
 WHERE ROWNUM <= 10; 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] MORE EXPENSIVE SQL
---------------------------------------------------
prompt <a name="TOPSQLEXP"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>More Expensive SQL</b></font><hr align="left" width="460">
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
       DECODE(ROWS_PROCESSED, 0, 1, ROWS_PROCESSED) > 10000 ORDER BY 5 DESC
) WHERE ROWNUM <=10;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] HIGH ITL WAIT OBJECTS
---------------------------------------------------  
prompt <a name="ITLWAIT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>High ITL Wait Objects</b></font><hr align="left" width="460">
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
 
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] HIGH ROW LOCK OBJECTS
---------------------------------------------------  
prompt <a name="LOCKWAIT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>High Row Lock Objects</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] HARD PARSE
---------------------------------------------------  
prompt <a name="HARDPARSE"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Hard Parse(maybe)</b></font><hr align="left" width="460">
break on PLAN_HASH_VALUE on CNT
SELECT *
  FROM (SELECT PLAN_HASH_VALUE, CNT, SQL_TEXT
	  FROM (SELECT PLAN_HASH_VALUE,
		       SQL_TEXT,
		       COUNT(*) OVER(PARTITION BY PLAN_HASH_VALUE) CNT,
		       ROW_NUMBER() OVER(PARTITION BY PLAN_HASH_VALUE ORDER BY '1') RN
		  FROM V$SQL
		 WHERE PLAN_HASH_VALUE > 0)
	 WHERE RN <= 5
	 ORDER BY CNT DESC)
 WHERE ROWNUM <= 25;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] AAS FOR STATSPACK
--------------------------------------------------- 
prompt <a name="AASFORSP"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AAS For Statspack</b></font><hr align="left" width="460">
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
                           AND B.SNAP_TIME BETWEEN SYSDATE - 7 AND SYSDATE
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
                   AND B.SNAP_TIME BETWEEN SYSDATE - 7 AND SYSDATE
                   AND NAME = 'CPU used by this session')) BB
 WHERE AA.SNAP_ID = BB.SNAP_ID;
--WAIT AAS
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
                                           AND B.SNAP_TIME BETWEEN SYSDATE - 7 AND
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
                                           AND B.SNAP_TIME BETWEEN SYSDATE - 7 AND
                                               SYSDATE
                                           AND A.EVENT NOT IN
                                               (SELECT EVENT
                                                  FROM PERFSTAT.STATS$IDLE_EVENT)) BB
                                 WHERE AA.DS = BB.DS - 1
                                   AND AA.EVENT = BB.EVENT))
                 WHERE RN <= 3))
 WHERE RN = 1;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] AAS FOR AWR
---------------------------------------------------   
prompt <a name="AASFORAWR"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AAS For AWR</b></font><hr align="left" width="460">
--AAS
SELECT TO_CHAR(AA.SNAP_TIME, 'yyyymmdd hh24mi') SNAP_TIME,
       TO_CHAR(AA.NEXT_SNAP_TIME, 'yyyymmdd hh24mi') NEXT_SNAP_TIME,
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
			       TO_DATE(TO_CHAR(END_INTERVAL_TIME,
					       'yyyy-mm-dd hh24:mi:ss'),
				       'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
			       SUM(TIME_WAITED_MICRO) / 1000000 TIME_WAITED
			  FROM DBA_HIST_SYSTEM_EVENT A, DBA_HIST_SNAPSHOT B
			 WHERE A.SNAP_ID = B.SNAP_ID
			   AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
			   AND B.INSTANCE_NUMBER =
			       (SELECT INSTANCE_NUMBER FROM V$INSTANCE)
			      -- 时间范围
			   AND B.END_INTERVAL_TIME BETWEEN SYSDATE - 7 AND
			       SYSDATE
			   AND A.WAIT_CLASS <> 'Idle'
			 GROUP BY A.SNAP_ID, B.END_INTERVAL_TIME))) AA,
       (SELECT SNAP_ID,
	       SNAP_TIME,
	       LEAD(SNAP_TIME) OVER(ORDER BY SNAP_ID) NEXT_SNAP_TIME,
	       NAME,
	       (LEAD(VALUE) OVER(ORDER BY SNAP_ID) - VALUE) / 100 CPU_TIME
	  FROM (SELECT A.SNAP_ID,
		       TO_DATE(TO_CHAR(END_INTERVAL_TIME,
				       'yyyy-mm-dd hh24:mi:ss'),
			       'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
		       A.STAT_NAME NAME,
		       A.VALUE
		  FROM DBA_HIST_SYSSTAT A, DBA_HIST_SNAPSHOT B
		 WHERE A.SNAP_ID = B.SNAP_ID
		   AND B.INSTANCE_NUMBER =
		       (SELECT INSTANCE_NUMBER FROM V$INSTANCE)
		   AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
		      -- 时间范围
		   AND B.END_INTERVAL_TIME BETWEEN SYSDATE - 7 AND SYSDATE
		   AND STAT_NAME = 'CPU used by this session')) BB
 WHERE AA.SNAP_ID = BB.SNAP_ID
   AND AA.NEXT_SNAP_TIME IS NOT NULL;
--event
SELECT *
  FROM (SELECT TO_CHAR(SNAP_TIME, 'YYYYMMDD HH24MI') SNAP_TIME,
	       TO_CHAR(NEXT_SNAP_TIME, 'YYYYMMDD HH24MI') NEXT_SNAP_TIME,
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
					       TO_DATE(TO_CHAR(END_INTERVAL_TIME,
							       'yyyy-mm-dd hh24:mi:ss'),
						       'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
					       A.EVENT_NAME EVENT,
					       A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
					       DENSE_RANK() OVER(ORDER BY B.SNAP_ID) DS
					  FROM DBA_HIST_SYSTEM_EVENT A,
					       DBA_HIST_SNAPSHOT     B
					 WHERE A.SNAP_ID = B.SNAP_ID
					   AND A.INSTANCE_NUMBER =
					       B.INSTANCE_NUMBER
					   AND B.INSTANCE_NUMBER =
					       (SELECT INSTANCE_NUMBER
						  FROM V$INSTANCE)
					      -- 时间范围
					   AND B.END_INTERVAL_TIME BETWEEN
					       SYSDATE - 7 AND SYSDATE
					   AND A.WAIT_CLASS <> 'Idle') AA,
				       (SELECT A.SNAP_ID,
					       TO_DATE(TO_CHAR(END_INTERVAL_TIME,
							       'yyyy-mm-dd hh24:mi:ss'),
						       'yyyy-mm-dd hh24:mi:ss') SNAP_TIME,
					       A.EVENT_NAME EVENT,
					       A.TIME_WAITED_MICRO / 1000000 TIME_WAITED,
					       DENSE_RANK() OVER(ORDER BY B.SNAP_ID) DS
					  FROM DBA_HIST_SYSTEM_EVENT A,
					       DBA_HIST_SNAPSHOT     B
					 WHERE A.SNAP_ID = B.SNAP_ID
					   AND A.INSTANCE_NUMBER =
					       B.INSTANCE_NUMBER      
					   AND B.INSTANCE_NUMBER =
					       (SELECT INSTANCE_NUMBER
						  FROM V$INSTANCE)
					      -- 时间范围
					   AND B.END_INTERVAL_TIME BETWEEN
					       SYSDATE - 7 AND SYSDATE
					   AND A.WAIT_CLASS <> 'Idle') BB
				 WHERE AA.DS = BB.DS - 1
				   AND AA.EVENT = BB.EVENT))
		 WHERE RN <= 3))
 WHERE RN = 1;  
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] alert.log check
---------------------------------------------------
prompt <a name="ALERT"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Alert Log Check</b></font><hr align="left" width="460">
BREAK ON THEDATE
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

prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLESPACE FOR DATAFILE
---------------------------------------------------
prompt <a name="TBSFORDF"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TBS For Datafile</b></font><hr align="left" width="460">
--SELECT A.TABLESPACE_NAME "TableSpace Name",
--       A.FILE_NAME "File Name",
--       A.STATUS "Status",
--       A.AUTOEXTENSIBLE "Auto",
--       TO_CHAR(NVL(A.BYTES / 1024 / 1024, 0), '99G999G990D900') "Size (MB)",
--       TO_CHAR(NVL(A.BYTES - NVL(F.BYTES, 0), 0) / 1024 / 1024,
--	       '99G999G990D900') "Used (MB)",
--       TO_CHAR(NVL((A.BYTES - NVL(F.BYTES, 0)) / A.BYTES * 100, 0),
--	       '990D00') "Used %"
--  FROM DBA_DATA_FILES A,
--       (SELECT FILE_ID, SUM(BYTES) BYTES
--	  FROM DBA_FREE_SPACE
--	 GROUP BY FILE_ID) F
-- WHERE A.FILE_ID = F.FILE_ID(+)
-- ORDER BY A.TABLESPACE_NAME, A.FILE_ID;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TEMPSPACE FOR PERM DATAFILE
--------------------------------------------------- 
prompt <a name="TEMPFORPERM"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tempspace For Perm Datafile</b></font><hr align="left" width="460">
SELECT TABLESPACE_NAME, CONTENTS
  FROM DBA_TABLESPACES
 WHERE CONTENTS = 'TEMPORARY'
   AND TABLESPACE_NAME NOT IN (SELECT TABLESPACE_NAME FROM DBA_TEMP_FILES);
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] IO FOR TABLESPACE
---------------------------------------------------  
prompt <a name="IOTBS"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>TBS IO</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] IO FOR DATAFILE
---------------------------------------------------   
prompt <a name="IODF"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile IO</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] TABLE HAVE 6+ INDEX
---------------------------------------------------  
prompt <a name="TABINDEXS"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Table Have 6+ Idx</b></font><hr align="left" width="460">
SELECT TABLE_OWNER, TABLE_NAME, COUNT(*) INDEX_COUNT
  FROM DBA_INDEXES
 WHERE TABLE_OWNER NOT IN
       ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'ORDSYS', 'ORDPLUGINS', 'MDSYS',
	'CTXSYS', 'AURORA$ORB$UNAUTHENTICATED', 'XDB') HAVING
 COUNT(*) > 6
 GROUP BY TABLE_OWNER, TABLE_NAME
 ORDER BY 3 DESC;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] LOCK OBJECTS CHECK
--------------------------------------------------- 
prompt <a name="LOCKOBJ"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Lock Object Check</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] ROW CACHE MISS
---------------------------------------------------  
prompt <a name="ROWCACHEMISS"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Row Cache Miss</b></font><hr align="left" width="460">
SELECT PARAMETER,
       COUNT(GETS) GETS,
       COUNT(GETMISSES) GETMISSES,
       COUNT(GETMISSES) / COUNT(GETS) MISS_RATIO
  FROM V$ROWCACHE
 GROUP BY PARAMETER
HAVING COUNT(GETMISSES) / COUNT(GETS) > 0.1
 ORDER BY 4;
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] BIG INDEX
---------------------------------------------------    
prompt <a name="BIGIDX"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Big Index</b></font><hr align="left" width="460">
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
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] BIG TABLE WITHOUT PARTITION
---------------------------------------------------    
prompt <a name="BIGTAB"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Big Table With Out Partition</b></font><hr align="left" width="460">
SELECT owner,segment_name table_name,round(bytes/1024/1024,2) SIZE_MB
  FROM DBA_SEGMENTS A
 WHERE SEGMENT_TYPE = 'TABLE'
   AND BYTES > 2 * 1024 * 1024 * 1024
   AND NOT EXISTS (SELECT *
	  FROM DBA_PART_TABLES B
	 WHERE A.OWNER = B.OWNER
	   AND A.SEGMENT_NAME = B.TABLE_NAME);   
prompt <center><a class="noLink" href="#top">Top</a></center><p>
---------------------------------------------------
------ [TITLE] ASM CHECK
--------------------------------------------------- 
prompt <a name="ASMCHECK"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ASM check</b></font><hr align="left" width="460">
select * from v$asm_diskgroup_stat;
select * from v$asm_disk_stat;
SELECT * FROM v$asm_operation;
prompt <center><a class="noLink" href="#top">Top</a></center><p>


---------------------------------------------------
------ [TITLE] ADVISOR
--------------------------------------------------- 
prompt <a name="ADVISOR"></a>
prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ADVISOR</b></font><hr align="left" width="460">
SELECT owner,attr2 FROM dba_advisor_actions WHERE command='SHRINK SPACE';
SELECT attr1,attr2,attr3,message FROM dba_advisor_actions WHERE command='ALTER PARAMETER';
SELECT MESSAGE FROM DBA_ADVISOR_ACTIONS WHERE COMMAND = 'UNDEFINED';

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

spool off

SET MARKUP HTML OFF

SET TERMOUT ON

