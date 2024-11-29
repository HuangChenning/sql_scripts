SET SERVEROUTPUT ON
SET LINES 200
EXEC mystats_pkg.ms_start;

DECLARE
   v_num   NUMBER := 1;
BEGIN
   WHILE v_num < 1000
   LOOP
     INSERT INTO scott.table_date
           VALUES (v_number, SYSDATE);

      COMMIT;
      v_num := v_num + 1;
   END LOOP;
END;
/
spool 12345.log
EXEC mystats_pkg.ms_stop;
spool off
alter system set job_queue_processes=0;
startup force;