SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR', true);

/* Formatted on 2015/5/20 21:54:12 (QP5 v5.240.12305.39446) */
SELECT DBMS_METADATA.get_ddl ('USER', username)
  FROM dba_users
 WHERE username NOT IN
          ('ANONYMOUS',
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
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('TABLESPACE_QUOTA', username)
  FROM (SELECT DISTINCT username username
          FROM dba_ts_quotas
         WHERE username IN
                  (SELECT username
                     FROM dba_users
                    WHERE username NOT IN
                             ('ANONYMOUS',
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
                              'XS$NULL')))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('ROLE_GRANT', grantee)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_role_privs
         WHERE grantee IN
                  (SELECT username
                     FROM dba_users
                    WHERE username NOT IN
                             ('ANONYMOUS',
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
                              'XS$NULL')))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('SYSTEM_GRANT', grantee)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_sys_privs
         WHERE grantee IN
                  (SELECT username
                     FROM dba_users
                    WHERE username NOT IN
                             ('ANONYMOUS',
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
                              'XS$NULL')))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('OBJECT_GRANT', grantee)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_tab_privs
         WHERE grantee IN
                  (SELECT username
                     FROM dba_users
                    WHERE username NOT IN
                             ('ANONYMOUS',
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
                              'XS$NULL')))
/
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON