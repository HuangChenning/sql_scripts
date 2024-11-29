set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col owner for a15
col table_name for a25
col partition_name for a25
col subpartition_name for a25
ACCEPT owner prompt 'Enter Search Owner (i.e. SCOTT|ALL(DEFAULT)) : ' default ''
ACCEPT table_name prompt 'Enter Search Table_Name (i.e. EMP|ALL(DEFAULT)) : ' default ''


SELECT owner,
       table_name,
       partition_name,
       subpartition_name,
       TO_CHAR (stats_update_time, 'yyyy-mm-dd hh24:mi:ss') update_time
  FROM dba_tab_stats_history
 WHERE     owner = NVL (UPPER ('&owner'), owner)
       AND table_name = NVL (UPPER ('&table_name'), table_name)
/
ACCEPT date prompt 'Enter Search Date (i.e. 2012-11-11 23:00:00) : '
execute dbms_stats.restore_table_stats (UPPER ('&owner'),UPPER ('&table_name'),to_date('&date','yyyy-mm-dd hh24:mi:ss'));
SELECT owner,
       table_name,
       partition_name,
       subpartition_name,
       TO_CHAR (stats_update_time, 'yyyy-mm-dd hh24:mi:ss') update_time
  FROM dba_tab_stats_history
 WHERE     owner = NVL (UPPER ('&owner'), owner)
       AND table_name = NVL (UPPER ('&table_name'), table_name)
/
clear    breaks  
@sqlplusset

