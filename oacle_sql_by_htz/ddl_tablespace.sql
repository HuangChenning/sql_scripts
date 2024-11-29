/* Formatted on 2015/5/20 21:23:26 (QP5 v5.240.12305.39446) */
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'SQLTERMINATOR',
                                      TRUE);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'PRETTY',
                                      TRUE);
END;
/

UNDEFINE tablespace_name

SELECT DBMS_METADATA.get_ddl ('TABLESPACE', tablespace_name)
  FROM dba_tablespaces
 WHERE tablespace_name = NVL (UPPER ('&tablespace_name'), tablespace_name);

UNDEFINE tablespace_name
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON