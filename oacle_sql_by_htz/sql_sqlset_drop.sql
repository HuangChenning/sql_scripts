@sql_sqlset
DECLARE
   v_sqlset_name varchar2(1000);
   v_sqlset_owner varchar2(100);
   BEGIN
    v_sqlset_name := '&sqlset_name';
    v_sqlset_owner:= nvl(upper('&sqlset_owner'),NULL);
    DBMS_SQLTUNE.drop_sqlset (sqlset_name   => v_sqlset_name,
                               sqlset_owner  => v_sqlset_owner
                               );
END;
/
@sql_sqlset
