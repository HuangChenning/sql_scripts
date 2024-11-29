set lines 150
set echo off
col force_logging for a15
col flashback_on for a10 heading 'flashback|On'
col force_logging for a6 heading 'Force|Logging'
col database_role for a8 heading 'Database|Role'
select open_mode,log_mode,flashback_on,switchover_status,database_role,protection_mode,FORCE_LOGGING from v$database;