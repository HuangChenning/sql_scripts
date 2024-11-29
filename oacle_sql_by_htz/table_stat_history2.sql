set echo off
set lines 200
set pages 40
set heading on
set verify off
set feedback on
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
col owner_table for a40 heading 'OWNER|TABLE_NAME'
col interval for a40
break on owner_table
undefine owner;
undefine tablename;
select owner || '.' || table_name owner_table,
       partition_name,
       subpartition_name,
       to_char(stats_update_time,'yyyy-mm-dd hh24:mi:ss') stats_update_time,
       stats_update_time - lag(stats_update_time, 1, null) over(partition by owner, table_name order by stats_update_time) interval
  from DBA_TAB_STATS_HISTORY
 where owner = nvl(upper('&owner'),owner)
   and table_name = nvl(upper('&tablename'),table_name)
 order by owner, table_name, stats_update_time desc
/

undefine owner;
undefine tablename;
set echo on;

