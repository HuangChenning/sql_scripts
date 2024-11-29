set echo off
store set sqlplusset replace
set verify off
set lines 170
set pages 1000
select tablespace_name,contents, ts#
  from dba_tablespaces a, v$tablespace b
   where a.tablespace_name = b.NAME;
ACCEPT ts prompt 'Enter Search Temp Tablespace (TS#+1) (i.e. 4) : '
alter session set events 'immediate trace name DROP_SEGMENTS level &ts';
clear    breaks  
@sqlplusset

