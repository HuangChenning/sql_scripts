set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col time for 99999999999999999 heading 'TIME(S)'
col pct for 9999 heading '% OF DB TIME'
col stat_name for a50
ACCEPT sid prompt 'Enter Search Sid(i.e. 199|all(default)) : ' default ''
select a.sid,stat_name,
       round(value / 1000000, 2),
       round(value / b.total * 100, 2) pct
  from v$sess_TIME_MODEL a,
       (select sid, value total
          from v$sess_time_model
         where stat_name = 'DB time'
           and sid = nvl('&sid', sid) and value!=0) b
 where stat_name not like 'background%'
   and stat_name != 'DB time'
   and a.sid = b.sid
 order by sid
/
clear    breaks  
@sqlplusset
