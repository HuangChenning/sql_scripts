set echo off
set lines 250 pages 1000 heading on verify off
undefine name
select name,version,version_outline,inverse from v$sql_hint where lower(name) like lower('%&name%');
undefine name