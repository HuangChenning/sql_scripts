set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col owner for a15
col segment_name for a20
col partition_name for a20
col segment_type for a15
col tablespace_name for a15


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY FILE ID AND BLOCKS INFOMATION                                  |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT file_id prompt 'Enter Search File Id (i.e. 123) : '
ACCEPT block prompt 'Enter Search Block (i.e. 445) : '

SELECT owner,
       segment_name,
       partition_name,
       segment_type,
       tablespace_name,
       file_id
  FROM dba_extents
 WHERE file_id = &file_id AND &block  BETWEEN block_id AND block_id + blocks - 1
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

