set echo off
set lines 300 pages 5000 verify off heading on
col index_owner for a30
col index_name for a50
col index_mb for 99999999 heading 'INDEX|SIZE(M)'
col table_owner for a30 heading 'TABLE|OWNER'
col table_name for a40
col table_mb for 9999999 heading 'TABLE|SIZE(M)'
WITH seg AS
 (SELECT /*+ materialize */
   A.OWNER,
   A.SEGMENT_NAME,
   SUBSTR(SEGMENT_TYPE, 1, 5) SEGMENT_TYPE,
   SUM(BYTES / 1024 / 1024) MB
    FROM DBA_SEGMENTS A
   WHERE OWNER NOT IN ('SYS',
                       'SYSTEM',
                       'MONITOR',
                       'ETL',
                       'FILEDB',
                       'MGMT_VIEW',
                       'OUTLN',
                       'DBSNMP',
                       'WMSYS',
                       'EXFSYS',
                       'SYSMAN',
                       'TSMSYS',
                       'DIP')
     AND SEGMENT_NAME NOT LIKE 'SYS_LOB%'
     AND SEGMENT_NAME NOT LIKE 'SYS_IL%'
     AND SEGMENT_NAME NOT LIKE 'BIN$%'
   GROUP BY A.OWNER, A.SEGMENT_NAME, SUBSTR(SEGMENT_TYPE, 1, 5))
SELECT s.owner     index_owner,
       index_name,
       i.mb        index_mb,
       table_owner,
       table_name,
       t.mb        table_mb
  FROM DBA_INDEXES S,
       (SELECT * FROM SEG WHERE SEGMENT_TYPE = 'TABLE') T,
       (SELECT * FROM SEG WHERE SEGMENT_TYPE = 'INDEX') I
 WHERE S.OWNER NOT IN ('SYS',
                       'SYSTEM',
                       'MONITOR',
                       'ETL',
                       'FILEDB',
                       'MGMT_VIEW',
                       'OUTLN',
                       'DBSNMP',
                       'WMSYS',
                       'EXFSYS',
                       'SYSMAN',
                       'TSMSYS',
                       'DIP')
   AND S.OWNER = I.OWNER
   AND S.INDEX_NAME = I.SEGMENT_NAME
   AND S.TABLE_OWNER = T.OWNER
   AND S.TABLE_NAME = T.SEGMENT_NAME
   AND (i.mb > 10 OR t.mb > 10)
   AND i.mb / t.mb > 0.5
 ORDER BY index_mb / table_mb DESC;
