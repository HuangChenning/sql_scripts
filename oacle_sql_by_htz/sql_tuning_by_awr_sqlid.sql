set lines 200
ACCEPT sql_id prompt 'Enter Tuning Sql_id  (i.e. dddddd) : '


DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_id      => '&sql_id',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => 'sql_tuning_task',
                          description => 'Tuning task.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/
PROMPT CREATE TUNGING TASH FINISH 
PROMPT EXECTUE TUNING TASH 
EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => 'sql_tuning_task');
PROMPT EXECTUE TUNING TASH FINISH
SET LONG 10000;
SET PAGESIZE 1000
SET LINESIZE 200
prompt "report_tuning_task"
SELECT DBMS_SQLTUNE.report_tuning_task('sql_tuning_task') AS recommendations FROM dual;
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | dou you want to drop tuning task                |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT b_enter prompt 'dou you want to drop tuning task :DO ENTER NOT DO :CTRL+C: '
exec DBMS_SQLTUNE.drop_tuning_task (task_name => 'sql_tuning_task');
PROMPT DROP TUNING TASH FINISH

