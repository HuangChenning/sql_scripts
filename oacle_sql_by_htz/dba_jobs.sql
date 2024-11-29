set pages 2000
set lines 2000
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

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
col owner for a15;
col job_name for a25
col job_class for a30
col nextrundate for a19
col repeat_interval for a40
col JOB_ACTION for a40

select 
   owner,
   job_name,
   JOB_ACTION, 
   job_class,
   enabled,
   to_char(next_run_date,'YYYY-MM-DD HH24:MI:SS') nextrundate,
   substr(repeat_interval,1,40) repeat_interval
from
   dba_scheduler_jobs
/
