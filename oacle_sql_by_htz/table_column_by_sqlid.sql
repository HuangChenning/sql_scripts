set echo off
set verify off
set serveroutput on
set feedback off
set lines 195
set pages 1000
col owner for a12;
col table_name for a25
col column_id for 999 heading 'Col|Id'
COL column_name for a20 heading 'Column_Name'
col d_type for a15 heading 'Column|Date Type'
col nullable for a4 heading 'IS|Null'
col l_a for a15 heading 'LAST_ANALYZED'
col avg_col_len for 999999 heading 'AVG|LENGTH'
col histogram for a5 heading 'HISTO|GRAM'
break on owner on table_name
with t as
 (select /*+ materialize */
  distinct object_owner, object_name
    from (select object_owner, object_name
            from v$sql_plan
           where sql_id = '&&sqlid'
             and object_name is not null
          union all
          select object_owner, object_name
            from dba_hist_sql_plan
           where sql_id = '&&sqlid'
             and object_name is not null))
select tb.owner,
       tb.table_name,
       tb.column_id,
       tb.column_name,
       tb.data_type || '(' || data_length || ')' d_type,
       tb.nullable,
       tb.num_nulls,
       tb.num_distinct,
       tb.num_buckets,
       tc.density,
       to_char(tb.last_analyzed, 'yyyy-mm-dd hh24') l_a,
       tb.sample_size,
       tb.avg_col_len,
       substr(tb.histogram,1,5) histogram
  from dba_tab_cols tb, dba_tab_col_statistics tc
 where (tb.owner, tb.table_name) in
       (select table_owner, table_name
          from dba_indexes
         where (owner, index_name) in (select * from t)
        union all
        select * from t)
   and tc.owner(+) = tb.owner
   and tc.table_name(+) = tb.table_name
   and tc.column_name(+) = tb.column_name
 order by tb.owner,tb.table_name,tb.column_id;
clear    breaks; 
undefine sqlid;
col column_id clear
COL column_name  clear
col d_type clear
col nullable clear
col l_a clear
col avg_col_len clear
