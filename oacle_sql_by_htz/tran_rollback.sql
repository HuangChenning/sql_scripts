 alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
col cputime for 999999999999 heading 'USED_TIME(S)'
select usn,
       state,
       pid,
       cputime,
       undoblockstotal "Total",
       undoblocksdone "Done",
       undoblockstotal - undoblocksdone "ToDo",
       decode(cputime,
              0,
              'unknown',
              sysdate + (((undoblockstotal - undoblocksdone) /
              (undoblocksdone / cputime)) / 86400)) "Estimated time to complete"
  from v$fast_start_transactions;

