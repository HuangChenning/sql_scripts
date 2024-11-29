set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY INSTANCE PARSE INFOMATION                                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
select a.*, sysdate-b.startup_time days_old 
from   v$sysstat a, v$instance b 
where a.name like 'parse%'
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

