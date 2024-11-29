set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col NO for 999
col current_scn heading 'DATABASE|CURRENT_SCN'
col tablespace_name for a15 heading 'TableSpace|Name'
col resetlogs_time for a19 heading 'Resetlogs|Time'
col checkpoint_time for a19 heading 'CheckPoint|Time'
col name for a50
col resetlogs_scn for 9999999999 heading 'Resetlogs|SCN'
col checkpoint_count for 9999999999 heading 'CheckPoint|Count'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display database current scn and datafile scn                          |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
SELECT b.file# NO,
       b.status,
       b.tablespace_name,
       a.current_scn,
       TO_CHAR (b.resetlogs_time, 'yyyy-mm-dd hh24:mi:ss') resetlogs_time,
       b.resetlogs_change# resetlogs_SCN,
       TO_CHAR (b.checkpoint_time, 'yyyy-mm-dd hh24:mi:ss') checkpoint_time,
       b.checkpoint_change# checkpoint_SCN,
       b.checkpoint_count checkpoint_count,
       b.name
  FROM v$datafile_header b, v$database a
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

