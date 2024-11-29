set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col owner for a15
col object_name for a15
col subojbect_name for a15
col object_type for a10
col tablespace_name for a15
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display segemnt itl contention                                         |
PROMPT +------------------------------------------------------------------------+
PROMPT
SELECT *
  FROM (  SELECT s.owner,
                 s.object_name,
                 s.subobject_name,
                 s.object_type,
                 s.tablespace_name,
                 s.VALUE,
                 s.statistic_name
            FROM v$segment_statistics s
           WHERE s.statistic_name = 'ITL waits' AND s.VALUE > 0 
        ORDER BY VALUE DESC)
 WHERE ROWNUM < 50
/
 
clear    breaks
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

