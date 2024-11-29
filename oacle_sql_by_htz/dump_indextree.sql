set echo off
set lines 200
set pages 40
set heading on
set verify off
col object_id new_v objectid noprint;
select object_id from dba_objects where owner=upper('&owner') and object_name=upper('&object_name');
alter session set events 'immediate trace name treedump level &objectid';
@sess_current_trace_file_location.sql
undefine owner;
undefine object_name;
set echo on
