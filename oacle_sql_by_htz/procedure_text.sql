set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

ACCEPT owner prompt 'Enter Search Procedure Owner (i.e. SCOTT|ALL(default)) : ' default ''
ACCEPT name prompt 'Enter Search Procedure Name (i.e. TEST_LOCK) : '
select text from dba_source where name='TEST_LOCK' and  owner=nvl(upper('&owner'),owner);
clear    breaks  
@sqlplusset