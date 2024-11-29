/* Formatted on 2015/5/20 20:55:54 (QP5 v5.240.12305.39446) */
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'SQLTERMINATOR',
                                      TRUE);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                      'PRETTY',
                                      TRUE);
-- Uncomment the following lines if you need them.
--DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
--DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'STORAGE', false);
END;
/
undefine owner;
undefine table_name;
PROMPT PROMPT ********************TABLE DDL*******************************
/* Formatted on 2015/5/20 21:06:28 (QP5 v5.240.12305.39446) */
SELECT DBMS_METADATA.get_ddl ('TABLE', table_name, owner)
  FROM all_tables
 WHERE     owner = UPPER ('&&owner')
       AND table_name = NVL (UPPER ('&&table_name'), table_name);
PROMPT PROMPT ********************INDEX OF TABLE *******************************
SELECT DBMS_METADATA.get_ddl ('INDEX', index_name, owner)
  FROM all_indexes
 WHERE (TABLE_OWNER, table_name) IN
          (SELECT owner, table_name
             FROM dba_tables
            WHERE     owner = UPPER ('&&owner')
                  AND table_name = NVL (UPPER ('&&table_name'), table_name));

PROMPT PROMPT ********************CONSTRAINT OF TABLE *******************************
SELECT DBMS_METADATA.get_ddl ('CONSTRAINT', constraint_name, owner)
  FROM all_constraints
 WHERE owner = UPPER ('&&owner') AND table_name = UPPER ('&&table_name');

undefine owner;
undefine table_name;
SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON