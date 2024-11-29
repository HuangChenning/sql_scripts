set echo off
set verify off
set lines 200
set pages 1000
col o_t_i for a45 heading 'OWNER|TABLE_NAME|INDEX_NAME'
col tablespacename for a20 heading 'tablespace|name'
col indexname for a20
col status for a10
col index_type for a10
col num_rows for 99999999999
col columnpost for 99
col columnname for a20
col partitioned for a3 heading 'PAR|TI'
col lastanalyzed for a20 heading 'last time|analyzed'
col degree for 9 heading 'DEGREE'
col blevel  heading 'INDEX|LEVEL'
col d_keys for 9999999999 heading 'Dinsinct|Keys'
col logging for a3 heading 'LOG'
col blevel for 9 heading 'B'
col columnpost for 999 heading 'POST'
col pct_free for 999 heading 'PCT'

PROMPT +----------------------------------------------------------------------------+
PROMPT | DISPLAY INDEX INFO ABOUT TABLE:TABLE_NAME                                 |
PROMPT +----------------------------------------------------------------------------+
ACCEPT owner prompt 'Enter Search Table Owner (i.e. SCOTT|ALL(DEFAULT)) : ' default ''
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|DEFAULT(ALL)) : ' default ''
ACCEPT indexname prompt 'Enter Search Index Name (i.e. DEPT|DEFAULT(ALL)) : ' default ''

break on o_t_i

SELECT b.index_name o_t_i,
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
       b.Column_Position Columnpost,
       b.Column_Name     Columnname
  FROM dba_indexes a, dba_ind_Columns b
 WHERE a.owner = nvl(upper('&owner'),a.owner)
   and a.Table_Name = nvl(upper('&name'), a.table_name) and a.index_name=nvl(upper('&indexname'),a.index_name)
   AND b.Index_Name = a.Index_Name
   and a.owner=b.index_owner
   and a.table_owner=b.index_owner
 ORDER BY o_t_i,Columnpost;
