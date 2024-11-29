CREATE OR REPLACE PACKAGE base_convert AS

/*************************************************************************\
*                                                                         *
*  BASE_CONVERT:                                                          *
*  Packaged functions to convert numbers between one base and another.    *
*                                                                         *
*  USAGE:                                                                 *
*  base_convert.<function>(input value)                                   *
*  where function is one of the contained function names and input value  *
*  is a number to be converted.  All input and return variables are       *
*  number format except for those involving hexadecimal values, which are *
*  varchar2.                                                              *
*                                                                         *
*  HISTORY:                                                               *
*  20-Nov-97 DAUSTIN Initial version  (TFTS)                              *
*  15-May-06 DAUSTIN Revised to return 0 and NULL values correctly        *
*                                                                         *
\*************************************************************************/

FUNCTION hex_to_dec (hexin IN VARCHAR2) RETURN NUMBER;
PRAGMA restrict_references (HEX_TO_DEC,WNDS,RNDS,WNPS,WNPS);

FUNCTION dec_to_hex (decin IN NUMBER) RETURN VARCHAR2;
PRAGMA restrict_references (DEC_TO_HEX,WNDS,RNDS,WNPS,WNPS);

FUNCTION oct_to_dec (octin IN NUMBER) RETURN NUMBER;
PRAGMA restrict_references (OCT_TO_DEC,WNDS,RNDS,WNPS,WNPS);

FUNCTION dec_to_oct (decin IN NUMBER) RETURN VARCHAR2;
PRAGMA restrict_references (DEC_TO_OCT,WNDS,RNDS,WNPS,WNPS);

FUNCTION bin_to_dec (binin IN NUMBER) RETURN NUMBER;
PRAGMA restrict_references (BIN_TO_DEC,WNDS,RNDS,WNPS,WNPS);

FUNCTION dec_to_bin (decin IN NUMBER) RETURN VARCHAR2;
PRAGMA restrict_references (DEC_TO_BIN,WNDS,RNDS,WNPS,WNPS);

FUNCTION hex_to_bin (hexin IN VARCHAR2) RETURN NUMBER;
PRAGMA restrict_references (HEX_TO_BIN,WNDS,RNDS,WNPS,WNPS);

FUNCTION bin_to_hex (binin IN NUMBER) RETURN VARCHAR2;
PRAGMA restrict_references (BIN_TO_HEX,WNDS,RNDS,WNPS,WNPS);

FUNCTION oct_to_bin (octin IN NUMBER) RETURN NUMBER;
PRAGMA restrict_references (OCT_TO_BIN,WNDS,RNDS,WNPS,WNPS);

FUNCTION bin_to_oct (binin IN NUMBER) RETURN NUMBER;
PRAGMA restrict_references (BIN_TO_OCT,WNDS,RNDS,WNPS,WNPS);

FUNCTION oct_to_hex (octin IN NUMBER) RETURN VARCHAR2;
PRAGMA restrict_references (OCT_TO_HEX,WNDS,RNDS,WNPS,WNPS);

FUNCTION hex_to_oct (hexin IN VARCHAR2) RETURN NUMBER;
PRAGMA restrict_references (HEX_TO_OCT,WNDS,RNDS,WNPS,WNPS);

END base_convert;
/

CREATE OR REPLACE PACKAGE BODY base_convert AS

FUNCTION hex_to_dec (hexin IN VARCHAR2) RETURN NUMBER IS
  v_charpos NUMBER;
  v_charval CHAR(1);
  v_return NUMBER DEFAULT 0;
  v_power NUMBER DEFAULT 0;
  v_string VARCHAR2(2000);
BEGIN
  IF hexin IS NULL THEN RETURN NULL; END IF;
  v_string := UPPER(hexin);
  v_charpos := LENGTH(v_string);
  WHILE v_charpos > 0 LOOP
    v_charval := SUBSTR(v_string,v_charpos,1);
    IF v_charval BETWEEN '0' AND '9' THEN
      v_return := v_return + TO_NUMBER(v_charval) * POWER(16,v_power);
    ELSE
      IF v_charval = 'A' THEN
        v_return := v_return + 10 * POWER(16,v_power);
      ELSIF v_charval = 'B' THEN
        v_return := v_return + 11 * POWER(16,v_power);
      ELSIF v_charval = 'C' THEN
        v_return := v_return + 12 * POWER(16,v_power);
      ELSIF v_charval = 'D' THEN
        v_return := v_return + 13 * POWER(16,v_power);
      ELSIF v_charval = 'E' THEN
        v_return := v_return + 14 * POWER(16,v_power);
      ELSIF v_charval = 'F' THEN
        v_return := v_return + 15 * POWER(16,v_power);
      ELSE
        raise_application_error(-20621,'Invalid input');
      END IF;
    END IF;
    v_charpos := v_charpos - 1;
    v_power := v_power + 1;
  END LOOP;
  RETURN v_return;
END hex_to_dec;

FUNCTION dec_to_hex (decin IN NUMBER) RETURN VARCHAR2 IS
  v_decin NUMBER;
  v_next_digit NUMBER;
  v_result varchar(2000);
BEGIN
  IF decin = 0 THEN RETURN '0';
    ELSIF decin IS NULL THEN RETURN NULL;
  END IF;
  v_decin := decin;
  WHILE v_decin > 0 LOOP
    v_next_digit := mod(v_decin,16);
    IF v_next_digit > 9 THEN
      IF v_next_digit = 10 THEN v_result := 'A' || v_result;
      ELSIF v_next_digit = 11 THEN v_result := 'B' || v_result;
      ELSIF v_next_digit = 12 THEN v_result := 'C' || v_result;
      ELSIF v_next_digit = 13 THEN v_result := 'D' || v_result;
      ELSIF v_next_digit = 14 THEN v_result := 'E' || v_result;
      ELSIF v_next_digit = 15 THEN v_result := 'F' || v_result;
      ELSE raise_application_error(-20600,'Untrapped exception');
      END IF;
    ELSE
      v_result := to_char(v_next_digit) || v_result;
    END IF;
    --As per remark 131965.1 changed the following line not to use floor function
    -- v_decin := floor(v_decin / 16); 
    v_decin := floor(v_decin / 16); 
  END LOOP;
  RETURN v_result;
END dec_to_hex;

FUNCTION oct_to_dec (octin IN NUMBER) RETURN NUMBER IS
  v_charpos NUMBER;
  v_charval CHAR(1);
  v_return NUMBER DEFAULT 0;
  v_power NUMBER DEFAULT 0;
  v_string VARCHAR2(2000);
BEGIN
  IF octin = 0 THEN RETURN 0;
    ELSIF octin IS NULL THEN RETURN NULL;
  END IF;
  v_string := TO_CHAR(octin);
  v_charpos := LENGTH(v_string);
  WHILE v_charpos > 0 LOOP
    v_charval := SUBSTR(v_string,v_charpos,1);
    IF v_charval BETWEEN '0' AND '7' THEN
      v_return := v_return + TO_NUMBER(v_charval) * POWER(8,v_power);
    ELSE
      raise_application_error(-20621,'Invalid input');
    END IF;
    v_charpos := v_charpos - 1;
    v_power := v_power + 1;
  END LOOP;
  RETURN v_return;
END oct_to_dec;

FUNCTION dec_to_oct (decin IN NUMBER) RETURN VARCHAR2 IS
  v_decin NUMBER;
  v_next_digit NUMBER;
  v_result varchar(2000);
BEGIN
  IF decin = 0 THEN RETURN '0';
    ELSIF decin IS NULL THEN RETURN NULL;
  END IF;
  v_decin := decin;
  WHILE v_decin > 0 LOOP
    v_next_digit := mod(v_decin,8);
    v_result := to_char(v_next_digit) || v_result;
    v_decin := floor(v_decin / 8);
  END LOOP;
  RETURN v_result;
END dec_to_oct;

FUNCTION bin_to_dec (binin IN NUMBER) RETURN NUMBER IS
  v_charpos NUMBER;
  v_charval CHAR(1);
  v_return NUMBER DEFAULT 0;
  v_power NUMBER DEFAULT 0;
  v_string VARCHAR2(2000);
BEGIN
  IF binin = 0 THEN RETURN 0;
    ELSIF binin IS NULL THEN RETURN NULL;
  END IF;
  v_string := TO_CHAR(binin);
  v_charpos := LENGTH(v_string);
  WHILE v_charpos > 0 LOOP
    v_charval := SUBSTR(v_string,v_charpos,1);
    IF v_charval BETWEEN '0' AND '1' THEN
      v_return := v_return + TO_NUMBER(v_charval) * POWER(2,v_power);
    ELSE
      raise_application_error(-20621,'Invalid input');
    END IF;
    v_charpos := v_charpos - 1;
    v_power := v_power + 1;
  END LOOP;
  RETURN v_return;
END bin_to_dec;

FUNCTION dec_to_bin (decin IN NUMBER) RETURN VARCHAR2 IS
  v_decin NUMBER;
  v_next_digit NUMBER;
  v_result varchar(2000);
BEGIN
  IF decin = 0 THEN RETURN '0';
    ELSIF decin IS NULL THEN RETURN NULL;
  END IF;
  v_decin := decin;
  WHILE v_decin > 0 LOOP
    v_next_digit := mod(v_decin,2);
    v_result := to_char(v_next_digit) || v_result;
    v_decin := floor(v_decin / 2);
  END LOOP;
  RETURN v_result;
END dec_to_bin;

FUNCTION hex_to_bin (hexin IN VARCHAR2) RETURN NUMBER IS
BEGIN
  RETURN dec_to_bin(hex_to_dec(hexin));
END hex_to_bin;

FUNCTION bin_to_hex (binin IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  RETURN dec_to_hex(bin_to_dec(binin));
END bin_to_hex;

FUNCTION oct_to_bin (octin IN NUMBER) RETURN NUMBER IS
BEGIN
  RETURN dec_to_bin(oct_to_dec(octin));
END oct_to_bin;

FUNCTION bin_to_oct (binin IN NUMBER) RETURN NUMBER IS
BEGIN
  RETURN dec_to_oct(bin_to_dec(binin));
END bin_to_oct;

FUNCTION oct_to_hex (octin IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  RETURN dec_to_hex(oct_to_dec(octin));
END oct_to_hex;

FUNCTION hex_to_oct (hexin IN VARCHAR2) RETURN NUMBER IS
BEGIN
  RETURN dec_to_oct(hex_to_dec(hexin));
END hex_to_oct;

END base_convert;
/