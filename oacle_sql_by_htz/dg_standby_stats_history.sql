set echo off
set lines 300 pages 50
set heading on
set verify off
col name for a30
col time for a30
col TIME_COMPUTED for a20
break on inst_id
select distinct name from v$dataguard_stats;
select * from(select name,time||'('||unit||')' as "TIME",count,last_time_updated from v$standby_event_histogram where name='&eventname' order by last_time_updated desc) where rownum<nvl('&topn',30);
