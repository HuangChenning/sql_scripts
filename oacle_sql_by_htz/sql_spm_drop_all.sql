
declare
pgn number;
sqlhdl varchar2(30);
cursor hdl_cur is
select distinct sql_handle from dba_sql_plan_baselines;
begin
open hdl_cur;

loop
fetch hdl_cur into sqlhdl;
exit when hdl_cur%NOTFOUND;

pgn := dbms_spm.drop_sql_plan_baseline(sql_handle=>sqlhdl);
end loop;

close hdl_cur;
commit;
end;
/
