@sql_spm
set verify off
set echo off
declare
xx PLS_INTEGER;
BEGIN
xx :=dbms_spm.drop_sql_plan_baseline(sql_handle=>'&sql_handle',plan_name=>nvl('&plan_name',null));
END;
/
undefine sql_handle;
undefine plan_name;
@sql_spm
set echo on