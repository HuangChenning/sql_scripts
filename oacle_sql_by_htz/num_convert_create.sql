create or replace package num_convert as           
  function hex_to_dec (hexin IN VARCHAR2) return NUMBER;
  PRAGMA restrict_references (HEX_TO_DEC,WNDS,RNDS,WNPS,WNPS);

  function dec_to_hex (decin IN NUMBER) return VARCHAR2;
  PRAGMA restrict_references (DEC_TO_HEX,WNDS,RNDS,WNPS,WNPS);

  function oct_to_dec (octin IN NUMBER) return NUMBER;
  PRAGMA restrict_references (OCT_TO_DEC,WNDS,RNDS,WNPS,WNPS);

  function dec_to_oct (decin IN NUMBER) return VARCHAR2;
  PRAGMA restrict_references (DEC_TO_OCT,WNDS,RNDS,WNPS,WNPS);

  function bin_to_dec (binin IN NUMBER) return NUMBER;
  PRAGMA restrict_references (BIN_TO_DEC,WNDS,RNDS,WNPS,WNPS);

  function dec_to_bin (decin IN NUMBER) return VARCHAR2;
  PRAGMA restrict_references (DEC_TO_BIN,WNDS,RNDS,WNPS,WNPS);

  function hex_to_bin (hexin IN VARCHAR2) return NUMBER;
  PRAGMA restrict_references (HEX_TO_BIN,WNDS,RNDS,WNPS,WNPS);

  function bin_to_hex (binin IN NUMBER) return VARCHAR2;
  PRAGMA restrict_references (BIN_TO_HEX,WNDS,RNDS,WNPS,WNPS);

  function oct_to_bin (octin IN NUMBER) return NUMBER;
  PRAGMA restrict_references (OCT_TO_BIN,WNDS,RNDS,WNPS,WNPS);

  function bin_to_oct (binin IN NUMBER) return NUMBER;
  PRAGMA restrict_references (BIN_TO_OCT,WNDS,RNDS,WNPS,WNPS);

  function oct_to_hex (octin IN NUMBER) return VARCHAR2;
  PRAGMA restrict_references (OCT_TO_HEX,WNDS,RNDS,WNPS,WNPS);

  function hex_to_oct (hexin IN VARCHAR2) return NUMBER;
  PRAGMA restrict_references (HEX_TO_OCT,WNDS,RNDS,WNPS,WNPS);                                        
  
