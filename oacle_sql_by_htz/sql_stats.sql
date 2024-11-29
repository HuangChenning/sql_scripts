set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 100
col i_mem for 999999 heading 'Sharable|Mem KB'
col sorts for 99999999
col version_count for 999 heading 'Version|Count'
col loaded_versions for 999 heading 'Loaded|Versions'
col open_versions for 999 heading 'Open|Versions'
col executions for 9999999999 
col parse_calls for 99999999
col disk_reads for 999999999
col direct_writes for 999999999
col buffer_gets for 999999999999

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display sql info from v$sqlarea  about i_mem,sorts,version_count       |
PROMPT | loaded_versions,open_versions,executions,parse_calls,disk_reads        |
PROMPT | direct_writes,buffer_gets     num < 41                                 |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sqlid prompt 'Enter Search Sql_id (i.e. 12345|ALL) : '
ACCEPT sort prompt 'Enter Sort Column Name (i.e. sorts) : '
SELECT *
  FROM (  SELECT sql_id,
                 round(sharable_mem / 1024,2) i_mem,
                 sorts,
                 version_count,
                 loaded_versions,
                 OPEN_VERSIONS,
                 executions,
                 PARSE_CALLS,
                 disk_reads,
                 direct_writes,
                 buffer_gets
            FROM v$sqlarea
            where sql_id=DECODE(UPPER('&sqlid'), 'ALL', sql_id, UPPER('&sqlid'))
        ORDER BY &sort desc)
 WHERE ROWNUM < 41  ORDER BY &sort
/

SELECT 
                 round(max(sharable_mem)/1024,2) max_mem,
                 max(sorts),
                 max(version_count),
                 max(loaded_versions),
                 max(OPEN_VERSIONS),
                 max(executions),
                 max(PARSE_CALLS),
                 max(disk_reads),
                 max(direct_writes),
                 max(buffer_gets)
            FROM v$sqlarea 
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

