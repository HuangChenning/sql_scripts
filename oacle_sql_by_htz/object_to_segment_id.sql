set echo off
set lines 170
set verify off
SELECT t.ts#, s.header_file, s.header_block
  FROM v$tablespace t, dba_segments s
 WHERE s.owner=nvl(upper('&segment_owner'),s.owner) and  s.segment_name = upper('&segment_name') AND t.name = s.tablespace_name;
set verify on
