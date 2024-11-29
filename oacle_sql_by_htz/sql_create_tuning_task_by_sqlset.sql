set lines 200
@sql_sqlset
DECLARE
  l_sql_tune_task  VARCHAR2(100);
BEGIN
  l_sql_tune_task := DBMS_SQLTUNE.create_tuning_task (sqlset_name=>'&sqlset_name');
  DBMS_OUTPUT.put_line('l_sql_tune_task: ' || l_sql_tune_task);
  DBMS_SQLTUNE.execute_tuning_task(task_name => l_sql_tune_task);
  DBMS_OUTPUT.put_line('l_sql_tune_task: '||l_sql_tune_task||' is executing');
END;
/
@sql_sqlset_running.sql
