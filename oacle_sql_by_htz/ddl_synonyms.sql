/* Formatted on 2015/5/20 20:52:20 (QP5 v5.240.12305.39446) */
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

SELECT DBMS_METADATA.get_ddl ('SYNONYM', synonym_name, owner)
  FROM all_synonyms
 WHERE     owner = UPPER ('&owner')
       AND synonym_name = NVL (UPPER ('&synonym_name'), synonym_name);

SET PAGESIZE 14 FEEDBACK ON VERIFY ON