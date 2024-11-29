set echo off
set lines 170
set pages 2000
col obj# for 999999999 heading 'Object|Id'
col name for a20 heading 'User|Name'
col name for a20 heading 'Object|Name' 

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | ONLINE REBULID FAILED DISPLAY   OBJECT  INFO                           |
PROMPT +------------------------------------------------------------------------+
PROMPT
select i.obj#, i.flags, u.name, o.name, o.type#
  from sys.obj$ o, sys.user$ u, sys.ind$ idx, sys.ind_online$ i
  where  bitand(i.flags, 512) = 512 and o.obj#=idx.obj# and
          o.owner# = u.user# and idx.obj#=i.obj#
/
col createtime for a20 heading 'Create|Time'
col ddtime for a20 heading 'Last_Ddl|Time'
col owner for a20
col object_name for a20
col object_type for a10 heading 'Object|Type'
col status for a10

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | INDEX LOG TABLE NAME                                                   |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT &object_name prompt 'Enter Search Object Id (i.e. 11111) : '


SELECT owner,
         object_name,
         object_type,
         status,
         TO_CHAR (created, 'yyyy-mm-dd hh24:mi:ss') createtime,
         TO_CHAR (last_ddl_time, 'yyyy-mm-dd hh24:mi:ss') ddtime
    FROM sys.dba_objects
   WHERE object_name like '%&object_id%'
ORDER BY owner, object_type
/