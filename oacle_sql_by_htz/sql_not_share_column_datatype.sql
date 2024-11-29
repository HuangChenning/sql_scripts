set echo off
set lines 300 pages 1000 verify off heading on
col sql_id for a18
col plan_hash_value for 99999999999
col time for a32 heading 'LAST_LOAD_TIME|LAST_ACTIVE_TIME'
col c_p for a20 heading 'CLILD_NUMBER|PLAN_HASH_VALUE'
col name for a20
col a.datatype for a10
col datatype_string for a15
undefine sqlid;
SELECT a.sql_id,
       a.child_number||'.'||b.PLAN_HASH_VALUE c_p,
       b.LAST_LOAD_TIME || '--' ||
       to_char(b.LAST_ACTIVE_TIME, 'mm-dd hh24:mi') time,   
       b.is_obsolete,
       a.name,
       a.position,
       a.datatype,
       a.datatype_string
  FROM sys.V_$SQL_BIND_CAPTURE a, sys.v_$sql b
 WHERE a.sql_id = b.sql_id
   AND a.child_number = b.child_number
   AND a.child_address = b.child_address
   AND a.sql_id = '&sqlid'
 ORDER BY c_p
/
undefine sqlid;
