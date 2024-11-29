set echo off
set lines 200
set pages 40
col tablespace_name for a20;
col file_name for a45;
col file_type for a9
col tbstatus for a14
col fistatus for a14
col autoextensible for a5 heading "AUTOE"

  SELECT t.tablespace_name,
         'Datafile' file_type,
         t.status TBstatus,
         d.status FIstatus,
         ROUND ( (d.bytes - NVL (f.sum_bytes, 0)) / 1048576) used_mb,
         ROUND (NVL (f.sum_bytes, 0) / 1048576) free_mb,
 --        t.initial_extent,
 --        t.next_extent,
 --        t.min_extents,
 --        t.max_extents,
         t.pct_increase,
         d.file_name,
         d.file_id,
         d.autoextensible,
         NVL (d.increment_by, 0) increment_by,
         t.block_size
    FROM (  SELECT tablespace_name, file_id, SUM (bytes) sum_bytes
              FROM DBA_FREE_SPACE
          GROUP BY tablespace_name, file_id) f,
         DBA_DATA_FILES d,
         DBA_TABLESPACES t
   WHERE     t.tablespace_name = d.tablespace_name
         AND f.tablespace_name(+) = d.tablespace_name
         AND f.file_id(+) = d.file_id
GROUP BY t.tablespace_name,
         d.file_name,
         d.file_id,
   --      t.initial_extent,
   --      t.next_extent,
   --      t.min_extents,
   --      t.max_extents,
         t.pct_increase,
         t.status,
         d.bytes,
         f.sum_bytes,
         d.status,
         d.AutoExtensible,
         d.increment_by,
         t.block_size
UNION ALL
  SELECT h.tablespace_name,
         'Tempfile',
         ts.status,
         t.status,
         ROUND (SUM (NVL (p.bytes_used, 0)) / 1048576),
         ROUND (
            SUM ( (h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
            / 1048576),
  --       -1,                                                 -- initial extent
  --       -1,                                                 -- initial extent
  --       -1,                                                    -- min extents
  --       -1,                                                    -- max extents
         -1,                                                   -- pct increase
         t.file_name,
         t.file_id,
         t.autoextensible,
         NVL (t.increment_by, 0) increment_by,
         ts.block_size
    FROM sys.V_$TEMP_SPACE_HEADER h,
         sys.V_$TEMP_EXTENT_POOL p,
         sys.DBA_TEMP_FILES t,
         sys.dba_tablespaces ts
   WHERE     p.file_id(+) = h.file_id
         AND p.tablespace_name(+) = h.tablespace_name
         AND h.file_id = t.file_id
         AND h.tablespace_name = t.tablespace_name
         AND ts.tablespace_name = h.tablespace_name
GROUP BY h.tablespace_name,
         t.status,
         t.file_name,
         t.file_id,
         ts.status,
         t.autoextensible,
         t.maxblocks,
         t.maxbytes,
         t.increment_by,
         ts.block_size
ORDER BY 1, 5 DESC
/
