set echo off
set verify off
set lines 200
set pages 1000
col t_t_n for a35 heading 'Owner|Table_name'
col tablespace_name for a15 heading 'Tablespace|Name'
col partitioned for a4 heading 'Part'
col temporary for a4 heading 'Temp'
col num_rows for 999999999
col avg_row_len for 999 heading 'Avg|Row|Len'
col l_time for a11 heading 'last |analyzed'
col d_f_u for a10 heading 'DEGREE|PCT_FREE|PCT_USED'
col t_size for a10 heading 'Table|SIZE KB'
col sample_size for 999999 heading 'SAMPLE|SIZE'
col i_m for a10 heading 'TRANS|INI_MAX'
col sample_size for a5 heading 'SAMPLE|SIZE'
COL AVG_SIZE for a8 heading 'AVG|TABLE|SIZE'
col stale for a10 heading 'LOCKED|OLDED'
break on t_t_n
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|DEFAULT(ALL)) : ' default 'ALL'


SELECT t.owner || ':' || t.table_name "t_t_n",
       t.tablespace_name,
       t.partitioned,
       t.ini_trans || ':' || t.max_trans i_m,
       t.temporary,
       t.num_rows,
       t.avg_row_len,
       TRUNC(t.sample_size /
             DECODE(t.num_rows, '0', '1', NULL, '1', t. num_rows) * 100,
             2) || '%' sample_size,
       trunc(t.num_rows * t.avg_row_len / 1024 / 1024) || 'MB' avg_size,
       TRUNC((t.blocks * p.VALUE) / 1024 / 1024) || 'MB' t_size,
       TO_CHAR(t.last_analyzed, 'yy-mm-dd hh24') l_time,
       b.stattype_locked ||'.'||b.stale_stats stale,
       trim(t.degree || ':' || t.pct_free || ':' || t.pct_used) d_f_u
  FROM sys.dba_tables t, sys.v$parameter p, dba_tab_statistics b
 WHERE t.table_name =
       DECODE(UPPER('&name'), 'ALL', t.table_name, UPPER('&name'))
   AND p.name = 'db_block_size'
   and b.owner(+) = t.owner
   and t.table_name = b.table_name(+)
   and b.object_type='TABLE'
 ORDER BY t.table_name, t.tablespace_name;



