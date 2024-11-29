/* Formatted on 2016/4/15 14:21:39 (QP5 v5.256.13226.35510) */
SET ECHO OFF
SET LINES 2000 PAGES 1000 VERIFY OFF HEADING ON
COL owner FOR a20
COL tablespace_name FOR a30
COL index_name FOR a30
COL partition_name FOR a30
COL subpartition_name FOR a30

PROMPT '1,XML check, 10G began to support XML objects, but only use expdp / impdp to import the source data '
PROMPT 'TTS changed XMLTYPE from CLOB to Binary, XML Tag Syntax are Changed (Doc ID 1989198.1)'

SELECT DISTINCT OWNER
  FROM DBA_XML_SCHEMAS X
 WHERE x.owner NOT IN ('ANONYMOUS',
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
/

SELECT DISTINCT p.tablespace_name
  FROM dba_tablespaces p,
       dba_xml_tables x,
       dba_users u,
       all_all_tables t
 WHERE     t.table_name = x.table_name
       AND t.tablespace_name = p.tablespace_name
       AND x.owner = u.username
       AND x.owner NOT IN ('ANONYMOUS',
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
/


PROMPT '2,Check for unusable indexes that may trigger BUG'

SELECT owner,
       index_name,
       '' part_name,
       status
  FROM dba_indexes
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT i.owner,
       i.index_name,
       p.partition_name,
       p.status
  FROM dba_ind_partitions p, dba_indexes i
 WHERE p.index_name = i.index_name AND p.status = 'UNUSABLE'
UNION ALL
SELECT i.owner,
       i.index_name,
       s.subpartition_name,
       s.status
  FROM dba_ind_subpartitions s, dba_indexes i
 WHERE s.index_name = i.index_name AND s.status = 'UNUSABLE'
ORDER BY 1, 2, 3
/


PROMPT '3,check Compatible Advanced Queues'

SELECT owner,
       queue_table,
       recipients,
       compatible
  FROM dba_queue_tables
 WHERE recipients = 'MULTIPLE' AND compatible LIKE '%8.0%'
/


PROMPT '4,check SPATIAL'

SELECT owner, index_name
  FROM dba_indexes
 WHERE     ityp_name = 'SPATIAL_INDEX'
       AND owner IN ('ANONYMOUS',
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
/

  SELECT owner, table_name, column_name
    FROM dba_tab_columns
   WHERE     data_type = 'SDO_GEOMETRY'
         AND owner IN ('ANONYMOUS',
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
ORDER BY 1, 2, 3
/


PROMPT '5,Check the external table'

SELECT DISTINCT owner FROM DBA_EXTERNAL_TABLES
/

PROMPT '6,Check IOT object, IOT object may be have bug'

SELECT DISTINCT owner
  FROM dba_tables
 WHERE IOT_TYPE IS NOT NULL AND tablespace_name NOT IN ('SYSTEM', 'SYSAUX')
/


PROMPT '7,check mview'

  SELECT owner, COUNT (*)
    FROM dba_mviews o
   WHERE o.owner IN ('ANONYMOUS',
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
GROUP BY owner
/

PROMPT '8,check recyclebin'
PROMPT 'Ora-0600 [ktecgetsh-inc] After Using Transportable Tablespaces (Doc ID 1232675.1)'

  SELECT owner, COUNT (*)
    FROM dba_recyclebin
GROUP BY owner
/

PROMPT '9,check TIMEZONE'
PROMPT 'Data Pump TTS Import Fails With ORA-39002 And ORA-39322 Due To TIMEZONE Conflict (Doc ID 1275433.1)'


  SELECT    c.owner
         || '.'
         || c.table_name
         || '('
         || c.column_name
         || ') -'
         || c.data_type
         || ' '
            col
    FROM dba_tab_cols c, dba_objects o
   WHERE     c.data_type LIKE '%WITH TIME ZONE'
         AND c.owner = o.owner
         AND c.table_name = o.object_name
         AND o.object_type = 'TABLE'
         AND o.owner not IN ('ANONYMOUS',
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
ORDER BY col
/

PROMPT '10,Check the table of encrypt the column information'

  SELECT owner, table_name, COUNT (*)
    FROM DBA_ENCRYPTED_COLUMNS
GROUP BY owner, table_name
/

PROMPT '11,Check the encrypted tablespace'

SELECT tablespace_name, ENCRYPTED
  FROM dba_tablespaces
 WHERE ENCRYPTED = 'YES'
/

PROMPT '8,Check the number of user objects'

SELECT OWNER,
       count(*)
FROM dba_segments
WHERE OWNER NOT IN ('ANONYMOUS',
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
GROUP BY OWNER
ORDER BY OWNER
/
PROMPT '8,Count the number of objects in each tablespace'

  SELECT tablespace_name, COUNT (*)
    FROM dba_segments
GROUP BY tablespace_name,owner
/



PROMPT '9,Statistics The default user object not in SYSTEM, SYSAUX tablespaces'

PROMPT '9.1 default system user but object not in system tablespace'
SELECT distinct   OWNER||'.'||segment_name||'.'||segment_type
FROM dba_segments
WHERE tablespace_name NOT IN ('SYSTEM',
                              'SYSAUX')
  AND OWNER  IN ('ANONYMOUS',
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
  and segment_type not in ('TYPE2 UNDO')
/

PROMPT '9.2 not default user object in system and sysaux '
SELECT DISTINCT  OWNER||'.'||segment_name||'.'||segment_type as ddl
FROM dba_segments
WHERE tablespace_name IN ('SYSTEM',
                          'SYSAUX')
  AND OWNER NOT IN ('ANONYMOUS',
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
  /

PROMPT '10 TABLESPACE IS NOT EXISTS THAT IS DEFAULT TABLE TABLESPACE'

PROMPT '10,1 PARTITION TABLE DEFAULT TABLESPACE '

SELECT owner,
       TABLE_NAME,
       DEF_TABLESPACE_NAME
FROM dba_part_tables
WHERE DEF_TABLESPACE_NAME NOT IN
    (SELECT name
     FROM v$tablespace)
/
PROMPT '10.2 NORMAL TABLE'
SELECT OWNER,
       TABLE_NAME,
       tablespace_name
FROM dba_tables
WHERE tablespace_name NOT IN
    (SELECT name
     FROM v$tablespace)
/
PROMPT '10.3 NORMAL TABLE'
SELECT table_owner,
       TABLE_NAME,
       tablespace_name
FROM dba_tab_partitions
WHERE tablespace_name NOT IN
    (SELECT name
     FROM v$tablespace)
/
PROMPT '10.4  SUBPARTITION TABLE'
SELECT table_owner,
       TABLE_NAME,
       subpartition_name,
       tablespace_name
FROM dba_tab_subpartitions
WHERE tablespace_name NOT IN
    (SELECT name
     FROM v$tablespace)
/


PROMPT '11 DISPLAY PARTITION TYPE'
SELECT distinct PARTITIONING_TYPE,
       SUBPARTITIONING_TYPE
FROM DBA_PART_TABLES
WHERE OWNER NOT IN ('ANONYMOUS',
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
/


PROMPT 'check force logging'
select name,force_logging from v$database
/

PROMPT 'check PUBLIC dblink info'
select 'PUBLIC dblink number:'||count(*) PUBLIC_dblink from dba_db_links where owner='PUBLIC'
/


PROMPT 'check database version'

col action format a20
col namespace format a10
col version format a10
col comments format a50
col action_time format a30
col bundle_series format a15
col comp_name for a50
col comp_id for a25
col schema for a15
col patch_id for 9999999999
col version for a10
col action for a10
col status for a10
col DESCRIPTION for a60
col BUNDLE_SERIES for a10 heading 'BUNDLE'
alter session set nls_timestamp_format = 'yyyy-mm-dd hh24:mi:ss.ff';
select * from v$version
/
select comp_id, comp_name, schema,version, status from sys.dba_registry
/
select * from dba_registry_history order by 1;




PROMPT '10,check datafile path'
col tablespace_name for a20
col file_id for 999999
col file_name for a80
SELECT tablespace_name,
       file_id,
       file_name
FROM dba_data_files
WHERE tablespace_name NOT IN ('SYSTEM',
                              'SYSAUX')
  AND tablespace_name NOT LIKE 'UNDOTBS%'
ORDER BY tablespace_name,
         file_id
/