set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col name for a29
break on name

select name, stage, hint from dba_outline_hints where name = upper('&name');   
clear    breaks  
@sqlplusset