end num_convert;
/
create or replace package body num_convert as
  
  function hex_to_dec (hexin IN VARCHAR2) return NUMBER IS
    v_charpos NUMBER;
    v_charval CHAR(1);
    v_return NUMBER DEFAULT 0;
    v_power NUMBER DEFAULT 0;
    v_string VARCHAR2(2000);
  begin
    IF hexin IS NULL THEN 
       return NULL; 
    end IF;
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
            end IF;
         end IF;
         v_charpos := v_charpos - 1;
         v_power := v_power + 1;
    end LOOP;
    return v_return;
    end hex_to_dec;

    function dec_to_hex (decin IN NUMBER) return VARCHAR2 IS
      v_decin NUMBER;
      v_next_digit NUMBER;
      v_result varchar(2000);
    begin
      IF decin = 0 THEN 
         return '0';
      ELSIF decin IS NULL THEN 
            return NULL;
      end IF;
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
               end IF;
            ELSE
              v_result := to_char(v_next_digit) || v_result;
            end IF;
            v_decin := floor(v_decin / 16);
      end LOOP;
      return v_result;
   end dec_to_hex;

   function oct_to_dec (octin IN NUMBER) return NUMBER IS
     v_charpos NUMBER;
     v_charval CHAR(1);
     v_return NUMBER DEFAULT 0;
     v_power NUMBER DEFAULT 0;
     v_string VARCHAR2(2000);
   begin
     IF octin = 0 THEN 
        return 0;
     ELSIF octin IS NULL THEN 
           return NULL;
     end IF;
     v_string := TO_CHAR(octin);
     v_charpos := LENGTH(v_string);
     WHILE v_charpos > 0 LOOP
           v_charval := SUBSTR(v_string,v_charpos,1);
           IF v_charval BETWEEN '0' AND '7' THEN
              v_return := v_return + TO_NUMBER(v_charval) * POWER(8,v_power);
           ELSE
              raise_application_error(-20621,'Invalid input');
           end IF;
           v_charpos := v_charpos - 1;
           v_power := v_power + 1;
     end LOOP;
     return v_return;
   end oct_to_dec;

   function dec_to_oct (decin IN NUMBER) return VARCHAR2 IS
     v_decin NUMBER;
     v_next_digit NUMBER;
     v_result varchar(2000);
   begin
     IF decin = 0 THEN 
        return '0';
     ELSIF decin IS NULL THEN 
           return NULL;
     end IF;
     v_decin := decin;
     WHILE v_decin > 0 LOOP
           v_next_digit := mod(v_decin,8);
           v_result := to_char(v_next_digit) || v_result;
           v_decin := floor(v_decin / 8);
     end LOOP;
     return v_result;
   end dec_to_oct;

   function bin_to_dec (binin IN NUMBER) return NUMBER IS
     v_charpos NUMBER;
     v_charval CHAR(1);
     v_return NUMBER DEFAULT 0;
     v_power NUMBER DEFAULT 0;
     v_string VARCHAR2(2000);
   begin
     IF binin = 0 THEN 
        return 0;
     ELSIF binin IS NULL THEN 
        return NULL;
     end IF;
     v_string := TO_CHAR(binin);
     v_charpos := LENGTH(v_string);
     WHILE v_charpos > 0 LOOP
           v_charval := SUBSTR(v_string,v_charpos,1);
           IF v_charval BETWEEN '0' AND '1' THEN
             v_return := v_return + TO_NUMBER(v_charval) * POWER(2,v_power);
          ELSE
             raise_application_error(-20621,'Invalid input');
          end IF;
          v_charpos := v_charpos - 1;
          v_power := v_power + 1;
    end LOOP;
    return v_return;
  end bin_to_dec;

  function dec_to_bin (decin IN NUMBER) return VARCHAR2 IS
    v_decin NUMBER;
    v_next_digit NUMBER;
    v_result varchar(2000);
  begin
    IF decin = 0 THEN 
       return '0';
    ELSIF decin IS NULL THEN 
          return NULL;
    end IF;
    v_decin := decin;
    WHILE v_decin > 0 LOOP
          v_next_digit := mod(v_decin,2);
          v_result := to_char(v_next_digit) || v_result;
          v_decin := floor(v_decin / 2);
    end LOOP;
    return v_result;
  end dec_to_bin;

  function hex_to_bin (hexin IN VARCHAR2) return NUMBER IS
  begin
    return dec_to_bin(hex_to_dec(hexin));
  end hex_to_bin;

  function bin_to_hex (binin IN NUMBER) return VARCHAR2 IS
  begin
    return dec_to_hex(bin_to_dec(binin));
  end bin_to_hex;

  function oct_to_bin (octin IN NUMBER) return NUMBER IS
  begin
    return dec_to_bin(oct_to_dec(octin));
  end oct_to_bin;

  function bin_to_oct (binin IN NUMBER) return NUMBER IS
  begin
    return dec_to_oct(bin_to_dec(binin));
  end bin_to_oct;

  function oct_to_hex (octin IN NUMBER) return VARCHAR2 IS
  begin
    return dec_to_hex(oct_to_dec(octin));
  end oct_to_hex;

  function hex_to_oct (hexin IN VARCHAR2) return NUMBER IS
  begin
    return dec_to_oct(hex_to_dec(hexin));
  end hex_to_oct;
   
end num_convert;
/