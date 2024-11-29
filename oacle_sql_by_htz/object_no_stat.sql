set echo off
set lines 199
set pages 40
col object_type for a10
col owner for a15
col object_name for a40
col last_analyzed for a19
col stattype_locked for a10 heading 'STATTYPE|LOCKED'
col stale_stats for a11
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
SELECT 'TABLE' object_type,
       owner,
       table_name object_name,
       last_analyzed,
       stattype_locked,
       stale_stats
  FROM all_tab_statistics
 WHERE (last_analyzed IS NULL OR stale_stats = 'YES')
   and stattype_locked IS NULL
   and owner NOT IN ('ANONYMOUS',
                     'CTXSYS',
                     'DBSNMP',
                     'EXFSYS',
                     'LBACSYS',
                     'MDSYS',
                     'MGMT_VIEW',
                     'OLAPSYS',
                     'OWBSYS',
                     'ORDPLUGINS',
                     'ORDSYS',
                     'OUTLN',
                     'SI_INFORMTN_SCHEMA',
                     'SYS',
                     'SYSMAN',
                     'SYSTEM',
                     'TSMSYS',
                     'WK_TEST',
                     'WKSYS',
                     'WKPROXY',
                     'WMSYS',
                     'XDB')
   AND owner NOT LIKE 'FLOW%'
UNION ALL
SELECT 'INDEX' object_type,
       owner,
       index_name object_name,
       last_analyzed, 
       stattype_locked,
       stale_stats
  FROM all_ind_statistics
 WHERE (last_analyzed IS NULL OR stale_stats = 'YES')
   and stattype_locked IS NULL
   AND owner NOT IN ('ANONYMOUS',
                     'CTXSYS',
                     'DBSNMP',
                     'EXFSYS',
                     'LBACSYS',
                     'MDSYS',
                     'MGMT_VIEW',
                     'OLAPSYS',
                     'OWBSYS',
                     'ORDPLUGINS',
                     'ORDSYS',
                     'OUTLN',
                     'SI_INFORMTN_SCHEMA',
                     'SYS',
                     'SYSMAN',
                     'SYSTEM',
                     'TSMSYS',
                     'WK_TEST',
                     'WKSYS',
                     'WKPROXY',
                     'WMSYS',
                     'XDB')
   AND owner NOT LIKE 'FLOW%'
 ORDER BY object_type desc, owner, object_name
 /
