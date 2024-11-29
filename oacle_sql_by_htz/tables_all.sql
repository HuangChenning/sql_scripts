set echo off
store set sqlplusset replace
set verify off
set lines 200
set pages 1000
col t_t_n for a20 heading 'Owner|Table_name'
col tablespace_name for a15 heading 'Tablespace|Name'
col partitioned for a4 heading 'Part'
col temporary for a4 heading 'Temp'
col num_rows for 99999999999999
col avg_row_len for 999 heading 'Avg|Row|Len'
col l_time for a19 heading 'last |analyzed'
col pct_free for 9999 heading 'Pct|Free'
col pct_used for 9999 heading 'Pct|Used'
col t_size for a15 heading 'Table|SIZE KB'
break on t_t_n
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one table or all tble info                             |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search Table Owner (i.e. SCOTT) : '
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|DEFAULT(ALL)) : ' default 'ALL'


SELECT   t.owner||':'||t.table_name "t_t_n",
         t.tablespace_name,
         t.partitioned,
         t.ini_trans,
         t.max_trans,
         t.temporary,
         t.num_rows,
         t.avg_row_len,
	 t.degree,
         TRUNC ( (t.blocks * p.VALUE) / 1024) || 'KB' t_size,
         TO_CHAR (t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time,
         t.pct_free,
         t.pct_used
    FROM sys.dba_tables t, sys.v$parameter p
   WHERE     t.owner = UPPER ('&owner')
         AND t.table_name =
                DECODE (UPPER ('&name'),
                        'ALL', t.table_name,
                        UPPER ('&name'))
         AND p.name = 'db_block_size'
ORDER BY t.table_name,t.tablespace_name;


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display table columns info                           |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
col column_id for 999 heading 'Col|Id'
COL column_name for a15 heading 'Column_Name'
col d_type for a15 heading 'Column|Date Type'
col nullable for a7 heading 'Is Null'        
   SELECT tb.owner || ':' || tb.table_name t_t_n,
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
   WHERE     tb.table_name =DECODE (UPPER ('&name'),
                        'ALL', tb.table_name,
                        UPPER ('&name'))
         AND tb.owner = UPPER ('&owner')
         AND tc.owner = tb.owner
         AND tc.table_name = tb.table_name
         AND tc.column_name = tb.column_name
ORDER BY column_id;


col o_t_i for a35 heading 'OWNER|TABLE_NAME|INDEX_NAME'
col tablespacename for a20 heading 'tablespace|name'
col indexname for a20
col status for a10
col index_type for a10
col num_rows for 9999999999999
col columnpost for 99
col columnname for a10
col partitioned for a5 heading PARTI
col lastanalyzed for a20 heading 'last time|analyzed'
col degree for 9 heading 'DEGREE'
col logging for a7
col blevel for 999999 heading 'INDEX|LEVEL'
col d_keys for 9999999999 heading 'Dinsinct|Keys'
col partitioned for a4 heading 'Part'

PROMPT +----------------------------------------------------------------------------+
PROMPT | DISPLAY TABLE INDEX                                                        |
PROMPT +----------------------------------------------------------------------------+
ACCEPT indexname prompt 'Enter Search Index Name (i.e. DEPT|DEFAULT(ALL)) : ' default ''

SELECT a.owner||':'||a.table_name||':'||b.index_name o_t_i,
       a.Tablespace_Name Tablespacename,
       a.status,
       a.index_type,
       a.uniqueness,
       a.pct_free,
       a.logging logging,
       a.blevel blevel,
       a.distinct_keys d_keys,
       a.leaf_blocks,
       --a.DEGREE,
       a.num_rows,
       a.partitioned,
       b.Column_Name     Columnname,
       b.Column_Position Columnpost
  FROM dba_indexes a, dba_ind_Columns b
 WHERE a.owner = upper('&owner')
   and a.Table_Name = nvl(upper('&name'), a.table_name) and a.index_name=nvl(upper('&indexname'),a.index_name)
   AND b.Index_Name = a.Index_Name
 ORDER BY o_t_i;
 
ACCEPT t_do prompt 'Do You Display Table Partition Info (i.e. N(default)|Y) : ' default 'N'
 
 
col owner for a15 heading 'TABLE|OWNER'
col name for a20 heading 'TABLE|NAME'
col COLUMN_NAME for a15  heading 'PARTITION|COLUMN NAME'
col COLUMN_POSITION  for 99 heading 'COLUMN|POSITION'
col partition_name for a20 
col HIGH_VALUE for  a15
col HIGH_VALUE_LENGTH for 99 heading 'HIGH_VALUE|LENGTH'
col tablespace_name for a15 heading 'TABLESPACE|NAME'
col num_rows for 9999999999999
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
PROMPT | display partition type,partition column ,partition count               |
PROMPT +------------------------------------------------------------------------+
PROMPT
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
   WHERE     a.name = UPPER ('&name')
         AND a.name = b.table_name
         AND a.owner = UPPER ('&owner')
         AND a.owner = b.owner
         and 1=decode('&t_do','N',0,'Y',1)
ORDER BY a.NAME, a.COLUMN_POSITION   
/
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display every partition  info                                          |
PROMPT +------------------------------------------------------------------------+
PROMPT
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
   WHERE table_name = upper('&name')  AND TABLE_OWNER = upper('&owner')  and 1=decode('&t_do','N',0,'Y',1)
ORDER BY PARTITION_POSITION    
/                                                                  





col o_t for a40 heading 'OWNER|TABLE_NAME'
col i_c for a40 heading 'Index_Name|Column_Name'


select a.owner || ':' || a.table_name o_t,
       a.index_name || ':' || c.column_name i_c,
       c.column_position,
       a.partitioning_type,
       a.partition_count,
       a.subpartitioning_type,
       a.subpartitioning_type,
       a.def_subpartition_count,
       a.locality
  from dba_part_indexes a, dba_ind_columns c
 where a.table_name = nvl(upper('&name'), a.table_name)
   and c.index_owner = a.owner
   and a.owner = nvl(upper('&owner'), a.owner)
   and c.index_name = a.index_name and c.index_name=nvl(upper('&indexname'),c.index_name)
   and 1=decode('&t_do','N',0,'Y',1)
 order by 1, 2, 3
/
@sqlplusset
 
