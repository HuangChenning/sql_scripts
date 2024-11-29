set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col sql_text for a101

SELECT *
  FROM (  SELECT a.sql_id,
                 ROUND (a.elapsed_time / 1000, 2) elapsed_time_ms,
                 ROUND (A.PLSQL_EXEC_TIME / 1000, 2) plsql_exec_time_ms,
                 ROUND (plsql_exec_time * 100 / a.elapsed_time, 2) pct_plsql,
                 ROUND (plsql_exec_time * 100 / SUM (plsql_exec_time) OVER (),
                        2)
                    pct_total_plsql,
                 SUBSTR (a.sql_text, 1, 100) sql_text
            FROM v$sql a
           WHERE a.plsql_exec_time > 0
        ORDER BY pct_total_plsql DESC)
 WHERE ROWNUM < 41
/
clear    breaks  
@sqlplusset

