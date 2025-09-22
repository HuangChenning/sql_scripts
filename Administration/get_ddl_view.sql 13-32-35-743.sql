set echo off
set verify off
set lines 20000
set long 65535 
set pages 0
col getddl for a2000
PROMPT

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | input object name                                                      |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT viewname prompt 'Enter Search View Name (i.e. v$dbfile) : '
select text from dba_views where view_name=upper('&viewname')
/
