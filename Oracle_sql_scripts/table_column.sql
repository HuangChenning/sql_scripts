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
col l_a for a11 heading 'LAST_ANALYZED'
col avg_col_len for 999999 heading 'AVG|LENGTH'
col n_d_b for a25 heading 'NUM|TOTAL_DISTINCT'
col SELECT for a6 heading 'SELECT'
col num_buckets for 999 heading 'NUM|BUCKET'
col num_nulls for 999999999
col num_rows for 99999999999
col num_distinct for 999999999 heading 'NUM|DISTINCT'
col hist for a9
col stats for a10 heading 'STATS|GLOBAL|USER'
col sample_size for 99999999999
SELECT /*+ rule*/
         tb.column_id,
         tb.column_name,
         tb.data_type || '(' || data_length || ')' d_type,
         tb.NULLABLE,
         tb.num_nulls,
         a.num_rows,
         tb.num_distinct,
         ROUND (tb.num_distinct / DECODE (a.num_rows, 0, 1, a.num_rows) * 100,
                2) ||'%'
            AS "SELECT",
         TO_CHAR (tb.last_analyzed, 'yy-mm-dd hh24') l_a,
         tb.sample_size,
         tb.avg_col_len,
         tb.num_buckets,
         substr(tb.HISTOGRAM,1,8) HIST,tb.GLOBAL_STATS||'.'||tb.USER_STATS stats
    FROM dba_tab_cols tb, dba_tab_col_statistics tc, dba_tables a
   WHERE     tb.owner = NVL (UPPER ('&table_owner'), tb.owner)
         AND tb.table_name = NVL (UPPER ('&table_name'), tb.table_name)
         AND tc.owner(+) = tb.owner
         AND tc.table_name(+) = tb.table_name
         AND tc.column_name(+) = tb.column_name
         AND a.owner = tb.owner
         AND a.table_name = tb.table_name
ORDER BY column_id;
clear    breaks  
undefine table_owner
undefine table_name
