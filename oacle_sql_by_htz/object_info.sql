set echo off
set verify off
set lines 170
set pages 10
col owner for a20
col object_type for a15
col createtime for a20 heading 'Create|Time'
col ddtime for a20 heading 'Last_Ddl|Time'

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one object type,owner,time,status                              |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT objectname prompt 'Enter Search Object Name (i.e. DEPT) : '

select owner,object_type,to_char(created,'yyyy-mm-dd hh24:mi:ss') createtime,to_char(last_ddl_time,'yyyy-mm-dd hh24:mi:ss') ddltime,status from dba_objects where object_name=upper('&objectname')
/
