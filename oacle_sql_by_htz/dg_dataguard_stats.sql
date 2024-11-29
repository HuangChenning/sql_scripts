set echo off
set lines 300 pages 50
set heading on
set verify off
col name for a30
col value for a30
col TIME_COMPUTED for a20
col datum_time for a20 heading 'LAST_RECEIVED_TIME'
col inst_id for 99 heading 'ID'
break on inst_id
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
select inst_id,name,value,time_computed,DATUM_TIME,sysdate from gv$dataguard_stats order by inst_id;
