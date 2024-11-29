set echo off
set verify off
set lines 170
set pages 2000
col obj# for 999999999 heading 'Object|Id'
col uname for a20 heading 'User|Name'
col name for a20 heading 'Object|Name' 

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | ONLINE REBULID FAILED DISPLAY   OBJECT  INFO                           |
PROMPT +------------------------------------------------------------------------+
PROMPT
select i.obj#, i.flags, u.name uname, o.name, o.type#
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


ACCEPT object_id prompt 'Enter Search Object Id (i.e. 11111) : '

DECLARE
RetVal BOOLEAN;
OBJECT_ID BINARY_INTEGER;
WAIT_FOR_LOCK BINARY_INTEGER;
BEGIN
OBJECT_ID := &object_id;
WAIT_FOR_LOCK := NULL;
RetVal := SYS.DBMS_REPAIR.ONLINE_INDEX_CLEAN ();
COMMIT;
END;
/

set echo off
set verify off
set lines 170
set pages 2000
col obj# for 999999999 heading 'Object|Id'
col uname for a20 heading 'User|Name'
col name for a20 heading 'Object|Name'

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | ONLINE REBULID FAILED DISPLAY   OBJECT  INFO                           |
PROMPT +------------------------------------------------------------------------+
PROMPT
select i.obj#, i.flags, u.name uname, o.name, o.type#
  from sys.obj$ o, sys.user$ u, sys.ind$ idx, sys.ind_online$ i
  where  bitand(i.flags, 512) = 512 and o.obj#=idx.obj# and
          o.owner# = u.user# and idx.obj#=i.obj#
/