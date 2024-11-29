set echo off;
set lines 200 pages 1000 heading on verify off;
col file_name new_value file_name noprint;
select 'migrate_check_info_'||to_char(sysdate,'yyyymmddhh24miss')||'_'||name file_name from v$database;
spool &file_name;
col owner              for  a30                  heading 'OWNER';
col object_type        for  a30                  heading 'OBJECT_TYPE';
col table_name         for  a32                  heading 'TABLE_NAME';
col segment_name       for  a32                  heading 'SEGMENT_NAME';
col total_size         for  9999999999           heading 'TOTAL_SIZE';
col lob_size           for  9999999999           heading 'LOB_SIZE';
col table_size         for  9999999999           heading 'TABLE_SIZE';
col index_size         for  9999999999           heading 'INDEX_SIZE';
col segment_size.      for  9999999999           heading 'SEGMENT_SIZE';

col used_space         for  9999999999
col total_space        for  9999999999
col new_date           for  a20
col Tablespace         for  a20
col DATA_TYPE          for  a20
col name               for  a40
col display_value      for  a100
col directory_name     for  a30
col directory_path     for  a100
col version            for  a10
col id                 for  9999999999
col comments           for  a50


col  tablespace_name   for  a15                      heading 'TABLESPACE';
col  file_id           for  9999                     heading 'FILE|ID';
col  RELATIVE_FNO      for  9999                     heading 'RFID';
col  status            for  a10                      heading 'STATUS';
col  bytes             for  99999                    heading 'SIZEM';
col  maxbytes          for  99999                    heading 'MSIZE';
col  FILE_NAME         for  a90                      heading 'FILE_NAME';
col  AUTOEXTENSIBLE    for  a5                       heading 'AUTO?';
 
col PROPERTY_VALUE     for a100                                  ;


col group#             for 99                        heading 'GROUP'
col thread#            for 99                        heading 'THREAD'
col TYPE               for a10                       
col bytes              for 99999                      heading 'SIZE(M)'
col status             for a10
col MEMBER             for a80


set heading off        
SELECT '------ System Info: '
FROM dual;
select version,id,comments from dba_registry_history
/
select to_char(sysdate, 'MM-DD-YYYY HH24:MI:SS') "DateTime: " from dual
/
select banner from v$version
/
select  
platform_name,name
from v$database
/
select name, display_value
  from v$parameter a
 where (a.ISDEFAULT not in ('TRUE') or name = 'cpu_count' or name like 'parallel%')
 order by name
/
select * from dba_directories
/
SELECT property_name,
       property_value
FROM database_properties
WHERE property_value IS NOT NULL
/

set heading on
PROMPT "************************************Tablespace Size********************************"
--  SELECT                                                          /* + RULE */
--        df.tablespace_name "Tablespace",
--         df.bytes / (1024 * 1024) "Size (MB)",
--         SUM (fs.bytes) / (1024 * 1024) "Free (MB)",
--         NVL (ROUND (SUM (fs.bytes) * 100 / df.bytes), 2) "% Free",
--         ROUND ( ( (df.bytes - SUM (fs.bytes)) * 100 / df.bytes), 2) "% Used"
--    FROM dba_free_space fs,
--         (  SELECT tablespace_name, SUM (bytes) bytes
--              FROM dba_data_files
--          GROUP BY tablespace_name) df
--   WHERE fs.tablespace_name(+) = df.tablespace_name
--GROUP BY df.tablespace_name, df.bytes
--UNION ALL
--  SELECT                                                          /* + RULE */
--        df.tablespace_name tspace,
--         fs.bytes / (1024 * 1024),
--         SUM (df.bytes_free) / (1024 * 1024),
--         NVL (ROUND ( (SUM (fs.bytes) - df.bytes_used) * 100 / fs.bytes), 2),
--         ROUND ( ( (SUM (fs.bytes) - df.bytes_free) * 100 / fs.bytes), 2)
--    FROM dba_temp_files fs,
--         (  SELECT tablespace_name, bytes_free, bytes_used
--              FROM v$temp_space_header
--          GROUP BY tablespace_name, bytes_free, bytes_used) df
--   WHERE fs.tablespace_name(+) = df.tablespace_name
--GROUP BY df.tablespace_name,
--         fs.bytes,
--         df.bytes_free,
--         df.bytes_used
--ORDER BY 4 DESC;

