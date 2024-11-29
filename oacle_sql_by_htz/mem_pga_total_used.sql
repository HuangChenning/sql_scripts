set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display pga total used infomation from v$sysstat                       |
PROMPT +------------------------------------------------------------------------+
PROMPT
show parameter pga
select name,round(value/1024/1024,2)||'M' used from v$sysstat where name like '%pga%';

ACCEPT da PROMPT 'DO YOU WANT DISPLAY PGA TOTAL USED FROM AWR ,DO ENTER ,NOT DO CTRL + C'
ACCEPT date prompt 'Enter Search Begin Date (i.e. 2012-01-01) : '

select to_char(b.end_interval_time, 'yyyy-mm-dd hh24:mi:ss') create_time,
       a.stat_name,
       round(a.value / 1024 / 1024, 2) || 'M' used
  from dba_hist_sysstat a, dba_hist_snapshot b
 where a.stat_name like '%pga%'
   and b.instance_number = (select c.INSTANCE_NUMBER from v$instance c)
   and b.instance_number = a.instance_number
   and a.snap_id = b.snap_id
   and b.end_interval_time > to_date('&date', 'yyyy-mm-dd hh24:mi:ss')
 order by 1
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

