declare
  v_owner       varchar2(100);
  v_object_name varchar2(100);
begin
  select owner, table_name
    into v_owner, v_object_name
    from dba_tables
   where degree <> 1
     and owner not in ('SYS', 'SYSTEM');
  dbms_output.put_line('ALTER TABLE ' || v_owner || '.' || v_object_name ||
                       ' NOPARALLEL');
  execute immediate 'ALTER TABLE ' || v_owner || '.' || v_object_name ||
                    ' NOPARALLEL';
end;
/
