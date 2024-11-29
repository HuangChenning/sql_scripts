CREATE OR REPLACE PROCEDURE scott.table_insert
IS
   v_num      NUMBER := 1;
   v_number   NUMBER := 1;
BEGIN
   WHILE v_num < 100
   LOOP
      INSERT INTO scott.table_date
           VALUES (v_number, SYSDATE);

      v_number := v_number + 1;

      IF (MOD (v_number, 100) = 0)
      THEN
         COMMIT;
      END IF;
   END LOOP;
END;
/


    VAR job_no NUMBER;

BEGIN
   FOR idx IN 1 .. 30
   LOOP
      DBMS_JOB.submit ( :job_no, 'scott.table_insert;');
      COMMIT;
   END LOOP;
END;
/

ALTER SYSTEM SET job_queue_processes=1000;

