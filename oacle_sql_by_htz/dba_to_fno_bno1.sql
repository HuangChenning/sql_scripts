set echo off
set verify off
set heading on
set lines 200
SELECT dbms_utility.data_block_address_file(to_number('&&dba','xxxxxxxxxxxxxx')) "FILE",dbms_utility.data_block_address_block(to_number('&&dba','xxxxxxxxxxxxxx')) "BLOCK"  FROM dual;
undefine dba
