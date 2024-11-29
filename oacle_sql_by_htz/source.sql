set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

col text for a100
ACCEPT owner prompt 'Enter Search Owner (i.e. SCOTT|default(all)) : ' default ''
ACCEPT objectname prompt 'Enter Search Object Name (i.e. DEPT|default(all)) : ' default ''

select text from dba_source where owner=nvl(upper('&owner'),owner) and name=nvl(upper('&objectname'),name)
/
clear    breaks  
