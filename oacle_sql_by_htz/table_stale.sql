set echo off
set line 200
set pages 40
set heading on
col owner_table for a35 heading 'OWNER|TABLE_NAME'
col num_rows for 99999999999 heading 'NUM_ROWS'
col block for a15 heading 'USER_BLOCK|EMPTY_BLOCK'
col chain_cnt for 999999 heading 'CHAIN_CNT'
col sample_size for a6 heading 'SAMPLE|SIZE'
col last_analyzed for a15 heading 'LAST_ANALYZED'
col statle_stats heading 'STATE|STATS'

SELECT owner || '.' || table_name owner_table,
       num_rows,
       blocks || '.' || a.empty_blocks block,
       chain_cnt,
          TRUNC (
               sample_size
             / DECODE (num_rows,  '0', '1',  NULL, '1',  num_rows)
             * 100,
             2)
       || '%'
          sample_size,
       TO_CHAR (last_analyzed, 'yyyy-mm-dd hh24') last_analyzed,
       stale_stats
  FROM dba_tab_statistics a
 WHERE     owner = NVL (UPPER ('&owner'), a.owner)
       AND table_name = NVL (UPPER ('&table_name'), a.table_name);
set lines 80
set echo on;
