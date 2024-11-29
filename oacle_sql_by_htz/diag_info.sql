set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 20
col name for a30
col value for a100
break on inst_id

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display diag dir info                                                  |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
select * from v$diag_info
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

