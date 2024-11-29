/* Formatted on 2016/12/1 11:37:18 (QP5 v5.256.13226.35510) */
SET ECHO OFF
SET LINES 200
SET PAGES 50
SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
   v_num   NUMBER := 0;
   v_sql   VARCHAR2 (500);
BEGIN
   SELECT COUNT (*)
     INTO v_num
     FROM dba_tables
    WHERE table_name = UPPER ('htz_backup_dba_jobs') AND owner = 'SYSTEM';

   IF v_num = 0
   THEN
      DBMS_OUTPUT.put_line (
         'SYSTEM.HTZ_BACKUP_DBA_JOBS IS NOT  EXISTS AND WILL CREATE');
   ELSE
      FOR job_rec IN (SELECT job FROM SYSTEM.HTZ_BACKUP_DBA_JOBS)
   LOOP
      DBMS_OUTPUT.put_line ('BROKEN JOB: ' || job_rec.job);
      DBMS_IJOB.run (job_rec.job, TRUE);
   END LOOP;

   END IF;
commit;
END;
/