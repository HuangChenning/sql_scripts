-- Purpose:     View recommendations of SQL Tuning Advisor
set echo off
SET LONG 1000000;
SET PAGESIZE 1000
SET LINESIZE 200
col recommendations for a150
SELECT DBMS_SQLTUNE.report_tuning_task('&task_name') AS recommendations FROM dual;
set echo on