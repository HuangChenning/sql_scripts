set echo off
set verify off
set heading on
set lines 200
SELECT dbms_utility.data_block_address_file('&&dba') "FILE",dbms_utility.data_block_address_block('&&dba') "BLOCK"  FROM dual;
undefine dba
