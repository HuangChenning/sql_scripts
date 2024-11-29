set echo off
set long 55555
set lines 300
set pages 50
set serveroutput on
set verify off
set heading on

  DECLARE
    v_ddl varchar(1000);
  begin
    v_ddl := 'no ddl';
    dbms_mview.GET_MV_DEPENDENCIES(UPPER('&scott_tablename'), v_ddl);
    dbms_output.put_line('--------------------------------------------------------------');
    dbms_output.put_line(v_ddl);
    dbms_output.put_line('--------------------------------------------------------------');
  END;
  /

undefine scott_tablename;
undefine refresh_mode;
