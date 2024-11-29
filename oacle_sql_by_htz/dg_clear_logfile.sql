set echo off
set lines 300
set pages 50
set heading on
set verify off
select 'alter database clear logfile group '||group#||';' from v$log
union all
select 'alter database clear logfile group '||group#||';' from v$standby_log;

