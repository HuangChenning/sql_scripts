set echo off
set lines 250 pages 1000 verify off heading on
col o_s for a30 heading 'sid:serial:spid'
col high_scn for 999999999999
col type for a15
col status for a100
select sid || '.' || serial# || '.' || spid o_s, HIGH_SCN, type, status
  from v$logstdby_process order by high_scn;

set lines 78