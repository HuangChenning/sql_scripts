SET ECHO OFF
SET lines 200 pages 500  verify off heading on
undefine owner;
undefine table_name;
undefine tablespace_name;
DECLARE
  v_table_owner     varchar2(100);
  v_table_name      varchar2(1000);
  v_tablespace_name varchar2(100);
BEGIN
  v_table_owner     := nvl(upper('&owner'), NULL);
  v_table_name      := upper('&table_name');
  v_tablespace_name := nvl(upper('&tablespace_name'), 'SYSTEM');
  DBMS_SQLTUNE.CREATE_STGTAB_SQLSET(table_name      => v_table_name,
                                    schema_name     => v_table_owner,
                                    tablespace_name => v_tablespace_name
                                    );
END;
/

