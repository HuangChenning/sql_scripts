set lines 32767
set echo off
set pages 0
set long 10000000
col ddl for a32767
SELECT DBMS_METADATA.get_ddl('CONSTRAINT', oc.name, ou.name) || ';' as ddl
  FROM sys.con$  oc,
       sys.con$  rc,
       sys.user$ ou,
       sys.user$ ru,
       sys.obj$  ro,
       sys.obj$  o,
       sys.cdef$ c,
       sys.obj$  oi,
       sys.user$ ui
 WHERE oc.owner# = ou.user#
   and ou.name = upper('&owner')
   AND oc.con# = c.con#
   AND c.obj# = o.obj#
   AND c.type# != 8
   AND c.type# != 12
   AND c.type# in (1, 2, 3)
   AND c.rcon# = rc.con#(+)
   AND c.enabled = oi.obj#(+)
   AND oi.owner# = ui.user#(+)
   AND rc.owner# = ru.user#(+)
   AND c.robj# = ro.obj#(+);
set lines 80;
undefine owner;