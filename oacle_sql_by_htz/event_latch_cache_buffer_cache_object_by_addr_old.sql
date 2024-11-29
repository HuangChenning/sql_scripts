set lines 170
prompt it will run long
column segment_name format a35
  SELECT /*+ RULE */
        e.owner || '.' || e.segment_name segment_name,
         e.extent_id extent#,
         x.dbablk - e.block_id + 1 block#,
         x.tch,
         l.child#
    FROM sys.v$latch_children l, sys.x$bh x, sys.dba_extents e
   WHERE     x.hladdr = '&ADDR'
         AND e.file_id = x.file#
         AND x.hladdr = l.addr
         AND x.dbablk BETWEEN e.block_id AND e.block_id + e.blocks - 1
ORDER BY x.tch DESC;
