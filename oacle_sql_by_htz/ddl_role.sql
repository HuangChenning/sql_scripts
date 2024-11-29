/* Formatted on 2015/5/20 20:41:44 (QP5 v5.240.12305.39446) */
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
COLUMN ddl FORMAT a1000

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'SQLTERMINATOR',
                                      TRUE);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'PRETTY',
                                      TRUE);
END;
/

VARIABLE v_role VARCHAR2(30);

EXEC :v_role := upper('&role');

SELECT DBMS_METADATA.get_ddl ('ROLE', r.role) AS ddl
  FROM dba_roles r
 WHERE r.role = :v_role
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('ROLE_GRANT', rp.grantee) AS ddl
  FROM dba_role_privs rp
 WHERE rp.grantee = :v_role AND ROWNUM = 1
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('SYSTEM_GRANT', sp.grantee) AS ddl
  FROM dba_sys_privs sp
 WHERE sp.grantee = :v_role AND ROWNUM = 1
UNION ALL
SELECT DBMS_METADATA.get_granted_ddl ('OBJECT_GRANT', tp.grantee) AS ddl
  FROM dba_tab_privs tp
 WHERE tp.grantee = :v_role AND ROWNUM = 1
/

SET LINESIZE 80 PAGESIZE 14 FEEDBACK ON VERIFY ON
