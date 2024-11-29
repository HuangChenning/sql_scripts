set echo off
set lines 200 heading on verify off pages 400
alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
col cputime for 999999999999 heading 'USED_TIME(S)'
col spid for 99999999 heading 'OS_PID'
select a.usn,
       a.state,
       a.pid,
       b.spid,
       a.cputime,
       a.undoblockstotal "Total",
       a.undoblocksdone "Done",
       a.undoblockstotal - undoblocksdone "ToDo",
       decode(a.cputime,
              0,
              'unknown',
              sysdate + (((a.undoblockstotal - a.undoblocksdone) /
              (a.undoblocksdone / cputime)) / 86400)) "Estimated time to complete"
  from v$fast_start_transactions a,v$process b where a.pid=b.pid(+);


select a.STATE ,a.UNDOBLOCKSDONE,a.pid,b.spid,a.XID  from V$FAST_START_SERVERS a ,v$process b where a.pid=b.pid(+);
