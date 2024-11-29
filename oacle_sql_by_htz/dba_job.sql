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
COLUMN what       FORMAT a40        HEADING 'What'
COLUMN next_date  format a16                  HEADING 'Next Run Date'
COLUMN interval   FORMAT a30        HEADING 'Interval'
column this_date for a16
COLUMN last_date  FORMAT A16                  HEADING 'Last Run Date'
COLUMN failures                     HEADING 'Failures'
COLUMN broken     FORMAT a7         HEADING 'Broken?'
PROMPT FROM JOBS
SELECT
    job
  , log_user username
  , TO_CHAR(next_date, 'yy-mm-dd hh24:mi') next_date
  , interval
  , TO_CHAR(last_date, 'yy-mm-dd hh24:mi') last_date
  , to_char(this_DATE, 'yy-mm-dd hh24:mi') this_date
  , failures
  , broken
  , what
FROM
    dba_jobs where job=nvl('&job_id',job);
undefine job_id;
