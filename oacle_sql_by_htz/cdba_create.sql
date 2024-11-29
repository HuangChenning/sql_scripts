CREATE OR REPLACE PROCEDURE cdba(iblock VARCHAR2, imode VARCHAR2) AS
  x          NUMBER;
  digits#    NUMBER;
  results    NUMBER := 0;
  file#      NUMBER := 0;
  block#     NUMBER := 0;
  cur_digit  CHAR(1);
  cur_digit# NUMBER;
BEGIN
  IF upper(imode) = 'H' THEN
    digits# := length(iblock);
    FOR x IN 1 .. digits# LOOP
      cur_digit := upper(substr(iblock, x, 1));
      IF cur_digit IN ('A', 'B', 'C', 'D', 'E', 'F') THEN
        cur_digit# := ascii(cur_digit) ¨C ascii('A') + 10;
      ELSE
        cur_digit# := to_number(cur_digit);
      END IF;
      results := (results * 16) + cur_digit#;
    END LOOP;
  ELSE
    IF upper(imode) = 'D' THEN
      ¨Cresults := to_number(iblock, 'XXXXXXXX');
      results   := iblock;
    ELSE
      dbms_output.put_line('H = Hex Input ¡­ D = Decimal Input');
      RETURN;
    END IF;
  END IF;
  file#  := dbms_utility.data_block_address_file(results);
  block# := dbms_utility.data_block_address_block(results);
  dbms_output.put_line('.');
  dbms_output.put_line('The file is ' || file#);
  dbms_output.put_line('The block is ' || block#);
END;
/
