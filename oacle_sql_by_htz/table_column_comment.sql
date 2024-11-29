set echo off
set lines 200 pages 4000 verify off heading on
col column_name for a30
col comments for a150
undefine owner;
undefine table_name;
select a.column_name, a.comments
  from dba_col_comments a
 where a.owner = nvl(upper('&owner'), a.owner)
   and a.table_name = nvl(upper('&table_name'), a.table_name) order by a.owner,a.table_name;
undefine owner;
undefine table_name;
