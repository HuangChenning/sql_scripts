set echo off
SET SERVEROUTPUT ON
SET LONG 10000
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(sql_handle => '&sql_handle',PLAN_NAME=>'&plan_name',VERIFY=>nvl('&VERIFY','NO'),COMMIT=>nvl('&commit','YES'));
    DBMS_OUTPUT.PUT_LINE(report);
END;
/
