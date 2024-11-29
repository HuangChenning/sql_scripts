

SET NUMWIDTH 10
SET TAB OFF


set long 1000000;
set longchunksize 1000;
set feedback off;
set veri off;


prompt
prompt Specify the Sql id
prompt ~~~~~~~~~~~~~~~~~~
column sqlid new_value sqlid;
set heading off;
select 'Sql Id specified: &&sqlid' from dual;
set heading on;

prompt
prompt Tune the sql
prompt ~~~~~~~~~~~~
variable task_name varchar2(64);
variable err       number;

-- By default, no error
execute :err := 0;

set serveroutput on;

DECLARE
  cnt      NUMBER;
  bid      NUMBER;
  eid      NUMBER;
BEGIN
  -- If it's not in V$SQL we will have to query the workload repository
  select count(*) into cnt from V$SQLSTATS where sql_id = '&&sqlid';

  IF (cnt > 0) THEN
    :task_name := dbms_sqltune.create_tuning_task(sql_id => '&&sqlid');
  ELSE
    select min(snap_id) into bid
    from   dba_hist_sqlstat
    where  sql_id = '&&sqlid';

    select max(snap_id) into eid
    from   dba_hist_sqlstat
    where  sql_id = '&&sqlid';

    :task_name := dbms_sqltune.create_tuning_task(begin_snap => bid,
                                                  end_snap => eid,
                                                  sql_id => '&&sqlid');
  END IF;

  dbms_sqltune.execute_tuning_task(:task_name);

EXCEPTION
  WHEN OTHERS THEN
    :err := 1;

    IF (SQLCODE = -13780) THEN
      dbms_output.put_line ('ERROR: statement is not in the cursor cache ' ||
                            'or the workload repository.');
      dbms_output.put_line('Execute the statement and try again');
    ELSE
      RAISE;
    END IF;   
 
END;
/

set heading off;
select dbms_sqltune.report_tuning_task(:task_name) from dual where :err <> 1;
select '   ' from dual where :err = 1;
set heading on;

undefine sqlid;
set feedback on;
set veri on;
