set verify off
set serveroutput on
DECLARE   v_rowid_type          NUMBER;
   v_OBJECT_NUMBER       NUMBER;
   v_RELATIVE_FNO        NUMBER;
   v_BLOCK_NUMBERE_FNO   NUMBER;
   v_ROW_NUMBER          NUMBER;
BEGIN
   DBMS_ROWID.rowid_info (
      	         rowid_in        => '&rowid',
                 rowid_type      => v_rowid_type,
                 object_number   => v_OBJECT_NUMBER,
                 relative_fno    => v_RELATIVE_FNO,
                 block_number    => v_BLOCK_NUMBERE_FNO,
                 ROW_NUMBER      => v_ROW_NUMBER);
   DBMS_OUTPUT.put_line ('ROWID_TYPE:  ' || TO_CHAR (v_rowid_type));
       DBMS_OUTPUT.put_line ('OBJECT_NUMBER:  ' || TO_CHAR (v_OBJECT_NUMBER));
   DBMS_OUTPUT.put_line ('RELATIVE_FNO:  ' || TO_CHAR (v_RELATIVE_FNO));
   DBMS_OUTPUT.put_line ('BLOCK_NUMBER:  ' || TO_CHAR (v_BLOCK_NUMBERE_FNO));
   DBMS_OUTPUT.put_line ('ROW_NUMBER:  ' || TO_CHAR (v_ROW_NUMBER));
END;
/
undefine rowid
set serveroutput off
