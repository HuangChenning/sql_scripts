set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col t_t_n for a25 heading 'Table_name'
col column_id for 999 heading 'Col|Id'
COL column_name for a20 heading 'Column_Name'
col d_type for a15 heading 'Column|Date Type'
col nullable for a7 heading 'Is Null'
ACCEPT owner prompt 'Enter Search Table Owner (i.e. htz) : '
ACCEPT name prompt 'Enter Search Table Name (i.e. part) : '
break on t_t_n
/* Formatted on 2013/1/26 13:50:59 (QP5 v5.215.12089.38647) */
  SELECT tb.table_name t_t_n,
         tb.column_id,
         tb.column_name,
         tb.data_type || '(' || data_length || ')' d_type,
         tb.NULLABLE,
         tb.num_nulls, 
         tb.num_distinct,
         tb.num_buckets,
         tc.density,
         to_char(tb.last_analyzed,'yyyy-mm-dd hh24:mi:ss'),
         tb.sample_size,
         tb.HISTOGRAM
    FROM dba_tab_columns tb, dba_tab_col_statistics tc
   WHERE     tb.table_name = UPPER ('&name')
         AND tb.owner = UPPER ('&owner')
         AND tc.owner = tb.owner
         AND tc.table_name = tb.table_name
         AND tc.column_name(+) = tb.column_name
ORDER BY column_id;

ACCEPT column_name prompt 'Enter Search Column_name (i.e. part) : '
exec dbms_stats.delete_column_stats(ownname=>upper('&owner'),tabname=>upper('&name'),colname=>upper('&column_name'),cascade_parts=>TRUE);
  SELECT tb.table_name t_t_n,
         tb.column_id,
         tb.column_name,
         tb.data_type || '(' || data_length || ')' d_type,
         tb.NULLABLE,
         tb.num_nulls, 
         tb.num_distinct,
         tb.num_buckets,
         tc.density,
         to_char(tb.last_analyzed,'yyyy-mm-dd hh24:mi:ss'),
         tb.sample_size,
         tb.HISTOGRAM
    FROM dba_tab_columns tb, dba_tab_col_statistics tc
   WHERE     tb.table_name = UPPER ('&name')
         AND tb.owner = UPPER ('&owner')
         AND tc.owner = tb.owner
         AND tc.table_name = tb.table_name
         AND tc.column_name(+) = tb.column_name
ORDER BY column_id;
clear    breaks  
