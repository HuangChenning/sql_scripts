set echo off
set verify off
set pages 2000
set lines 170
col wt for a25 heading 'OWNER|TABLE_NAME'
col index_name for a20 
col COLUMN_NAME for a15  heading 'PARTITION|COLUMN NAME'
col COLUMN_POSITION  for 99 heading 'COLUMN|POSITION'
col partition_name for a20 
col HIGH_VALUE for  a15
col HIGH_VALUE_LENGTH for 99 heading 'HIGH_VALUE|LENGTH'
col tablespace_name for a15 heading 'TABLESPACE|NAME'
col num_rows for 9999999
col blocks for 9999999
col EMPTY_BLOCKS for 999 heading 'EMPTY|BLOCKS'
col l_time for a19 heading 'LAST TIME|ANALYZED'
COL AVG_SPACE FOR 999999
col SUBPARTITION_COUNT for 99 heading 'SUBPARTITION|COUNT'
col compression for a11
col t_size for a10 heading 'PARTITION|SIZE_KB'
col partitioning_type for a10 heading 'PARTITION|TYPE'
col subpartitioning_type for a10 heading 'SUBPART|TYPE'
col partition_count for 99 heading 'PART|COUNT'
col def_subpartition_count for 99 heading 'SUBPART|COUNT'
col partitioning_key_count for 99 heading 'PARTITION|KEY COUNT'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display a partition table info                                         |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search Object Owner (i.e. SCOTT) : '
ACCEPT tablename prompt 'Enter Search Table Name (i.e. DEPT) : '
ACCEPT indexname prompt 'Enter Search Index Name (i.e. DEPT) : '

select a.owner || ':' || b.table_name wt,
       a.name index_name,
       b.locality,
       b.partitioning_type,
       b.partition_count,
       b.subpartitioning_type,
       a.column_name,
       a.column_position
  from dba_part_key_columns a, dba_part_indexes b
 where a.owner = b.owner
   and a.name = b.index_name
   and a.object_type = 'INDEX'
   and a.owner = nvl(upper('&owner'), a.owner)
   and b.table_name = nvl(upper('&tablename'), b.table_name)
   and a.name = nvl(upper('&indexname'), a.name);

