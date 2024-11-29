set echo off
set lines 500 pages 40
set heading on
set verify off
col process for a7 heading 'PROCESS'
col pid for 99999999 heading 'OS PID'
col status for a15 heading 'PROCESS_STATUS'
col client_process for a10 heading 'CLIENT|PROCESS'
col client_pid for a10 heading 'CLIENT|PID'
col g_t for a5 heading 'GROUP|THREAD'
col blocks for 999999999
col block# for 999999999

select a.process,
       a.pid,
       a.status,
       a.client_process,
       a.client_pid,
       a.group#||'.'||a.thread# g_t,
       a.sequence#,
       a.block#,
       a.blocks,
       a.delay_mins,
       a.known_agents,
       a.active_agents
  from v$managed_standby a;
