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

SELECT DBMS_METADATA.get_ddl ('SEQUENCE', sequence_name, sequence_owner)
  FROM all_sequences
 WHERE     sequence_owner = UPPER ('&owner')
       AND sequence_name =
              DECODE (UPPER ('&sequence_name'), 'ALL', sequence_name, UPPER ('&sequence_name'));

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON