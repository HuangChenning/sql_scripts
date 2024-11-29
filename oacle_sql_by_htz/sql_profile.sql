set echo off
set echo off
set verify off
set serveroutput on
set feedback on
set lines 200
set pages 1000
col category for a25
col sql_text for a51 trunc
col type for a10
col s_t for a20 heading 'STATUS|TYPE'
col c_date for a11 heading 'CREATE TIME|LAST_MODIFIED'
col task_exec_name for a15
col force_matching for a8 heading 'FORCE|MATCHING'
col name for a40
ACCEPT name prompt 'Enter Search Profile Name (i.e. %system%) : ' default ''
  SELECT a.name,
         a.category,
         a.status || '.' || a.TYPE s_t,
            TO_CHAR (a.created, 'mm-dd')
         || '.'
         || TO_CHAR (last_modified, 'mm-dd')
            c_date,
         a.force_matching,
         SUBSTR (a.sql_text, 1, 50) sql_text
    FROM dba_sql_profiles a
   WHERE     a.sql_text LIKE NVL ('%&sql_text%', a.sql_text)
         AND a.name LIKE NVL (UPPER ('&name'), name)
ORDER BY last_modified
/

clear    breaks  
set feedback on
set echo on
