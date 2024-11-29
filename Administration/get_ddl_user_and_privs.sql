-- File Name : get_ddl_user_and_priv.sql
-- Purpose : 获取用户DDL
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR', true);
#EXEC DBMS_METADATA.SET_COUNT(DBMS_METADATA.SESSION_TRANSFORM,200000);
undefine username;
/* Formatted on 2016/5/20 17:16:12 (QP5 v5.256.13226.35510) */
SELECT DBMS_METADATA.get_ddl ('USER', username)
  FROM dba_users
 WHERE username = UPPER ('&&USERNAME')
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('TABLESPACE_QUOTA',
                                      username,
                                      object_count   => 2000000)
  FROM (SELECT DISTINCT username username
          FROM dba_ts_quotas
         WHERE username = UPPER ('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('ROLE_GRANT',
                                      grantee,
                                      object_count   => 2000000)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_role_privs
         WHERE grantee = UPPER ('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('SYSTEM_GRANT',
                                      grantee,
                                      object_count   => 2000000)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_sys_privs
         WHERE grantee = UPPER ('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('OBJECT_GRANT',
                                      grantee,
                                      object_count   => 2000000)
  FROM (SELECT DISTINCT grantee grantee
          FROM dba_tab_privs
         WHERE grantee = UPPER ('&&USERNAME'))
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('DEFAULT_ROLE', UPPER ('&&USERNAME'))
  FROM DUAL
/
undefine username;