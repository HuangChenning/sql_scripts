set echo off
set lines 300
set pages 40
set heading on
col owner_table for a30 heading 'OWNER|TABLE'
col num_rows for 999999999 heading 'NUM_ROWS'
col t_size for a8 heading 'TABLE|SIZE'
col chain_cnt for 999999 heading 'CHAIN|COUNT'
col sample_size for a5 heading 'SAMPLE|SIZE'
col last_analyzed for a13 heading 'LAST|ANALYZED'
col locked for a6 heading 'STAT|LOCKED'
col stale_stats for a6 heading 'STAT|OLDED'
SELECT t.owner || '.' || t.table_name owner_table,
       t.num_rows,
       TRUNC((t.blocks * p.VALUE) / 1024 / 1024) || 'MB' t_size,
       t.chain_cnt,
       TRUNC(t.sample_size /
             DECODE(t.num_rows, '0', '1', NULL, '1', t. num_rows) * 100,
             2) || '%' sample_size,
       TO_CHAR(t.last_analyzed, 'yyyy-mm-dd hh24') last_analyzed,
       t.STATTYPE_LOCKED locked,
       t.stale_stats
  FROM dba_tab_statistics t, sys.v$parameter p
 WHERE t.owner = NVL(UPPER('&owner'), t.owner)
   AND t.table_name = NVL(UPPER('&table_name'), t.table_name)
   AND p.name = 'db_block_size';
