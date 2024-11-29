set echo off
set verify off
set lines 170
set pages 1000
col createtime for a20 heading 'Create|Time'
col ddtime for a20 heading 'Last_Ddl|Time'
col owner for a20
col object_name for a40
col object_type for a15 heading 'Object|Type'
col status for a10

undefine objectname;
SELECT owner,
         object_name,
         object_type,
         object_id,
         data_object_id,
         status,
         TO_CHAR (created, 'yyyy-mm-dd hh24:mi:ss') createtime,
         TO_CHAR (last_ddl_time, 'yyyy-mm-dd hh24:mi:ss') ddtime
    FROM sys.dba_objects
   WHERE object_name =upper('&objectname')
ORDER BY owner, object_type
/
undefine objectname;