set echo off
set verify off
set serveroutput on
set feedback on
set lines 300
set heading on
set pages 40
undefine owner;
undefine segment_name;
undefine tablespace_name;
col o_s for a30 heading 'OWNER:SEGMENT_NAME'
col partition_name for a20
col segment_type for a15
col tablespace_name for a20
col b_b for a25 heading 'BLOCK|BEGIN_END'
col file_id for 9999 heading 'FILE|ID'
col relative_fno for 9999 heading 'FNO'
col bytes for 9999999 heading 'BYTES(KB)'
col blocks for 99999999
BREAK ON o_s
COMPUTE SUM LABEL 'Total: ' OF bytes ON o_s
COMPUTE SUM LABEL 'Total: ' OF blocks ON o_s
undefine owner;
undefine segment_name;
/* Formatted on 2014/8/14 15:29:10 (QP5 v5.240.12305.39446) */
  SELECT owner || '.' || segment_name o_s,
         partition_name,
         segment_type,
         tablespace_name,
         file_id,
         relative_fno,
         extent_id,
         block_id || '~' || (block_id + blocks - 1) b_b,
         blocks,
         SUM (blocks) OVER (PARTITION BY relative_fno ORDER BY extent_id)
            sum_blocks,
         ROUND (bytes / 1024) bytes,
         (SUM (bytes) OVER (PARTITION BY relative_fno ORDER BY extent_id))
            sum_bytes
    FROM dba_extents
   WHERE     owner = NVL (UPPER ('&owner'), owner)
         AND segment_name = NVL (UPPER ('&segment_name'), segment_name)
         AND tablespace_name =
                NVL (UPPER ('&tablespace_name'), tablespace_name)
ORDER BY extent_id
/
undefine owner;
undefine segment_name;
