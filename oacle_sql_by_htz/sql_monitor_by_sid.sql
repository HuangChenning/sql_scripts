SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIM ON
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
col report for a300
undefine sid;
SELECT DBMS_SQLTUNE.report_sql_monitor(session_id   => nvl('&sid',
                                                           userenv('SID')),
                                       type         => 'TEXT',
                                       report_level => 'ALL') AS report
  FROM dual;
undefine sid;
