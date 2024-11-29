set echo off
set lines 200
set pages 40
set verify off
col owner for a15
col segment_name for a25
col partition_name for a25
col segment_type for a10
col tablespace_name for a15	
col extent_id
col file_id
col block_id
col bytes
col blocks
col relative_fno     
SELECT owner,
       segment_name,
       partition_name,
       segment_type,
       tablespace_name,
       extent_id,
       file_id,
       block_id,
       bytes,
       blocks,
       relative_fno
  FROM dba_extents
 WHERE     owner = NVL (UPPER ('&object_owner'), owner)
       AND segment_name = NVL (UPPER ('&segment_name'), segment_name)
/


owner                     clear;
segment_name              clear;
partition_name            clear;
segment_type              clear;
tablespace_name           clear;
extent_id                 clear;
file_id                   clear;
block_id                  clear;
bytes                     clear;
blocks                    clear;
relative_fno              clear;