SELECT a.tablespace_name,                                                    
       TRUNC (tablespace_size * b.block_size / 1024 / 1024) size_m,          
       TRUNC (used_space * b.block_size / 1024 / 1024) used_size_m,          
       TRUNC ( (TABLESPACE_SIZE - used_space) * b.block_size / 1024 / 1024)  
          free_size_m,                                                       
       USED_PERCENT                                                          
  FROM DBA_TABLESPACE_USAGE_METRICS a, dba_tablespaces b                     
 WHERE a.tablespace_name = b.tablespace_name                                 
 ORDER BY USED_PERCENT                                                       
 /                                                                           


PROMPT "************************Database Total Size*********************************************************************************"
SELECT 'total',
       TO_CHAR (SYSDATE, 'yyyy-mm-dd') AS now_date,
       (total_space - free_space) used_space,
       total_space
  FROM (SELECT (SELECT ROUND (SUM (bytes / 1024 / 1024), 1)
                  FROM dba_free_space)
                  free_space,
               (SELECT /*+ ORDERED */
                       ROUND (SUM (bytes / 1024 / 1024), 1)
                  FROM v$datafile a, v$tablespace b
                 WHERE a.ts# = b.ts#)
                  total_space
          FROM DUAL);


PROMPT "************************datafile Size*********************************************************************************"

SELECT a.tablespace_name,
       a.file_name,
       a.file_id,
       a.RELATIVE_FNO,
       substr(a.status,1,10) status,
       a.AUTOEXTENSIBLE,
       trunc(a.bytes / 1024 / 1024) bytes
FROM dba_data_files a
ORDER BY a.tablespace_name,
         a.file_id
/
PROMPT "************************object number by owner*********************************************************************************"
select a.owner,  count(*)
  from dba_objects a
 where a.OWNER not in ('ANONYMOUS',
                       'APEX_030200',
                       'APEX_PUBLIC_USER',
                       'APPQOSSYS',
                       'CTXSYS',
                       'DBSNMP',
                       'DIP',
                       'EXFSYS',
                       'FLOWS_FILES',
                       'MDDATA',
                       'MDSYS',
                       'MGMT_VIEW',
                       'OLAPSYS',
                       'ORACLE_OCM',
                       'ORDDATA',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'OUTLN',
                       'OWBSYS',
                       'OWBSYS_AUDIT',
                       'SCOTT',
                       'SI_INFORMTN_SCHEMA',
                       'SPATIAL_CSW_ADMIN_USR',
                       'SPATIAL_WFS_ADMIN_USR',
                       'SYS',
                       'SYSMAN',
                       'SYSTEM',
                       'WMSYS',
                       'XDB',
                       'XS$NULL')
 group by a.owner
 order by 1, 2
/

PROMPT '**************************************Distinct Object Types and their Count By Schema:*****************************************'
select a.owner, a.object_type, count(*)
  from dba_objects a
 where a.OWNER not in ('ANONYMOUS',
                       'APEX_030200',
                       'APEX_PUBLIC_USER',
                       'APPQOSSYS',
                       'CTXSYS',
                       'DBSNMP',
                       'DIP',
                       'EXFSYS',
                       'FLOWS_FILES',
                       'MDDATA',
                       'MDSYS',
                       'MGMT_VIEW',
                       'OLAPSYS',
                       'ORACLE_OCM',
                       'ORDDATA',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'OUTLN',
                       'OWBSYS',
                       'OWBSYS_AUDIT',
                       'SCOTT',
                       'SI_INFORMTN_SCHEMA',
                       'SPATIAL_CSW_ADMIN_USR',
                       'SPATIAL_WFS_ADMIN_USR',
                       'SYS',
                       'SYSMAN',
                       'SYSTEM',
                       'WMSYS',
                       'XDB',
                       'XS$NULL')
 group by a.owner, a.object_type
 order by 1, 2, 3
/


PROMPT '****************************Distinct Column Data Types and their Count in the Schema****************************************************' 

SELECT data_type, count(*) total
  FROM all_tab_columns a
 WHERE a.OWNER not in ('ANONYMOUS',
                       'APEX_030200',
                       'APEX_PUBLIC_USER',
                       'APPQOSSYS',
                       'CTXSYS',
                       'DBSNMP',
                       'DIP',
                       'EXFSYS',
                       'FLOWS_FILES',
                       'MDDATA',
                       'MDSYS',
                       'MGMT_VIEW',
                       'OLAPSYS',
                       'ORACLE_OCM',
                       'ORDDATA',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'OUTLN',
                       'OWBSYS',
                       'OWBSYS_AUDIT',
                       'SCOTT',
                       'SI_INFORMTN_SCHEMA',
                       'SPATIAL_CSW_ADMIN_USR',
                       'SPATIAL_WFS_ADMIN_USR',
                       'SYS',
                       'SYSMAN',
                       'SYSTEM',
                       'WMSYS',
                       'XDB',
                       'XS$NULL','PERFSTAT')
 GROUP BY data_type
/
prompt "*******************************segment size by owner******************************"
select a.owner,trunc(sum(bytes)/1024/1024) segment_size from dba_segments a where 
a.OWNER not in ('ANONYMOUS',
                       'APEX_030200',
                       'APEX_PUBLIC_USER',
                       'APPQOSSYS',
                       'CTXSYS',
                       'DBSNMP',
                       'DIP',
                       'EXFSYS',
                       'FLOWS_FILES',
                       'MDDATA',
                       'MDSYS',
                       'MGMT_VIEW',
                       'OLAPSYS',
                       'ORACLE_OCM',
                       'ORDDATA',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'OUTLN',
                       'OWBSYS',
                       'OWBSYS_AUDIT',
                       'SCOTT',
                       'SI_INFORMTN_SCHEMA',
                       'SPATIAL_CSW_ADMIN_USR',
                       'SPATIAL_WFS_ADMIN_USR',
                       'SYS',
                       'SYSMAN',
                       'SYSTEM',
                       'WMSYS',
                       'XDB',
                       'XS$NULL')
group by a.owner
order by 2;
prompt "*******************************segment size by segment type of schema******************************"

select a.owner, a.segment_type, trunc(sum(bytes) / 1024 / 1024) segment_size
  from dba_segments a, dba_objects b
 WHERE a.OWNER not in ('ANONYMOUS',
                       'APEX_030200',
                       'APEX_PUBLIC_USER',
                       'APPQOSSYS',
                       'CTXSYS',
                       'DBSNMP',
                       'DIP',
                       'EXFSYS',
                       'FLOWS_FILES',
                       'MDDATA',
                       'MDSYS',
                       'MGMT_VIEW',
                       'OLAPSYS',
                       'ORACLE_OCM',
                       'ORDDATA',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'OUTLN',
                       'OWBSYS',
                       'OWBSYS_AUDIT',
                       'SCOTT',
                       'SI_INFORMTN_SCHEMA',
                       'SPATIAL_CSW_ADMIN_USR',
                       'SPATIAL_WFS_ADMIN_USR',
                       'SYS',
                       'SYSMAN',
                       'SYSTEM',
                       'WMSYS',
                       'XDB',
                       'XS$NULL')
   and a.owner(+) = b.owner
   and a.segment_name(+) = b.object_name
 GROUP BY a.owner, a.segment_type
 order by a.owner, a.segment_type
/
PROMPT "*****************************************SEGMENT SIZE **********************************************"

/* Formatted on 2016/10/14 13:26:06 (QP5 v5.256.13226.35510) */
WITH tt
     AS (SELECT /*+ materialize*/
                DISTINCT
                d.owner,
                d.table_name,
                d.t_size total_size,
                MAX (table_size)
                OVER (PARTITION BY d.owner, d.table_name ORDER BY table_size)
                   table_size,
                MAX (lob_size)
                OVER (PARTITION BY d.owner, d.table_name ORDER BY lob_size)
                   lob_size,
                MAX (index_size)
                OVER (PARTITION BY d.owner, d.table_name ORDER BY index_size)
                   index_size
           FROM (SELECT DISTINCT
                        c.owner,
                        c.table_name,
                        SUM (bytes) OVER (PARTITION BY c.owner, c.table_name)
                           t_size,
                        CASE
                           WHEN    c.segment_type = 'TABLE PARTITION'
                                OR c.segment_type = 'TABLE'
                           THEN
                              SUM (
                                 bytes)
                              OVER (
                                 PARTITION BY c.owner,
                                              c.table_name,
                                              c.segment_type)
                        END
                           table_size,
                        CASE
                           WHEN c.segment_type LIKE 'LOB%'
                           THEN
                              SUM (
                                 bytes)
                              OVER (
                                 PARTITION BY c.owner,
                                              c.table_name,
                                              c.segment_type)
                        END
                           lob_size,
                        CASE
                           WHEN c.segment_type LIKE 'INDEX%'
                           THEN
                              SUM (
                                 bytes)
                              OVER (
                                 PARTITION BY c.owner,
                                              c.table_name,
                                              c.segment_type)
                        END
                           index_size
                   FROM (SELECT c.owner,
                                c.table_name,
                                a.segment_type,
                                a.bytes
                           FROM dba_segments a, dba_lobs b,dba_tables c
                          WHERE     a.segment_name = b.segment_name 
                                and c.owner=b.owner and c.table_name=b.table_name
                                AND a.OWNER NOT IN ('ANONYMOUS',
                                                    'APEX_030200',
                                                    'APEX_PUBLIC_USER',
                                                    'APPQOSSYS',
                                                    'CTXSYS',
                                                    'DBSNMP',
                                                    'DIP',
                                                    'EXFSYS',
                                                    'FLOWS_FILES',
                                                    'MDDATA',
                                                    'MDSYS',
                                                    'MGMT_VIEW',
                                                    'OLAPSYS',
                                                    'ORACLE_OCM',
                                                    'ORDDATA',
                                                    'ORDPLUGINS',
                                                    'ORDSYS',
                                                    'OUTLN',
                                                    'OWBSYS',
                                                    'OWBSYS_AUDIT',
                                                    'SCOTT',
                                                    'SI_INFORMTN_SCHEMA',
                                                    'SPATIAL_CSW_ADMIN_USR',
                                                    'SPATIAL_WFS_ADMIN_USR',
                                                    'SYS',
                                                    'SYSMAN',
                                                    'SYSTEM',
                                                    'WMSYS',
                                                    'XDB',
                                                    'XS$NULL',
                                                    'PERFSTAT')
                                AND a.owner = b.owner
                         UNION ALL
                         SELECT c.owner,
                                c.table_name,
                                a.segment_type,
                                a.bytes
                           FROM dba_indexes b, dba_segments a, dba_tables c
                          WHERE     c.owner = b.table_owner
                                AND c.table_name = b.table_name
                                AND b.index_name = a.segment_name
                                AND b.owner = a.owner
                                AND c.OWNER NOT IN ('ANONYMOUS',
                                                    'APEX_030200',
                                                    'APEX_PUBLIC_USER',
                                                    'APPQOSSYS',
                                                    'CTXSYS',
                                                    'DBSNMP',
                                                    'DIP',
                                                    'EXFSYS',
                                                    'FLOWS_FILES',
                                                    'MDDATA',
                                                    'MDSYS',
                                                    'MGMT_VIEW',
                                                    'OLAPSYS',
                                                    'ORACLE_OCM',
                                                    'ORDDATA',
                                                    'ORDPLUGINS',
                                                    'ORDSYS',
                                                    'OUTLN',
                                                    'OWBSYS',
                                                    'OWBSYS_AUDIT',
                                                    'SCOTT',
                                                    'SI_INFORMTN_SCHEMA',
                                                    'SPATIAL_CSW_ADMIN_USR',
                                                    'SPATIAL_WFS_ADMIN_USR',
                                                    'SYS',
                                                    'SYSMAN',
                                                    'SYSTEM',
                                                    'WMSYS',
                                                    'XDB',
                                                    'XS$NULL',
                                                    'PERFSTAT')
                         UNION ALL
                         SELECT a.owner,
                                a.segment_name,
                                a.segment_type,
                                a.bytes
                           FROM dba_segments a, dba_tables b
                          WHERE     a.OWNER NOT IN ('PERFSTAT',
                                                    'ANONYMOUS',
                                                    'APEX_030200',
                                                    'APEX_PUBLIC_USER',
                                                    'APPQOSSYS',
                                                    'CTXSYS',
                                                    'DBSNMP',
                                                    'DIP',
                                                    'EXFSYS',
                                                    'FLOWS_FILES',
                                                    'MDDATA',
                                                    'MDSYS',
                                                    'MGMT_VIEW',
                                                    'OLAPSYS',
                                                    'ORACLE_OCM',
                                                    'ORDDATA',
                                                    'ORDPLUGINS',
                                                    'ORDSYS',
                                                    'OUTLN',
                                                    'OWBSYS',
                                                    'OWBSYS_AUDIT',
                                                    'SCOTT',
                                                    'SI_INFORMTN_SCHEMA',
                                                    'SPATIAL_CSW_ADMIN_USR',
                                                    'SPATIAL_WFS_ADMIN_USR',
                                                    'SYS',
                                                    'SYSMAN',
                                                    'SYSTEM',
                                                    'WMSYS',
                                                    'XDB',
                                                    'XS$NULL',
                                                    'PERFSTAT')
                                AND a.owner = b.owner
                                AND a.segment_name = b.table_name) c) d
          WHERE t_size > 1 * 1024 * 1024 * 1024)
SELECT '--------' owner,
       '-------Top 50 Total' table_name,
       1111 total_size,
       1111 table_size,
       1111 lob_size,
       11 index_size,
       11 rnum
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*, ROW_NUMBER () OVER (ORDER BY e.total_size DESC) rnum
          FROM tt e
         WHERE e.total_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Table Segment ',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*, ROW_NUMBER () OVER (ORDER BY e.table_size DESC) rnum
          FROM tt e
         WHERE e.table_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Lob Segment ',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*, ROW_NUMBER () OVER (ORDER BY e.lob_size DESC) rnum
          FROM tt e
         WHERE e.lob_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Index Segment ',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*, ROW_NUMBER () OVER (ORDER BY e.index_size DESC) rnum
          FROM tt e
         WHERE index_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Total Table Segment By  Schema',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*,
               ROW_NUMBER ()
                  OVER (PARTITION BY e.owner ORDER BY e.total_size DESC)
                  rnum
          FROM tt e
         WHERE e.total_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Table Segment By  Schema',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*,
               ROW_NUMBER ()
                  OVER (PARTITION BY e.owner ORDER BY e.table_size DESC)
                  rnum
          FROM tt e
         WHERE e.table_size > 0)
 WHERE rnum < 50
