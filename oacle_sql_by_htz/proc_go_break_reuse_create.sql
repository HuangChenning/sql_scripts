CREATE OR REPLACE PROCEDURE proc_go_break_reuse(v_XIDUSN  NUMBER,
                                                v_XIDSLOT NUMBER,
                                                v_XIDSQN  NUMBER)
/* ¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¨C
  Create_user :Mecoyoo
  Time:2008-5-08
  Description:It¡¯s used to make transaction slot reused
  ¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª*/
 AS
  nsid NUMBER;
  TYPE transaction_record_type IS record(
    XIDUSN  NUMBER,
    XIDSLOT NUMBER,
    XIDSQN  NUMBER);
  transaction_record transaction_record_type;
BEGIN
  SELECT sys_context('userenv', 'sid') INTO nsid FROM dual;
  loop
    INSERT INTO goon
      SELECT * FROM dba_objects WHERE rownum < 100;
    SELECT XIDUSN, XIDSLOT, XIDSQN
      INTO transaction_record
      FROM v$transaction a, v$session b
     WHERE a.ADDR = b.TADDR
       AND b.SID = nsid;
    IF (transaction_record.XIDUSN = v_XIDUSN AND
       transaction_record.XIDSLOT = v_XIDSLOT AND
       transaction_record.XIDSQN > v_XIDSQN) THEN
      GOTO resue_end;
    END IF;
    commit;
    DELETE FROM goon;
    SELECT XIDUSN, XIDSLOT, XIDSQN
      INTO transaction_record
      FROM v$transaction a, v$session b
     WHERE a.ADDR = b.TADDR
       AND b.SID = nsid;
    IF (transaction_record.XIDUSN = v_XIDUSN AND
       transaction_record.XIDSLOT = v_XIDSLOT AND
       transaction_record.XIDSQN > v_XIDSQN) THEN
      GOTO resue_end;
    END IF;
    commit;
  END loop;
  <<resue_end>>
  commit;
END;
/
