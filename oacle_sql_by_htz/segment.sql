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
col h_h for a20 heading 'HEADER|FILE_BLOCK'
col bytes for 999999999 heading 'SIZE(M)'
col blocks for 999999999
col extents for 999999
BREAK ON o_s
COMPUTE SUM LABEL 'Total: ' OF bytes ON o_s
select *
  from (select owner || '.' || segment_name o_s,
               partition_name,
               segment_type,
               tablespace_name,
               header_file || '.' || header_block h_h,
               round(bytes / 1024 / 1024) bytes,
               blocks,
               extents
          from dba_segments
         where owner = nvl(upper('&owner'), owner)
           and segment_name = nvl(upper('&segment_name'), segment_name)
           and tablespace_name =
               nvl(upper('&tablespace_name'), tablespace_name)
         order by bytes desc)
 where rownum < 50;

undefine owner;
undefine segment_name;
undefine tablespace_name;