set echo off;
set lines 200;
set pages 40;
set verify off;
set serveroutput on;

/* Formatted on 2014/4/20 9:50:59 (QP5 v5.240.12305.39446) */
DECLARE
   i_segment_owner               VARCHAR2 (100);
   i_segment_name                VARCHAR2 (100);
   i_segment_type                VARCHAR2 (30);
   i_partition_name              VARCHAR2 (50);
   p_total_blocks                NUMBER;
   p_total_bytes                 NUMBER;
   p_unused_blocks               NUMBER;
   p_unused_bytes                NUMBER;
   p_last_used_extent_file_id    NUMBER;
   p_last_used_extent_block_id   NUMBER;
   p_last_used_block             NUMBER;
BEGIN
   i_segment_owner := UPPER ('&segment_owner');
   i_segment_name := UPPER ('&object_name');
   i_segment_type := UPPER ('&segment_type');
   i_partition_name := UPPER (NVL ('&partition_name', ''));

   DBMS_SPACE.UNUSED_SPACE (
      segment_owner               => i_segment_owner,
      segment_name                => i_segment_name,
      segment_type                => i_segment_type,
      total_blocks                => p_total_blocks,
      total_bytes                 => p_total_bytes,
      unused_blocks               => p_unused_blocks,
      unused_bytes                => p_unused_bytes,
      last_used_extent_file_id    => p_last_used_extent_file_id,
      last_used_extent_block_id   => p_last_used_extent_block_id,
      last_used_block             => p_last_used_block,
      partition_name              => i_partition_name);
   DBMS_OUTPUT.put_line (
      '....................................................');
   DBMS_OUTPUT.put_line ('total_blocks              : ' || p_total_blocks);
   DBMS_OUTPUT.put_line ('total_bytes               : ' || p_total_bytes);
   DBMS_OUTPUT.put_line ('unused_blocks             : ' || p_unused_blocks);
   DBMS_OUTPUT.put_line ('unused_bytes              : ' || p_unused_bytes);
   DBMS_OUTPUT.put_line (
      'last_used_extent_file_id  : ' || p_last_used_extent_file_id);
   DBMS_OUTPUT.put_line (
      'last_used_extent_block_id : ' || p_last_used_extent_block_id);
   DBMS_OUTPUT.put_line ('last_used_block           : ' || p_last_used_block);
   DBMS_OUTPUT.put_line (
      '....................................................');
END;
/
undefine segment_owner;
undefine object_name;
undefine segment_type;
undefine partition_name;
