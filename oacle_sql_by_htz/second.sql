set echo off
set lines 300
set pages 40
set long 55555
set verify off
undefine seconds;
select TRUNC(&&seconds / 86400) || ' day(s) ' ||
       trunc((&&seconds - (TRUNC(&&seconds / 86400) * 86400)) / 3600) ||
       ' hour(s) ' ||
       trunc((&&seconds -
             ((TRUNC(&&seconds / 86400) * 86400) +
             (trunc((&&seconds - (TRUNC(&&seconds / 86400) * 86400)) / 3600) * 3600))) / 60) ||
       ' minute(s), ' ||
       (&&seconds -
        (TRUNC(&&seconds / 86400) * 86400 +
        trunc((&&seconds - (TRUNC(&&seconds / 86400) * 86400)) / 3600) * 3600 +
        trunc((&&seconds -
               ((TRUNC(&&seconds / 86400) * 86400) +
               (trunc((&&seconds - (TRUNC(&&seconds / 86400) * 86400)) / 3600) * 3600))) / 60) * 60)) ||
       ' seconds' uptime
  FROM dual;
undefine seconds;
