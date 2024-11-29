set echo off
set heading on set lines 3000 pages 40 verify off
col createtime for a20 heading 'Create|Time'
col ddtime for a20 heading 'Last_Ddl|Time'
col owner for a20
col object_name for a40
col object_type for a15 heading 'Object|Type'
col status for a10
undefine objectname;
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one object type,owner,time,status                              |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT objectname prompt 'Enter Search Object Name (i.e. DEPT) : '

SELECT owner,
         object_name,
         object_type,
         status,
         TO_CHAR (created, 'yyyy-mm-dd hh24:mi:ss') createtime,
         TO_CHAR (last_ddl_time, 'yyyy-mm-dd hh24:mi:ss') ddtime
    FROM sys.dba_objects
   WHERE object_name=UPPER ('&objectname')
ORDER BY owner, object_type
/
undefine object_name