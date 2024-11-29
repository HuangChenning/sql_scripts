set echo off
set lines 2000 pages 400 verify off heading on;
@sql_sqlset
declare
  v_sqlset_name          varchar2(1000);
  v_sqlset_owner         varchar2(1000);
  v_staging_table_name   varchar2(1000);
  v_staging_schema_owner varchar2(1000);
begin
  v_sqlset_name          := '&sqlset_name';
  v_sqlset_owner         := nvl(upper('&sqlset_owner'), NULL);
  v_staging_table_name   := upper('&staging_table_name');
  v_staging_schema_owner := nvl(upper('&staging_table_owner'), NULL);

  DBMS_SQLTUNE.PACK_STGTAB_SQLSET(sqlset_name          => v_sqlset_name,
                                  sqlset_owner         => v_sqlset_owner,
                                  staging_table_name   => v_staging_table_name,
                                  staging_schema_owner => v_staging_schema_owner);
end;
/
