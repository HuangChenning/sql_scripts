/* Formatted on 2015/5/20 20:45:09 (QP5 v5.240.12305.39446) */
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

SELECT DBMS_METADATA.get_ddl ('DB_LINK', db_link, owner)
  FROM dba_db_links
 WHERE     owner = UPPER ('&owner')
       AND db_link = NVL (UPPER ('&dblink'), db_link);

SET PAGESIZE 14 LINESIZE 1000 FEEDBACK ON VERIFY ON