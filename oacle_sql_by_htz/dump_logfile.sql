set lines 170
set pages 50
col member for a70
SELECT a.group#,
       a.thread#,
       a.sequence#,
       a.status,
       a.first_change#,
       b.MEMBER
  FROM v$log a, v$logfile b
 WHERE a.group# = b.group#;
alter system dump logfile '&logfilename';
oradebug setmypid
oradebug tracefile_name
