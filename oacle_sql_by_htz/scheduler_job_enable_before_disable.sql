set echo off
set lines 200
set pages 50
set serveroutput on
set verify off
DECLARE
   v_num   NUMBER := 0;
   v_sql   VARCHAR2 (500);
BEGIN
   FOR job_rec
      IN (SELECT owner || '.' || job_name job_name
            FROM SYSTEM.dba_scheduler_jobs_temp_htz)
   LOOP
      DBMS_SCHEDULER.enable (job_rec.job_name);
   END LOOP;

   DBMS_OUTPUT.put_line ('ENDDING ENABLE SCHEDULER');
END;
/