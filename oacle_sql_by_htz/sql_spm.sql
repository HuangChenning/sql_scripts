set echo off
set lines 300
set pages 60
set heading on
col status for a20 heading 'ENABLE:ACCTPE|FIXED|REPRODUCED'
col parsing_schema_name for a15 heading 'PARSING|SCHEMA'
col c_l_l for a17 heading 'CREATED|MODIFIED'
col sql_text for a50 heading 'SQL_TEXT'
col cost for 9999999
SELECT sql_handle,
       plan_name,
       origin,
          a.enabled
       || '.'
       || a.accepted
       || '.'
       || a.fixed
       || '.'
       || '.'
       || A.REPRODUCED
          status,
       a.optimizer_cost cost,
       parsing_schema_name,
          TO_CHAR (created, 'mm-dd hh24')
       || '.'
       || TO_CHAR (last_modified, 'mm-dd hh24')
          c_l_l,
       sql_text
  FROM dba_sql_plan_baselines a;
set echo on;
