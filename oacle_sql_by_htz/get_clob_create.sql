CREATE OR REPLACE FUNCTION GET_CLOB(srcclob in clob,
                                    s       in integer,
                                    e       in integer) RETURN CLOB IS
  newclob  clob;
  l_buffer VARCHAR2(32767);
  l_amount integer := 24000;
  dev      integer;
  md       integer;
BEGIN
  dev := floor((e - s + 1) / l_amount);
  md  := mod(e - s + 1, l_amount);
  dbms_output.put_line('DEV:' || dev || ' MOD:' || md);
  dbms_output.put_line('e:' || e || ' s:' || s);
  FOR i in 1 .. dev LOOP
    newclob := newclob ||
               dbms_lob.substr(srcclob, l_amount, (i - 1) * l_amount + s);
  END LOOP;
  newclob := newclob || dbms_lob.substr(srcclob, md, dev * l_amount + s);
  RETURN(newclob);
END;
/
