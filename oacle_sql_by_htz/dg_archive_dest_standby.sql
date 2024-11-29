set echo off
set heading on
set pages 50
set lines 300
col dest_id for 99 heading 'ID'
col status for a10
col archiver for a9
col scheduler for a12
col destination for a15
col log_sequence for 99999999 heading 'log|sequence'
col applied_scn for 9999999999999 heading 'HAVED_APPLIED|SCN_STANDBY'
col error for a60
select dest_id,
       status,
       archiver,
       schedule,
       destination,
       log_sequence,
       applied_scn,
       error
  from v$archive_dest
 WHERE TARGET = 'STANDBY';
