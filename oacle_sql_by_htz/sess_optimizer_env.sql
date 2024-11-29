set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |  displays the contents of the optimizer environment used session       |
PROMPT |  before 10g can user,9i user 10053 event                               |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sid prompt 'Enter Search Sid (i.e. 10|0(all)) : '
select sid,id,name,isdefault,value from V$SES_OPTIMIZER_ENV   where sid=decode(&sid,0,sid,&sid)
/ 
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

