set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col category for a25
col sql_text for a51 trunc
col type for a10
col s_t for a20 heading 'STATUS|TYPE'
col c_date for a11 heading 'CREATE TIME|LAST_MODIFIED'
col task_exec_name for a15
col force_matching for a8 heading 'FORCE|MATCHING'
undefine profilename
undefine status

ACCEPT name prompt 'Enter Search Profile Name (i.e. %system%) : ' default ''
 SELECT a.name,
         a.category,
         a.status||'.'||a.TYPE s_t,
            TO_CHAR (a.created, 'mm-dd')
         || '.'
         || TO_CHAR (last_modified, 'mm-dd')
            c_date,
         a.force_matching,
         a.task_exec_name,
         SUBSTR (a.sql_text, 1, 50) sql_text
    FROM dba_sql_profiles a
   WHERE   a.name LIKE NVL ('&name', name)
ORDER BY last_modified
/

ACCEPT profilename prompt 'Enter Search Profile Name (i.e. SYS_SQLPROF_013dab1e20200000) : '
ACCEPT status prompt 'Enter Search Profile Status (i.e. ENABLED|DISABLED) : '
BEGIN
   DBMS_SQLTUNE.ALTER_SQL_PROFILE (name             => '&profilename',
                                   attribute_name   => 'STATUS',
                                   VALUE            => UPPER ('&status'));
END;
/

SELECT a.name,
         a.category,
         a.status||'.'||a.TYPE s_t,
            TO_CHAR (a.created, 'mm-dd')
         || '.'
         || TO_CHAR (last_modified, 'mm-dd')
            c_date,
         a.force_matching,
         a.task_exec_name,
         SUBSTR (a.sql_text, 1, 50) sql_text
    FROM dba_sql_profiles a
   WHERE   a.name='&profilename'
ORDER BY last_modified
/
clear    breaks  

undefine profilename
undefine status
