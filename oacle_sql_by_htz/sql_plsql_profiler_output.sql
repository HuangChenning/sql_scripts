set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000

col runid for 9999
col run_owner for a15
col run_date for a18
col run_comment for a30
col run_total_time for 999999999999999
select runid,
       run_owner,
       to_char(run_date, 'yyyy-mm-dd hh24:mi') run_date,
       run_comment,
       run_total_time
  from plsql_profiler_runs
  /

col unit_name for a30 heading 'PLSQL_NAME'
col line# for 9999
col time_ms for 999999.99
col pct_time for 9999.99
col execs for 99999
col text for a101
SELECT u.unit_name, line#,
         ROUND (d.total_time / 1e9) time_ms, 
         round(d.total_time * 100 / sum(d.total_time) over(),2) pct_time, 
         d.total_occur as execs, 
         substr(ltrim(s.text),1,100) as text,
         dense_rank() over(order by d.total_time) ranking 
    FROM plsql_profiler_runs r JOIN plsql_profiler_units u USING (runid)
         JOIN plsql_profiler_data d USING (runid, unit_number)
         LEFT OUTER JOIN all_source s
         ON (    s.owner = u.unit_owner
             AND s.TYPE = u.unit_type
             AND s.NAME = u.unit_name
             AND s.line = d.line# )
   WHERE r.run_comment = '&run_comment' and d.total_time>0
/  
undefine run_comment

clear    breaks  
@sqlplusset