UNION ALL
SELECT '--------',
       'top 50 Lob Segment By  Schema',
       1111,
       1111,
       1111,
       11,
       11
  FROM DUAL
UNION ALL
SELECT owner,
       table_name,
       TRUNC (total_size / 1024 / 1024 / 1024) total_size,
       TRUNC (table_size / 1024 / 1024 / 1024) table_size,
       TRUNC (lob_size / 1024 / 1024 / 1024) lob_size,
       TRUNC (index_size / 1024 / 1024 / 1024) index_size,
       rnum
  FROM (SELECT e.*,
               ROW_NUMBER ()
                  OVER (PARTITION BY e.owner ORDER BY e.lob_size DESC)
                  rnum
          FROM tt e
         WHERE e.lob_size > 0)
 WHERE rnum < 50
/


Prompt "****************************************Logfile info**********************************************************"
SELECT a.group#,
       b.thread#,
       a.TYPE,
       round(bytes/1024/1024) bytes,
       a.status,
       a.MEMBER
FROM v$logfile a,v$log b
WHERE a.group# = b.group#
UNION ALL
SELECT a.group#,
       b.thread#,
       a.TYPE,
       bytes / 1024 / 1024,
       a.status,
       a.MEMBER
FROM v$logfile a,v$standby_log b
WHERE a.group# = b.group#
ORDER BY thread#,GROUP#
/
Prompt "****************************************Log Switches**********************************************************"
col DAY for a5
col 00 for a3
col 01 for a3
col 02   for a3
col 03   for a3
col 04   for a3
col 05   for a3
col 06   for a3
col 07   for a3
col 08   for a3
col 09   for a3
col 10   for a3
col 11   for a3
col 12   for a3
col 13   for a3
col 14   for a3
col 15   for a3
col 16   for a3
col 17   for a3
col 18   for a3
col 19   for a3
col 20   for a3
col 21   for a3
col 22   for a3
col 23   for a3
col 24   for a3
SELECT SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),1,5) DAY, 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'00',1,0)),'99') "00", 
  	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'01',1,0)),'99') "01", 
 	   TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'02',1,0)),'99') "02", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'03',1,0)),'99') "03", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'04',1,0)),'99') "04", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'05',1,0)),'99') "05", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'06',1,0)),'99') "06", 
  	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'07',1,0)),'99') "07", 
	   TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'08',1,0)),'99') "08", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'09',1,0)),'99') "09", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'10',1,0)),'99') "10", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'11',1,0)),'99') "11", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'12',1,0)),'99') "12", 
  	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'13',1,0)),'99') "13", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'14',1,0)),'99') "14", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'15',1,0)),'99') "15", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'16',1,0)),'99') "16", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'17',1,0)),'99') "17", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'18',1,0)),'99') "18", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'19',1,0)),'99') "19", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'20',1,0)),'99') "20", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'21',1,0)),'99') "21", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'22',1,0)),'99') "22", 
   	 TO_CHAR(SUM(DECODE(SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),10,2),'23',1,0)),'99') "23" 
