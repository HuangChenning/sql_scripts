set echo off
set lines 2000 pages 4000 verify off heading on
@db_advisor_task_by_sqlpa.sql
exec dbms_sqlpa.DROP_ANALYSIS_TASK('&task_name');
@db_advisor_task_by_sqlpa.sql
