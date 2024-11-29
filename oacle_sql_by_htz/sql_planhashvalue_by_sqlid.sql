set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40

PROMPT sql_id default is all
PROMPT child_no default is 0
SELECT sql_id, a.child_number, plan_hash_value
  FROM v$sql a
 WHERE     sql_id = NVL ('&sql_id', a.sql_id)
       AND child_number = NVL ('&child_no', a.child_number)
/
clear    breaks  
@sqlplusset
undefine sql_id
undefine child_no