FROM 	 V$LOG_HISTORY 
GROUP  BY SUBSTR(TO_CHAR(FIRST_TIME, 'MM-DD-YY HH24:MI:SS'),1,5) 
order by 1;


Prompt "****************************************all tables size*******************************************************"
COL TABLE_NAME FOR A30
col PARTITIONED for a30 heading 'PART'
BREAK ON report ON OWNER SKIP 1 
COMPUTE SUM LABEL "Owner Total: " OF tab_size_mb lob_size_mb index_size_mb ON OWNER 
COMPUTE SUM LABEL "Grand Total: " OF tab_size_mb lob_size_mb index_size_mb ON report 


/* Formatted on 2017/3/22 9:05:08 (QP5 v5.256.13226.35510) */
WITH lobs
     AS (  SELECT c.OWNER,
                  c.TABLE_NAME,
                  TRUNC (SUM (bytes) / 1024 / 1024) lob_size_mb
             FROM dba_segments a, dba_lobs b, dba_tables c
            WHERE     a.segment_name = b.segment_name
                  AND c.OWNER NOT IN ('ANONYMOUS',
                                      'APEX_030200',
                                      'APEX_PUBLIC_USER',
                                      'APPQOSSYS',
                                      'CTXSYS',
                                      'DBSNMP',
                                      'DIP',
                                      'EXFSYS',
                                      'FLOWS_FILES',
                                      'MDDATA',
                                      'MDSYS',
                                      'MGMT_VIEW',
                                      'OLAPSYS',
                                      'ORACLE_OCM',
                                      'ORDDATA',
                                      'ORDPLUGINS',
                                      'ORDSYS',
                                      'OUTLN',
                                      'OWBSYS',
                                      'OWBSYS_AUDIT',
                                      'SCOTT',
                                      'SI_INFORMTN_SCHEMA',
                                      'SPATIAL_CSW_ADMIN_USR',
                                      'SPATIAL_WFS_ADMIN_USR',
                                      'SYS',
                                      'SYSMAN',
                                      'SYSTEM',
                                      'WMSYS',
                                      'XDB',
                                      'XS$NULL',
                                      'PERFSTAT')
                  AND c.OWNER = b.OWNER
                  AND c.TABLE_NAME = b.TABLE_NAME
                  AND a.OWNER = b.OWNER
         GROUP BY c.OWNER, c.table_name),
     tabs
     AS (  SELECT a.OWNER,
                  a.segment_name TABLE_NAME,b.PARTITIONED,
                  TRUNC (SUM (bytes) / 1024 / 1024) tab_size_mb
             FROM dba_segments a, dba_tables b
            WHERE     a.segment_name = b.TABLE_NAME
                  AND a.OWNER = b.OWNER
                  AND b.OWNER NOT IN ('ANONYMOUS',
                                      'APEX_030200',
                                      'APEX_PUBLIC_USER',
                                      'APPQOSSYS',
                                      'CTXSYS',
                                      'DBSNMP',
                                      'DIP',
                                      'EXFSYS',
                                      'FLOWS_FILES',
                                      'MDDATA',
                                      'MDSYS',
                                      'MGMT_VIEW',
                                      'OLAPSYS',
                                      'ORACLE_OCM',
                                      'ORDDATA',
                                      'ORDPLUGINS',
                                      'ORDSYS',
                                      'OUTLN',
                                      'OWBSYS',
                                      'OWBSYS_AUDIT',
                                      'SCOTT',
                                      'SI_INFORMTN_SCHEMA',
                                      'SPATIAL_CSW_ADMIN_USR',
                                      'SPATIAL_WFS_ADMIN_USR',
                                      'SYS',
                                      'SYSMAN',
                                      'SYSTEM',
                                      'WMSYS',
                                      'XDB',
                                      'XS$NULL',
                                      'PERFSTAT')
         GROUP BY a.OWNER, a.segment_name,b.PARTITIONED),
     indexes
     AS (  SELECT c.OWNER,
                  c.TABLE_NAME,
                  TRUNC (SUM (bytes) / 1024 / 1024) index_size_mb
             FROM dba_indexes b, dba_segments a, dba_tables c
            WHERE     c.OWNER = b.table_owner
                  AND c.TABLE_NAME = b.TABLE_NAME
                  AND b.index_name = a.segment_name
                  AND b.OWNER = a.OWNER
                  AND c.OWNER NOT IN ('ANONYMOUS',
                                      'APEX_030200',
                                      'APEX_PUBLIC_USER',
                                      'APPQOSSYS',
                                      'CTXSYS',
                                      'DBSNMP',
                                      'DIP',
                                      'EXFSYS',
                                      'FLOWS_FILES',
                                      'MDDATA',
                                      'MDSYS',
                                      'MGMT_VIEW',
                                      'OLAPSYS',
                                      'ORACLE_OCM',
                                      'ORDDATA',
                                      'ORDPLUGINS',
                                      'ORDSYS',
                                      'OUTLN',
                                      'OWBSYS',
                                      'OWBSYS_AUDIT',
                                      'SCOTT',
                                      'SI_INFORMTN_SCHEMA',
                                      'SPATIAL_CSW_ADMIN_USR',
                                      'SPATIAL_WFS_ADMIN_USR',
                                      'SYS',
                                      'SYSMAN',
                                      'SYSTEM',
                                      'WMSYS',
                                      'XDB',
                                      'XS$NULL',
                                      'PERFSTAT')
         GROUP BY c.OWNER, c.TABLE_NAME)
  SELECT tabs.OWNER,
         tabs.TABLE_NAME,tabs.PARTITIONED,
         tabs.tab_size_mb,
         lobs.lob_size_mb,
         indexes.index_size_mb
    FROM lobs, tabs, indexes
   WHERE     lobs.OWNER(+) = tabs.OWNER
         AND tabs.OWNER = indexes.OWNER(+)
         AND lobs.TABLE_NAME(+) = tabs.TABLE_NAME
         AND tabs.TABLE_NAME = indexes.TABLE_NAME(+)
ORDER BY 1,
         3 DESC,
         4 DESC,
         5 DESC;