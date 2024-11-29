set pages 9999;
set lines 800;
col sess   for a25;
col status for a10;
col username for a10;
col client for a25;
col osuser for a10;
col program for a30;
col command for a10;
select a.sid||','||a.serial#||':'||b.spid as sess ,a.username,a.status,substr(a.program,1,39) program
,a.osuser||'@'||a.machine||'@'||a.process  as client,decode(a.sql_hash_value,0,a.prev_hash_value,a.sql_hash_value) sql_hash_value, DECODE (a.sql_id, '', a.prev_sql_id, a.sql_id)
       || ':'
       || sql_child_number
          AS SQLID,
to_char(a.logon_time,'mm-dd hh24:mi') as logon_time
from v$session a ,v$process b WHERE a.paddr = b.addr and  b.spid = &spid;
