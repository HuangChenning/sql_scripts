set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col name for a25 heading 'EVENT NAME'
col t_name for a20 heading 'OWNER:OBJECT_NAME'

SELECT /*+ RULE */
 l.NAME,
 l.addr,
 tch,
 gets,
 misses,
 sleeps,
 blsiz,
 file#,
 dbablk,
 b.owner || ':' || b.object_name t_name
  FROM SYS.V$LATCH_CHILDREN L, SYS.X$BH X, dba_objects b
 WHERE x.hladdr='&addr'
   AND X.HLADDR = L.ADDR
   and x.obj = b.object_id
 ORDER BY X.TCH DESC;
 
 
clear    breaks  
@sqlplusset

