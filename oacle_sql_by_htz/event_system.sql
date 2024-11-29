set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col event for a30
col wait_class for a15
col total_waits for 99999999999 
col time_wait for 9999999 heading 'TIME (S)'
col time_100 for 9999999 heading '% Total|Ela Time'
col ave_wait for 9999999 heading 'Average|Wait'
col days_old for 99999999999999999 heading 'Startup to Now(S)'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display system event not include idle event                            |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
/* Formatted on 2012/12/24 10:01:03 (QP5 v5.215.12089.38647) */
  SELECT substr(a.event,1,40) event,
         a.total_waits,
         a.time_waited/100 time_wait,
         ROUND ( (a.time_waited / c.total_time) * 100, 2) time_100,
         ROUND (average_wait/100, 3) ave_wait,
         ROUND ((SYSDATE - b.startup_time)*24,2 )*60*60 days_old,
         a.wait_class
    FROM v$system_event a,
         v$instance b,
         (SELECT SUM (time_waited) total_time
            FROM v$system_event
           WHERE     event NOT IN
                        ('Null event',
                         'client message',
                         'KXFX: Execution Message Dequeue - Slave',
                         'PX Deq: Execution Msg',
                         'KXFQ: kxfqdeq - normal deqeue',
                         'PX Deq: Table Q Normal',
                         'Wait for credit - send blocked',
                         'PX Deq Credit: send blkd',
                         'Wait for credit - need buffer to send',
                         'PX Deq Credit: need buffer',
                         'Wait for credit - free buffer',
                         'PX Deq Credit: free buffer',
                         'parallel query dequeue wait',
                         'PX Deque wait',
                         'Parallel Query Idle Wait - Slaves',
                         'PX Idle Wait',
                         'slave wait',
                         'dispatcher timer',
                         'virtual circuit status',
                         'pipe get',
                         'rdbms ipc message',
                         'rdbms ipc reply',
                         'pmon timer',
                         'smon timer',
                         'PL/SQL lock timer',
                         'SQL*Net message from client',
                         'WMON goes to sleep',
                         'SQL*Net more data to client',
                         'SQL*Net break/reset to client',
                         'os thread startup')
                 AND event NOT LIKE 'Stream%'
                 AND wait_class <> 'Idle') c
   WHERE     average_wait > 0
         AND event NOT IN
                ('Null event',
                 'client message',
                 'KXFX: Execution Message Dequeue - Slave',
                 'PX Deq: Execution Msg',
                 'KXFQ: kxfqdeq - normal deqeue',
                 'PX Deq: Table Q Normal',
                 'Wait for credit - send blocked',
                 'PX Deq Credit: send blkd',
                 'Wait for credit - need buffer to send',
                 'PX Deq Credit: need buffer',
                 'Wait for credit - free buffer',
                 'PX Deq Credit: free buffer',
                 'parallel query dequeue wait',
                 'PX Deque wait',
                 'Parallel Query Idle Wait - Slaves',
                 'PX Idle Wait',
                 'slave wait',
                 'dispatcher timer',
                 'virtual circuit status',
                 'pipe get',
                 'rdbms ipc message',
                 'rdbms ipc reply',
                 'pmon timer',
                 'smon timer',
                 'PL/SQL lock timer',
                 'SQL*Net message from client',
                 'WMON goes to sleep',
                 'SQL*Net more data to client',
                 'SQL*Net break/reset to client',
                 'os thread startup')
         AND event NOT LIKE 'Stream%'
         AND wait_class <> 'Idle'
ORDER BY a.time_waited
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
