set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col total_waits for 9999999 heading 'tatal_wait|number'
col time_wait for 9999999 heading 'time_wait(ms)'
col wait_class for a10
col event for a31
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY ONE SESSION EVENT STAT INFOMATION                              |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

break on sid
ACCEPT sid prompt 'Enter Search Sid (i.e. 1234) : '
  SELECT a.sid,
         substr(a.event,0,30) event,
         a.total_waits,
         a.time_waited time_wait,
         a.average_wait,
         a.wait_class
    FROM v$session_event a,
         v$session b,
         (SELECT sid, SUM (time_waited) sum_time_waited
            FROM v$session_event
           WHERE sid = decode(&sid,0,sid,&sid) group by sid) c
   WHERE a.sid = b.sid AND a.sid = c.sid AND a.time_waited > 0
ORDER BY  average_wait


/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

