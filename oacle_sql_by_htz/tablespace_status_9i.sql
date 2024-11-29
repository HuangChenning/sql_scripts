set echo off
set lines 300 pages 100 heading on verify off serveroutput on
col tablespace_name for a15 heading 'TABLESPACE|NAME'
col block_size for 99999 heading 'BLOCK|SIZE'
col i_n for a18 heading 'EXTENT|INITIAL_NEXT'
col max_size for 999999 heading 'MAX|SIZE(M)'
col status for a10 
col logging for a15
col extent_management for a10 heading 'EXTENT|MANAGE'
col segment_space_management for a10 heading 'SEGMENT|MANAGE'
col bigfile for a6
col allocation_type for a10 heading 'ALLOCATE|TYPE'
SELECT tablespace_name,
       block_size,
       initial_extent || '.' || next_extent i_n,
       status,
       logging,
       force_logging,
       extent_management,
       allocation_type,
       segment_space_management
  FROM dba_tablespaces;
