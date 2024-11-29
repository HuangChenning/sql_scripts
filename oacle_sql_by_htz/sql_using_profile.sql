-- Purpose:     (v$sql where sql_profile is not null)
set echo off
store set sqlplusset replace
set verify off
set pagesize 999
set lines 200
col username format a13
col prog format a22
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col avg_pio format 9,999,999.99
col avg_lio format 999,999,999
col etime format 9,999,999.99
col sql_profile for a30
col sql_text for a51
 SELECT sql_id,
         child_number,
         plan_hash_value plan_hash,
         sql_profile,
         executions execs,
           (elapsed_time / 1000000)
         / DECODE (NVL (executions, 0), 0, 1, executions)
            avg_etime,
         buffer_gets / DECODE (NVL (executions, 0), 0, 1, executions) avg_lio,
         sql_id,
         SUBSTR (sql_text, 1, 50) sql_text
    FROM v$sql s
   WHERE     sql_text LIKE '%&sql_text%'
         AND sql_text NOT LIKE '%from v$sql where sql_text like nvl(%'
         AND sql_id LIKE NVL ('&sql_id', sql_id)
         AND sql_profile LIKE NVL ('&sql_profile_name', sql_profile)
         AND sql_profile IS NOT NULL
ORDER BY 1, 2, 3
/
@sqlplusset

