set echo off
set lines 200
set pages 50
set serveroutput on
set verify off
/* Formatted on 2014/3/25 10:56:44 (QP5 v5.240.12305.39446) */
DECLARE
   v_num   NUMBER := 0;
   v_sql   VARCHAR2 (500);
BEGIN
   SELECT COUNT (*)
     INTO v_num
     FROM dba_tables
    WHERE     table_name = UPPER ('dba_scheduler_jobs_temp_htz')
          AND owner = 'SYSTEM';

   IF v_num = 0
   THEN
      DBMS_OUTPUT.put_line (
         'SYSTEM.DBA_SCHEDULER_JOBS_TEMP_HTZ IS NOT  EXISTS AND WILL CREATE');
      v_sql :=
         'CREATE TABLE SYSTEM.dba_scheduler_jobs_temp_htz AS SELECT owner, job_name FROM dba_scheduler_jobs  WHERE enabled = ''TRUE''';

      EXECUTE IMMEDIATE v_sql;
   ELSE
      DBMS_OUTPUT.put_line ('TRUNCATE TABLE');

      EXECUTE IMMEDIATE 'truncate table SYSTEM.DBA_SCHEDULER_JOBS_TEMP_HTZ';

      DBMS_OUTPUT.put_line ('INSERT TABLE');

      EXECUTE IMMEDIATE
         'insert into system.dba_scheduler_jobs_temp_htz SELECT owner, job_name FROM dba_scheduler_jobs WHERE enabled = ''TRUE''';
   END IF;

   COMMIT;
   DBMS_OUTPUT.put_line ('BEGINING DISABLE SCHEDULER');

   FOR job_rec IN (SELECT owner || '.' || job_name job_name
                     FROM dba_scheduler_jobs
                    WHERE enabled = 'TRUE')
   LOOP
      DBMS_SCHEDULER.DISABLE (job_rec.job_name);
   END LOOP;

   DBMS_OUTPUT.put_line ('ENDDING DISABLE SCHEDULER');
END;
/