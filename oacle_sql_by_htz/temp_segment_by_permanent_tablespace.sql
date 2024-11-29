set lines 200
set pages 40
col tablespace_name for a20
col owner for a20
col segment_name for a30
SELECT tablespace_name,
         owner,
         segment_name,
         ROUND (SUM (bytes) / 1024 / 1024, 2) || 'M' AS "SIZE"
    FROM dba_segments
   WHERE segment_type = 'TEMPORARY'
GROUP BY tablespace_name, owner, segment_name
/