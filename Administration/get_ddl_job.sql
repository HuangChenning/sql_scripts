SET ECHO        OFF
set pages 2000 lines 2000 serveroutput on
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN job        FORMAT 9999999    HEADING 'Job ID'
COLUMN username   FORMAT a20        HEADING 'User'
COLUMN what       FORMAT a50        HEADING 'What'
COLUMN next_date  format a19         HEADING 'Next Run Date'
COLUMN interval   FORMAT a30        HEADING 'Interval'
COLUMN last_date  FORMAT A19        HEADING 'Last Run Date'
COLUMN failures   FORMAT 9999       HEADING 'Failures'
COLUMN broken     FORMAT a7         HEADING 'Broken?'
PROMPT FROM JOBS
SELECT
    job
  , log_user username
  , what
  , next_date
  , interval
  , last_date
  , failures
  , broken
FROM
    dba_jobs;

DECLARE
  CURSOR job_list
  IS
    SELECT JOB
    FROM dba_jobs
    WHERE job IN (&job_id_list);

  mysql VARCHAR2(32767);
BEGIN
  FOR job_id IN job_list
  LOOP
    mysql := '';
    DBMS_JOB.user_export(job_id.job, mysql);
    DBMS_OUTPUT.put_line('exec ' || mysql);
  END LOOP;
END;
/
