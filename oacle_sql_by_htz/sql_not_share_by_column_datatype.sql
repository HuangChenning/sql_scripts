set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 100

break on position

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY SQL  NOT SHAREABLE  COLUMN DATATYPE CHANGE                     |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sql_id prompt 'Enter Search Object Name (i.e. sql_id) : '

SELECT b.sql_id,
       b.position,
       b.datatype,
       b.datatype_string
  FROM (  SELECT position, COUNT (position) a_count
            FROM (  SELECT DISTINCT sql_id,
                                    position,
                                    datatype,
                                    datatype_string
                      FROM V$SQL_BIND_CAPTURE a
                     WHERE a.sql_id = '&sql_id'
                  ORDER BY position)
        GROUP BY position) a,
       (  SELECT DISTINCT sql_id,
                          position,
                          datatype,
                          datatype_string
            FROM V$SQL_BIND_CAPTURE a
           WHERE a.sql_id = '&sql_id'
        ORDER BY position) b
 WHERE a.position = b.position AND a.a_count > 1
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
undefine sql_id;
set echo on


