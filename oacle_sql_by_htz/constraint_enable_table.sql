col name	format a22 heading 'Name'
set verify off
set echo off
set lines 170
set pages 10000
ACCEPT owner prompt 'Enter table owner (i.e. SCOTT) : '
ACCEPT tablename prompt 'Enter tables name  (i.e. DEPT) : '

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display table's constraints info                                       |
PROMPT +------------------------------------------------------------------------+ 
 
 
select 'alter table &owner'||'.'||'&tablename enable constraint '||constraint_name||' cascade;'  sql
from dba_constraints 
where owner = upper('&owner') and 
table_name = upper('&tablename') and
status='DISABLED'
/ 
 
