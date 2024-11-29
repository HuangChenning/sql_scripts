set echo off
set pages 40
set lines 200
col tablespace_name for a20
SELECT a.TABLESPACE_NAME,
       ROUND (a.TOTAL_BLOCKS * b.block_size / 1024 / 1024, 2) total_size,
       ROUND (a.USED_BLOCKS * b.block_size / 1024 / 1024, 2) used_size,
       ROUND (used_blocks / total_blocks, 4) * 100 user_pct,
       ROUND (a.FREE_BLOCKS * b.block_size / 1024 / 1024, 2) free_size
  FROM v$sort_segment a, dba_tablespaces b
 WHERE a.TABLESPACE_NAME = b.TABLESPACE_NAME AND b.contents = 'TEMPORARY';