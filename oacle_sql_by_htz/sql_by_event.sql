set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


select c.sql_text, c.hash_value, count(*) as cun
  from v$session_wait a, v$session b, v$sqlarea c
 where a.event = '%&event%'
   and a.sid = b.sid
   and c.hash_value = b.sql_hash_value
 group by c.sql_text, c.hash_value
 order by count(*)
/
clear    breaks  
@sqlplusset

