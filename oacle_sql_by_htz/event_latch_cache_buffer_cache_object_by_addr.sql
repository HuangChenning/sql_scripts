set echo off
set lines 2000 pages 3000 verify off heading on
prompt it will run long
col file_id for 9999999
col rfile_id for 999999
col block for 9999999999
col data_object_id for 9999999
col owner_object for a30 heading 'OWNER|OBJECT_NAME|SUB_OBJECT'
col object_type for a20
col tch for 99999999
col child# for 99999999
undefine addr_list;
SELECT x.file# file_id,
       x.dbarfil rfile_id,
       x.dbablk block,
       x.obj data_object_id,
       o.owner || '.' || o.object_name || '.' || o.subobject_name owner_object,
       o.object_type,
       x.hladdr addr,
       x.tch,
       l.child#
  FROM sys.v$latch_children l, sys.x$bh x, dba_objects o
 WHERE x.hladdr in (&ADDR_LIST)
   AND x.hladdr = l.addr
   and x.obj = o.data_object_id
 ORDER BY x.tch DESC;

undefine addr_list;

