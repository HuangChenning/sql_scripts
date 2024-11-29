set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
break on inst_id

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | displays information about global resource use for some of the system resources|
PROMPT +------------------------------------------------------------------------+ 
PROMPT
select * from gv$resource_limit
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

