set echo off
set verify off
set heading on
set lines 200
SELECT dbms_utility.data_block_address_file('&&dba','xxxxxxxxxxxxxx') "FILE",dbms_utility.data_block_address_block('&&dba','xxxxxxxxxxxxxx') "BLOCK"  FROM dual;
undefine dba
