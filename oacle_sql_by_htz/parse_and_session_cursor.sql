set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
break on sid

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display database session cursor and parse info                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT name, VALUE
  FROM v$sysstat
 WHERE name LIKE 'session cursor%' OR name LIKE 'parse count%'
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on




