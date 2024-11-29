set echo off
set long 65534
set lines 300
set pages 50
set heading on
set feed on
set verify off
col o_m for a35 heading 'OWNER|TABLE_NAME'
col log_table for a20 heading 'MVIEW_LOG_NAME'
col rowids for a5 heading 'ROWID'
col primary_key for a5 heading 'PRIMARY|KEY'
col object_id for a6 heading 'OBJECT|ID'
col filter_columns for a7 heading 'FILTER|COLUMNS'
col sequence for a5 heading 'SEQU|ENCE'
col include_new_values for a10 heading 'INCLUDE|NEW_VALUES'
select a.log_owner||'.'||a.master o_m,
       a.log_table,     
       a.rowids,
       a.primary_key,
       a.object_id,
       a.filter_columns,
       a.sequence,
       a.include_new_values
  from dba_mview_logs a
  where a.log_owner=nvl(upper('&owner'),a.log_owner)
        and a.master=nvl(upper('&tablename'),a.master);
undefine owner;
undefine tablename;