set echo off
set verify off
set serveroutput on
set feedback off
set lines 195
set pages 1000
col column_id for 999 heading 'Col|Id'
COL column_name for a20 heading 'Column_Name'
col d_type for a15 heading 'Column|Date Type'
col nullable for a4 heading 'Null'
undefine table_owner;
undefine table_name;
SELECT /*+ rule*/
 tb.column_id,
 tb.column_name,
 tb.data_type || '(' || data_length || ')' d_type,
 tc.low_value,
 tc.high_value
  FROM dba_tab_cols tb, dba_tab_col_statistics tc, dba_tables a
 WHERE tb.owner = NVL(UPPER('&table_owner'), tb.owner)
   AND tb.table_name = NVL(UPPER('&table_name'), tb.table_name)
   AND tc.owner(+) = tb.owner
   AND tc.table_name(+) = tb.table_name
   AND tc.column_name(+) = tb.column_name
   AND a.owner = tb.owner
   AND a.table_name = tb.table_name
 ORDER BY column_id;
undefine table_owner;
undefine table_name;