set echo off
set lines 200
set pages 50
set heading on
set verify off
col GET_STATS_HISTORY_AVAILABILITY for a30
select to_char(DBMS_STATS.GET_STATS_HISTORY_AVAILABILITY,'yyyy-mm-dd hh24:mi:ss') GET_STATS_HISTORY_AVAILABILITY,dbms_stats.get_stats_history_retention from dual;
set echo on