/* Formatted on 2015/5/20 20:50:31 (QP5 v5.240.12305.39446) */
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
COLUMN ddl FORMAT a1000
UNDEFINE profile

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'SQLTERMINATOR',
                                      TRUE);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'PRETTY',
                                      TRUE);
END;
/

SELECT DBMS_METADATA.get_ddl ('PROFILE', profile) AS profile_ddl
  FROM (SELECT DISTINCT profile FROM dba_profiles)
 WHERE profile = UPPER ('&profile');

UNDEFINE profile
SET LINESIZE 80 PAGESIZE 14 FEEDBACK ON VERIFY ON