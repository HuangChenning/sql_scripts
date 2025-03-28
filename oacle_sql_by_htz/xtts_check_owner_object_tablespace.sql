SELECT distinct 'default system user but object not in system tablespace '||  OWNER||'.'||segment_name||'.'||segment_type
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
/

SELECT DISTINCT 'not default user object in system and sysaux '|| OWNER||'.'||segment_name||'.'||segment_type
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
