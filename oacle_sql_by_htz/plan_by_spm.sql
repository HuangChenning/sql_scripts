set  echo off
set long 100000000
set pages 50000
select * from table(dbms_xplan.display_sql_plan_baseline(sql_handle=>'&sql_handle',plan_name=>nvl('&plan_name',NULL),format=>nvl('&FORMAT','TYPICAL')));
undefine sqlid;
undefine format;
