-------------------------------------------------------------------------------------------------
--  Script : redo_size_log_history.sql
-------------------------------------------------------------------------------------------------
-- This script will calculate the daily redo size using v$log_history if the database in
--   log_history mode.
-- Restrictions :
--
--  Author : Riyaj Shamsudeen
--  No implied or explicit warranty !
-------------------------------------------------------------------------------------------------
PROMPT
PROMPT
PROMPT  redo_size_log_history.sql v1.20 by Riyaj Shamsudeen @orainternals.com
PROMPT
PROMPT   To generate Report about Redo rate from v$archived_log view
PROMPT     Note that I am hardcoding dest_id=1, which should work for most databases.
PROMPT      If you don't get any rows, check if the dest_id is somehow different
PROMPT
set pages 40
set lines 160
set serveroutput on size 1000000
alter session set nls_date_format='DD-MON-YYYY';
column redo_per_sec_inst head "redo/sec (KB)|inst" format 999,999,999.99
column redo_per_sec_db head "redo/sec (KB)|db" format 999,999,999.99
column redo_size_inst head "redo_size(MB)|inst" format 999,999,999,999.99
column redo_size_db head "redo_size(MB)|db" format 999,999,999,999.99
set verify off
accept history_days prompt 'Enter past number of days to search for (Null=7):'
select distinct
    thread#,
    trunc(first_time) dt,
    trunc((sum(sz) over(partition by trunc(first_time), thread#))/1024/24/60/60,2) redo_per_sec_inst,
    trunc((sum(sz) over(partition by trunc(first_time)))/1024/24/60/60,2) redo_per_sec_db,
    trunc((sum(sz) over(partition by trunc(first_time),thread#))/1024/1024,2) redo_size_inst,
    trunc((sum(sz) over(partition by trunc(first_time)))/1024/1024,2) redo_size_db
from (
select thread#, first_time, first_change#,  next_change#, sequence#
       ,blocks*block_size sz
from v$archived_log
where first_time > sysdate-nvl('&&history_days',7)
and dest_id=1
order by first_time
)
order by   trunc(first_time) , thread#
/

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

