set heading off feedback off trimspool on escape off
set long 1000 linesize 1000 pagesize 0
col SEQDDL format A300
spool tts_create_seq.sql
prompt /* ========================= */
prompt /* Drop and create sequences */
prompt /* ========================= */
SELECT REGEXP_REPLACE (
          DBMS_METADATA.get_ddl ('SEQUENCE', sequence_name, sequence_owner),
          '^.*(CREATE SEQUENCE.*CYCLE).*$',
             'DROP SEQUENCE "'
          || sequence_owner
          || '"."'
          || sequence_name
          || '";'
          || CHR (10)
          || '\1;')
          SEQDDL
  FROM dba_sequences
 WHERE sequence_owner NOT IN (SELECT name
                                FROM SYSTEM.logstdby$skip_support
                               WHERE action = 0);
spool off