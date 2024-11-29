set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col time for 99999999999999999 heading 'TIME(S)'
col pct for 9999 heading '% OF DB TIME'
col stat_name for a50

select a.inst_id,
       stat_name,
       round(value / 1000000, 2) time,
       round(value / b.total,4) * 100 pct
  from gV_$SYS_TIME_MODEL a,
       (select inst_id, value total
          from gv$sys_time_model
         where stat_name = 'DB time') b
 where a.inst_id = b.inst_id
   and stat_name not like 'background%'
   and stat_name != 'DB time'
 order by time
/
clear    breaks  
