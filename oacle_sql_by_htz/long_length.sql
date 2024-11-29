set echo off
set pages 0
set lines 200
set verify off
select &&column_name,long_length('&&column_name', '&&owner_and_tablename', ROWID) FROM &&owner_and_tablename;
undefine column_name
undefine owner_and_tablename
set pages 40
set lines 80
set verify on
set echo on
