SET ECHO OFF
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24';
SET LINES 2000 PAGES 10000 VERIFY OFF HEADING ON
COL owner FOR a20
COL tablespace_name FOR a40
COL partition_name FOR a30
COL tablespace_name FOR a20
COL num_rows FOR 9999999999 HEADING 'NUM_ROWS(K)'
COL avg_row_len FOR 9999999 HEADING 'AVG|ROW_LEN'
COL table_SIZE FOR 99999999 HEADING 'TABLE|SIZE(M)'
COL avg_size FOR 99999999 HEADING 'AVG|SIZE(M)'
COL free_space FOR 9999 HEADING 'FREE|SPACE(%)'
COL bytes FOR 99999999 HEADING 'SEGMENT_SIZE|BYTES(M)'
COL last_analyzed FOR a15

  SELECT t.owner,
         t.table_name,
         t.partition_name,
         -- t.tablespace_name,
         TRUNC (t.num_rows / 1000) num_rows,
         t.avg_row_len,
         TRUNC (t.blocks * tp.block_size / 1024 / 1024) table_size,
         TRUNC (t.avg_size / 1024 / 1024) avg_size,
         TRUNC (
              (  1
               -   t.avg_size
                 / DECODE ( (t.blocks * tp.block_size),
                           0, 1,
                           (t.blocks * tp.block_size)))
            * 100,
            2)
            free_space,
         TRUNC (t.bytes / 1024 / 1024) bytes,
         t.last_analyzed
    FROM (SELECT a.owner,
                 a.table_name,
                 '' partition_name,
                 a.tablespace_name,
                 a.num_rows,
                 a.blocks,
                 a.avg_row_len,
                 a.num_rows * a.avg_row_len avg_size,
                 b.bytes,
                 a.last_analyzed
            FROM dba_tables a, dba_segments b
           WHERE     a.owner = b.owner
                 AND a.table_name = b.segment_name
                 AND a.tablespace_name NOT IN ('SYSTEM', 'SYSAUX')
                 AND a.partitioned = 'NO'
          UNION ALL
          SELECT a.table_owner,
                 a.table_name,
                 a.partition_name,
                 a.tablespace_name,
                 a.num_rows,
                 a.blocks,
                 a.avg_row_len,
                 a.num_rows * a.avg_row_len avg_size,
                 b.bytes,
                 a.last_analyzed
            FROM dba_tab_partitions a, dba_segments b
           WHERE     a.table_owner = b.owner
                 AND a.table_name = b.segment_name
                 AND a.partition_name = b.partition_name
                 AND a.tablespace_name NOT IN ('SYSTEM', 'SYSAUX')
          UNION ALL
          SELECT a.table_owner,
                 a.table_name,
                 a.partition_name,
                 a.tablespace_name,
                 a.num_rows,
                 a.blocks,
                 a.avg_row_len,
                 a.num_rows * a.avg_row_len avg_size,
                 b.bytes,
                 a.last_analyzed
            FROM dba_tab_subpartitions a, dba_segments b
           WHERE     a.table_owner = b.owner
                 AND a.table_name = b.segment_name
                 AND a.subpartition_name = b.partition_name
                 AND a.tablespace_name NOT IN ('SYSTEM', 'SYSAUX')) t,
         dba_tablespaces tp
   WHERE     t.tablespace_name = tp.tablespace_name
         AND t.bytes > (20 * 1024 * 1024)
         AND (   TRUNC (
                      (  1
                       -   t.avg_size
                         / DECODE ( (t.blocks * tp.block_size),
                                   0, 1,
                                   (t.blocks * tp.block_size)))
                    * 100,
                    2) > 20
              OR (t.last_analyzed IS NULL))
ORDER BY free_space
/