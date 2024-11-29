set echo off
set verify off
set pages 2000
set lines 170
col owner for a15 heading 'TABLE|OWNER'
col name for a20 heading 'TABLE|NAME'
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

ACCEPT owner prompt 'Enter Search Object Owner (i.e. SCOTT) : '
ACCEPT table_name prompt 'Enter Search Table Name (i.e. DEPT) : '


  SELECT a.owner,
         a.name,
         b.partitioning_type,
         b.subpartitioning_type,
         b.partition_count,
         b.def_subpartition_count,
         b.partitioning_key_count,
         a.COLUMN_NAME,
         a.COLUMN_POSITION
    FROM sys.DBA_PART_KEY_COLUMNS a, sys.dba_part_tables b
   WHERE     a.name = UPPER ('&table_name')
         AND a.name = b.table_name
         AND a.owner = UPPER ('&owner')
         AND a.owner = b.owner
ORDER BY a.NAME, a.COLUMN_POSITION
/

SELECT PARTITION_NAME,
         HIGH_VALUE,
         HIGH_VALUE_LENGTH,
         TABLESPACE_NAME,
         NUM_ROWS,
         BLOCKS,
         round(blocks*8/1024,2)||'KB' t_size,
         EMPTY_BLOCKS,
         to_char(LAST_ANALYZED,'yyyy-mm-dd hh24:mi:ss') l_time,
         AVG_SPACE,
         SUBPARTITION_COUNT,
         COMPRESSION
    FROM sys.DBA_TAB_PARTITIONS
   WHERE table_name = upper('&table_name')  AND TABLE_OWNER = upper('&owner')
ORDER BY PARTITION_POSITION
/
