set echo off
set lines 2000 pages 5000 verify off heading on
undefine system_or_session;
undefine level;
undefine sqllist;
alter &&system_or_session set events
    'sql_trace[SQL: &&sqllist ] wait=true, bind=true,plan_stat=first_execution,level &level';
oradebug setmypid
oradebug eventdump &&system_or_session;

pause Press return to stop tracing

alter &&system_or_session set events 'sql_trace[SQL: &&sqllist ] off';
oradebug eventdump &&system_or_session;
undefine system_or_session;
undefine level;
undefine sqllist;