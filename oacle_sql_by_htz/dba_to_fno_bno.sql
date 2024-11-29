/* Formatted on 2015/3/20 0:41:45 (QP5 v5.240.12305.39446) */
set echo off
set lines 200 pages 0 verify off heading off
set serveroutput on
DECLARE
   x            NUMBER;
   digits#      NUMBER;
   results      NUMBER := 0;
   file#        NUMBER := 0;
   block#       NUMBER := 0;
   cur_digit    CHAR (1);
   cur_digit#   NUMBER;
   iblock       VARCHAR2(100) := '&blockid';
   imode        VARCHAR2(100) := '&mode';
BEGIN
   IF UPPER (imode) = 'H'
   THEN
      digits# := LENGTH (replace(iblock,' '));

      FOR x IN 1 .. digits#
      LOOP
         cur_digit := UPPER (SUBSTR (replace(iblock,' '), x, 1));

         IF cur_digit IN ('A', 'B', 'C', 'D', 'E', 'F')
         THEN
            cur_digit# := ASCII (cur_digit) - ASCII ('A') + 10;
         ELSE
            cur_digit# := TO_NUMBER (cur_digit);
         END IF;

         results := (results * 16) + cur_digit#;
      END LOOP;
   ELSE
      IF UPPER (imode) = 'D'
      THEN
         results := TO_NUMBER (replace(iblock,' '));
      ELSE
         DBMS_OUTPUT.put_line ('H = Hex Input ... D = Decimal Input');
         RETURN;
      END IF;
   END IF;

   file# := DBMS_UTILITY.data_block_address_file (results);
   block# := DBMS_UTILITY.data_block_address_block (results);

   DBMS_OUTPUT.put_line ('.');
   DBMS_OUTPUT.put_line ('The file is ' || file#);
   DBMS_OUTPUT.put_line ('The block is ' || block#);
END;
/
set heading on
