set echo off
set lines 200 pages 4000 verify off heading on
col owner for a15
col table_name for a30
col column_name for a30
col endpoint_value for 99999999999999999999999999999999999999999999999999.9999
col endpoint_number for 99999999999999999999
undefine owner;
undefine tablename;
undefine columnname;
select owner, table_name, column_name, endpoint_value, endpoint_number
  from dba_tab_histograms a
 where a.owner = upper('&owner')
   and a.table_name = upper('&tablename')
   and a.column_name = nvl(upper('&columnname'), a.column_name)
 order by owner, table_name, column_name, endpoint_value
/
undefine owner;
undefine tablename;
undefine columnname;