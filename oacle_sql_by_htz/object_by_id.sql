set echo off
set verify off
set serveroutput on
set feedback off
set lines 250
set pages 1000

col createtime for a20 heading 'Create|Time'
col ddtime for a20 heading 'Last_Ddl|Time'
col owner for a20
col object_name for a40
col SUBOBJECT_NAME for a40
col object_type for a15 heading 'Object|Type'
col status for a10

ACCEPT object_id prompt 'Enter Search Object Id (i.e. 1235) : '
select owner,
       object_name,
       subobject_name,
       object_type,
       to_char(created, 'yyyy-mm-dd hh24:mi:ss') createtime,
       to_char(last_ddl_time, 'yyyy-mm-dd hh24:mi:ss') ddtime,
       status
  from dba_objects
 where object_id = '&object_id';
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

