/* Formatted on 2014/8/24 16:08:28 (QP5 v5.240.12305.39446) */
set echo off
set verify off
set lines 2000 pages 500 heading on 
DECLARE
   v_XIDUSN             NUMBER;
   v_XIDSLOT            NUMBER;
   v_XIDSQN             NUMBER;
   nsid                 NUMBER;

   TYPE transaction_record_type IS RECORD
   (
      XIDUSN    NUMBER,
      XIDSLOT   NUMBER,
      XIDSQN    NUMBER
   );

   transaction_record   transaction_record_type;
BEGIN
   v_XIDUSN := &xidusn;
   v_XIDSLOT := &xidslot;
   v_XIDSQN := &xidsqn;

   EXECUTE IMMEDIATE 'drop table system.huangtingzhong_1';

   EXECUTE IMMEDIATE
      'create table system.huangtingzhong_1 as select * from dba_objects where 1=2';

   SELECT SYS_CONTEXT ('userenv', 'sid') INTO nsid FROM DUAL;

   LOOP
      INSERT INTO SYSTEM.huangtingzhong_1
         SELECT *
           FROM dba_objects
          WHERE ROWNUM < 2;

      SELECT XIDUSN, XIDSLOT, XIDSQN
        INTO transaction_record
        FROM v$transaction a, v$session b
       WHERE a.ADDR = b.TADDR AND b.SID = nsid;

      IF (    transaction_record.XIDUSN = v_XIDUSN
          AND transaction_record.XIDSLOT = v_XIDSLOT
          AND transaction_record.XIDSQN > v_XIDSQN)
      THEN
         GOTO resue_end;
      END IF;

      COMMIT;

      DELETE FROM SYSTEM.huangtingzhong_1;

      SELECT XIDUSN, XIDSLOT, XIDSQN
        INTO transaction_record
        FROM v$transaction a, v$session b
       WHERE a.ADDR = b.TADDR AND b.SID = nsid;

      IF (    transaction_record.XIDUSN = v_XIDUSN
          AND transaction_record.XIDSLOT = v_XIDSLOT
          AND transaction_record.XIDSQN > v_XIDSQN)
      THEN
         GOTO resue_end;
      END IF;

      COMMIT;
   END LOOP;

  <<resue_end>>
   COMMIT;
END;
/