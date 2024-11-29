set echo off
set heading on
set verify off
set lines 200
set pages 1000
col o_t_i for a35 heading 'OWNER:INDEX_NAME'
col tablespacename for a20 heading 'tablespace|name'
col indexname for a20
col status for a10
col index_type for a10
col num_rows for 9999999999999
col partitioned for a5 heading PARTI
col lastanalyzed for a20 heading 'last time|analyzed'
col degree for a7 heading 'DEGREE'
col logging for a7
col blevel  heading 'INDEX|LEVEL'
col d_keys for 9999999999 heading 'Dinsinct|Keys'
col pct_free for 9999 heading 'PCT|FREE'
col blevel for 99999 heading 'LEVEL'
col post_name for a15 heading 'COLUMN|POST:NAME'
col logging for a3 heading 'LOG'
break on o_t_i


SELECT a.owner||':'||b.index_name o_t_i,
       a.Tablespace_Name Tablespacename,
       decode(a.status,'N/A','PART',A.STATUS) status,
       a.index_type,
       a.uniqueness,
       a.pct_free,
       a.logging logging,
       a.blevel blevel,
       a.distinct_keys d_keys,
       a.leaf_blocks,
       a.degree,
       a.num_rows,
       a.partitioned,
       c.locality,
       b.Column_Position||':'||
       b.Column_Name     post_name
  FROM dba_indexes a, dba_ind_Columns b,dba_part_indexes c
 WHERE 
    a.index_name=upper('&&indexname')
   AND b.Index_Name = a.Index_Name
   AND a.owner=b.index_owner
   and a.table_owner=b.table_owner
   and a.owner=c.owner(+)
   and a.index_name = c.index_name(+)
 ORDER BY o_t_i;

col partition_name for a20 heading 'PARTITION|NAME'
col partition_position for 99 heading 'PART|ID'
col subpartition_count for 999 heading 'SUBPART|COUNT'
with t as
 (SELECT c.owner, c.table_name, d.index_name
            FROM dba_indexes c, dba_ind_Columns d
           WHERE 
              c.index_name = upper('&&indexname')
             AND d.Index_Name = c.Index_Name
               AND c.owner=d.index_owner
               and c.table_owner=d.table_owner
             and c.partitioned = 'YES')
SELECT a.index_owner || ':'|| b.index_name o_t_i,
       a.partition_name,
       a.partition_position,
       a.subpartition_count,
       a.Tablespace_Name Tablespacename,
       a.status,
       a.pct_free,
       a.blevel,
       a.logging logging,
       a.distinct_keys d_keys,
       a.leaf_blocks,
       a.num_rows,
       b.Column_Position||':'||
       b.Column_Name post_name
  FROM dba_ind_partitions a, dba_ind_Columns b, t
 WHERE a.index_owner = t.owner
   and a.index_name = t.index_name
   AND b.Index_Name = a.Index_Name
 ORDER BY o_t_i, partition_position desc;
undefine indexname;
