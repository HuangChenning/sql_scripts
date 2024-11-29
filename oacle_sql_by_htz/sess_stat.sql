set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
break on sid
col A.VALUE for 999999999999999999
col name for a40

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one session session cursor and parse info                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
select * from v$statname;
ACCEPT name prompt 'Enter Search Statistics Name  (i.e.session cursor)) : ' default 'parse count'
ACCEPT sid prompt 'Enter Search Session Sid (i.e. 123|0(ALL)) : ' default 0

SELECT a.sid,b.name, A.VALUE
  FROM v$sesstat a, v$statname b
 WHERE     A.STATISTIC# = B.STATISTIC#
       AND b.name LIKE '%&name%'
        and a.sid=decode(&sid,0,a.sid,&sid)
         order by a.sid
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on




