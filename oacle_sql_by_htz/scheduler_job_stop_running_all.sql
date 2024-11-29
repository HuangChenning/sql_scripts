et echo off
set lines 200
set pages 50
set serveroutput on
set verify off
BEGIN
   FOR job_rec
      IN (SELECT owner || '.' || job_name job_name
            FROM dba_scheduler_running_jobs)
   LOOP
      DBMS_OUTPUT.PUT_LINE ('STOP JOB ' || job_rec.job_name);
      DBMS_SCHEDULER.stop_job (job_rec.job_name);
   END LOOP;
END;
/
@scheduler_job_running.sql