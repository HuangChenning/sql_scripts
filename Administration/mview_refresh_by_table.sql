set echo off
set long 55555
set lines 300
set pages 50
set serveroutput on
set verify off
set heading on
DECLARE
  fail_num number;
begin
  fail_num := 10000;
  dbms_mview.REFRESH_DEPENDENT(fail_num,
                               UPPER('&scott_tablename'),
                               upper('&REFRESH_MODE'));
  dbms_output.put_line('--------------------------------------------------------------');
  dbms_output.put_line('IF FAILURE NUMBER IS 1000,THEN YOU INPUT ERROR PARAMETER VALUE');
  dbms_output.put_line('FAILURE NUMBER ' || fail_num);
  dbms_output.put_line('--------------------------------------------------------------');
END;
/
undefine scott_tablename;
undefine refresh_mode;
