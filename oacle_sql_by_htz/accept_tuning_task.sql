-- Purpose:     Accept tuning task

set verify off
exec dbms_sqltune.accept_sql_profile(task_name => '&task_name',category => '&category');
