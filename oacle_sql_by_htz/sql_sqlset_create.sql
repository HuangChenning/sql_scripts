SET ECHO OFF
SET lines 200
set pages 0
@sql_sqlset
DECLARE
   v_sqlset_name varchar2(1000);
   v_sqlset_desc varchar2(1000);
   v_sqlset_owner varchar2(100);
BEGIN
    v_sqlset_name := '&sqlset_name';
    v_sqlset_desc := '&sqlset_desc';
    v_sqlset_owner:= nvl(upper('&sqlset_owner'),NULL);
    DBMS_SQLTUNE.create_sqlset (sqlset_name   => v_sqlset_name,
                               description   => v_sqlset_desc,
                               sqlset_owner  => v_sqlset_owner
                               );
END;
/
@sql_sqlset