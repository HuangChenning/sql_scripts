set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col sql for a80

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display sql no bind                                                    |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT count prompt 'Enter Search Count (i.e. 100) : '

select substr(sql_text, 1, 80) "sql", count(*), sum(executions) "totexecs"
  from v$sqlarea
 group by substr(sql_text, 1, 80)
having count(*) > &count
 order by 2;
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

