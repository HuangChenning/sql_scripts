set echo off
set heading on 
set lines 300
set pages 1000
set verify off
set feed on
undefine owner;
undefine indexname;
undefine tablename;
col index_name for a25
col column_name for a15
col column_position for 9999 heading 'COLU|POST'
col partitioning_type for a5 heading 'PART|TYPE'
col parttion_count for 9999 heading 'PART|COUNT'
col subparttitioning_type for a5 heading 'SUBP|TYPE'
col subpartitioning_key_count for 9999 heading 'SUBP|COUNT'
col locality for a10 heading 'INDEX|TYPE'
col a.def_tablespace_name for a15 heading 'TABLESPACE|DEF_NAME'
col def_parameters for a15 heading 'DEF|PARAMETER'
col interval for a10 heading 'INTERVAL'
select a.index_name,
       b.column_name,
       b.column_position,
       a.partitioning_type,
       a.partition_count,
       a.subpartitioning_type,
       a.subpartitioning_key_count,
       a.locality,
       a.def_tablespace_name,
       a.def_parameters,
       a.interval
  from dba_part_indexes a, dba_part_key_columns b
 where a.owner = nvl(upper('&&owner'), a.owner)
   and a.table_name = nvl(upper('&&tablename'), a.table_name)
   and a.owner = b.owner(+)
   and a.index_name = b.name(+)
   and a.index_name = nvl(upper('&&indexname'), a.index_name)
   and b.object_type = 'INDEX'
   order by index_name,column_position;

col owner_name for a40 heading 'OWNER|INDEX_NAME'
col partition_name for a15 heading 'PARTITION|NAME'
col subpartition_count for 9999 heading 'SUBP|COUNT'
col high_value for a30 heading 'HIGH_VALUE'
col status for a10 
col blevel for 99 heading 'B'
col n_row for a25 heading 'DISTINCT_KEY|NUM_ROWS|%'
col last_analyzed for a12
col PARTITION_POSITION  for 9999 heading 'PART|POST'
/* Formatted on 2013/12/31 11:22:05 (QP5 v5.240.12305.39446) */
  SELECT DECODE (a.index_owner || '.' || a.index_name,
                 '.', b.owner || '.' || b.index_name,
                 a.index_owner || '.' || a.index_name)
            owner_name,
         a.partition_name,
         NVL (c.locality, 'GLOBAL') locality,
         a.subpartition_count,
         a.high_value,
         a.partition_position,
         NVL (a.status, b.status) status,
         NVL (a.blevel, b.blevel) blevel,
            NVL (a.distinct_keys, b.distinct_keys)
         || ':'
         || a.num_rows
         || ':'
         ||   TRUNC (
                   NVL (a.distinct_keys, b.distinct_keys)
                 / DECODE (a.num_rows, 0, NULL, a.num_rows),
                 4)
            * 100
         || '%'
            n_row,
         TO_CHAR (NVL (a.last_analyzed, b.last_analyzed), 'mm-dd hh24:mi')
            last_analyzed
    FROM dba_ind_partitions a, dba_indexes b, dba_part_indexes c
   WHERE     a.index_owner(+) = b.owner
         AND a.index_name(+) = b.index_name
         AND a.index_owner = c.owner(+)
         AND a.index_name = c.index_name(+)
         AND b.table_owner = NVL (UPPER ('&&owner'), b.table_owner)
         AND b.table_name = NVL (UPPER ('&&tablename'), b.table_name)
         AND b.index_name = NVL (UPPER ('&&indexname'), b.index_name)
ORDER BY owner_name, partition_position;

undefine owner;
undefine tablename;
undefine indexname;
