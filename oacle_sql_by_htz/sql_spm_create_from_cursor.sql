set echo off
set verify off
undefine sqlid;
undefine plan_hash_value;
variable rst number
exec :rst := dbms_spm.load_plans_from_cursor_cache(sql_id => '&sqlid', plan_hash_value => '&plan_hash_value',FIXED=>nvl('&FIXED','NO'),enabled=>nvl('&enable','YES'))
undefine sqlid;
undefine plan_hash_value;