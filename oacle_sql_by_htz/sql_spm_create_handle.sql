set echo off
set lines 200
set pages 40
set verify off
variable rst number
exec :rst := dbms_spm.load_plans_from_cursor_cache(sql_id => '&sqlid', plan_hash_value => '&plan_hash_value',sql_handle=> '&sql_handle',fixed =>'YES')
undefine sqlid;
undefine plan_hash_value;
undefine sql_handle;
set echo on