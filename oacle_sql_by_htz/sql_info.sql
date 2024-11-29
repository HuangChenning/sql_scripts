set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col sharemem for 99999999999 heading 'SHARED_MEM(M)'
col sorts for 99999
col version_count for 999999999
col executions for 99999999999999
col loads for 999999999
col parse_calls for 99999999999
col avg_disk_read for 9999999999999
col avg_buffer_get for 99999999999
col sqltext for a40

ACCEPT sqlid prompt 'Enter Search Sql Id (i.e. |all(default)) : ' default ''
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT                  SORT
PROMPT sharemem sorts version_count executions loads parse_calls avg_disk_read avg_buffer_get
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT sort prompt 'Enter Search Object Name (i.e. sharemem|version_count(default)) : ' default 'version_count'
ACCEPT num prompt 'Enter Search Object Name (i.e. 40(default )) : ' default 40
select *
  from (select substr(sql_text, 1, 39) sqltext,
               sql_id,
               round(sharable_mem / 1024 / 1024, 2) sharemem,
               sorts,
               version_count,
               executions,
               loads,
               parse_calls,
               round(disk_reads / decode(executions, 0, 1, executions), 2) avg_disk_read,
               round(buffer_gets / decode(executions, 0, 1, executions), 2) avg_buffer_get
          from v$sqlarea
         where sql_id = nvl('&sqlid', sql_id)
         order by &sort desc)
 where rownum <= &num

/
clear    breaks  
@sqlplusset

