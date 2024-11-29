set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY SYSTEM PARSE INFOMATION                                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

select a.*, sysdate-b.startup_time days_old 
from   v$sysstat a, v$instance b 
where a.name like 'parse%'
/
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY ONE/ALL SESSION PARSE INFOMATION                               |
PROMPT +------------------------------------------------------------------------+
PROMPT


ACCEPT sid prompt 'Enter Search Sid (i.e. 123|0(all)) : '

select a.sid,
       c.username,
       b.name,
       a.value,
       round((sysdate - c.logon_time) * 24) hours_connected
  from v$sesstat a, v$statname b, v$session c
 where c.sid = a.sid
   and a.sid = decode(&sid, 0, a.sid, &sid)
   and a.statistic# = b.statistic#
   and a.value > 0
   and b.name = 'parse count (hard)'
 order by a.sid,a.value
/
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY ONE/ALL SESSION CPU USED INFOMATION                            |
PROMPT +------------------------------------------------------------------------+
PROMPT
PROMPT |--------------------------------------------------------------------------|
PROMPT |1) background elapsed time                                                |
PROMPT |      2) background cpu time                                              |
PROMPT |1) DB time                                                                |
PROMPT |    2) DB CPU                                                             |
PROMPT |    2) connection management call elapsed time                            |
PROMPT |    2) sequence load elapsed time                                         |
PROMPT |    2) sql execute elapsed time                                           |
PROMPT |    2) parse time elapsed                                                 |
PROMPT |          3) hard parse elapsed time                                      |
PROMPT |                4) hard parse (sharing criteria) elapsed time             |
PROMPT |                    5) hard parse (bind mismatch) elapsed time            |
PROMPT |          3) failed parse elapsed time                                    |
PROMPT |                4) failed parse (out of shared memory) elapsed time       |
PROMPT |    2) PL/SQL execution elapsed time                                      |
PROMPT |    2) inbound PL/SQL rpc elapsed time                                    |
PROMPT |    2) PL/SQL compilation elapsed time                                    |
PROMPT |    2) Java execution elapsed time                                        |
PROMPT |--------------------------------------------------------------------------|
Select sid, stat_id, stat_name, value From v$sess_time_model where sid=decode(&sid,0,sid,&sid) order by sid
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

