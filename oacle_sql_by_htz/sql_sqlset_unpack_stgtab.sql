set echo off
set lines 2000 pages 2000 verify off heading on
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
select sysdate from dual;
@sql_sqlset;
declare
  v_sqlset_name          varchar2(1000);
  v_sqlset_owner         varchar2(1000);
  v_replace              BOOLEAN;
  v_staging_table_name   varchar2(1000);
  v_staging_schema_owner varchar2(1000);
begin
  v_sqlset_name          := nvl('&sqlset_name','%');
  v_sqlset_owner         := nvl(upper('&sqlset_owner'), '%');
  v_replace              := &true_or_false;
  v_staging_table_name   := upper('&staging_table_name');
  v_staging_schema_owner := upper('&staging_schema_owner');

  DBMS_SQLTUNE.UNPACK_STGTAB_SQLSET(sqlset_name          => v_sqlset_name,
                                    sqlset_owner         => v_sqlset_owner,
                                    replace              => true,
                                    staging_table_name   => v_staging_table_name,
                                    staging_schema_owner => v_staging_schema_owner);
end;
/
@sql_sqlset