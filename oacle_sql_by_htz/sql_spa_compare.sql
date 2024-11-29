/* Formatted on 2016/5/12 14:07:21 (QP5 v5.256.13226.35510) */
SET ECHO OFF
SET LINES 2000 PAGES 10000 HEADING ON VERIFY OFF
COL sql_id FOR a18
COL executions FOR 99999999999 HEADING 'executions|Frequency'
COL elapsed_time_new FOR 999999999  HEADING 'Elapsed|Metric|After'
COL elapsed_time_old FOR 999999999  HEADING 'Elapsed|Metric|Before'
COL buffer_gets_new FOR 999999999  HEADING 'Buffer|Metric|Before'
COL buffer_gets_old FOR 999999999  HEADING 'Buffer|Metric|After'
COL sum_time FOR 9999999 HEADING  'Elapsed Impact |on Workload'
COL sum_get FOR 9999999 HEADING  'Buffer Impact |on Workload'
COL elapsed_impact FOR a15 HEADING 'Elapsed Impact|on sql'
COL gets_impact FOR a15 HEADING 'Buffer Impact|on sql'
UNDEFINE taskname;
UNDEFINE sqlsetname;

  SELECT e.sql_id,
         e.executions,
         e.elapsed_time_new,
         e.elapsed_time_old,
         e.buffer_gets_new,
         buffer_gets_old,
         e.sum_time,
         e.sum_get,
         e.elapsed_impact,
         e.gets_impact
    FROM (SELECT d.sql_id,
                 d.executions,
                 d.elapsed_time_new,
                 d.elapsed_time_old,
                 incr_time,
                 d.buffer_gets_new,
                 d.buffer_gets_old,
                 incr_get,
                 TRUNC (
                      10000
                    * (  incr_time
                       * d.executions
                       / SUM (d.incr_time * d.executions) OVER ()),
                    4)
                    sum_time,
                 TRUNC (
                      10000
                    * (  incr_get
                       * d.executions
                       / SUM (d.incr_get * d.executions) OVER ()),
                    4)
                    sum_get,
                 d.elapsed_impact,
                 d.gets_impact
            FROM (SELECT c.sql_id,
                         c.executions,
                         c.parsing_schema_name,
                         c.plan_hash_value_old,
                         c.plan_hash_value_new,
                         c.elapsed_time_new,
                         c.elapsed_time_old,
                         c.buffer_gets_new,
                         c.buffer_gets_old,
                         CASE
                            WHEN elapsed_time_new > elapsed_time_old
                            THEN
                               elapsed_time_new - elapsed_time_old
                         END
                            incr_time,
                         CASE
                            WHEN buffer_gets_new > buffer_gets_old
                            THEN
                               buffer_gets_new - buffer_gets_old
                         END
                            incr_get,
                         CASE
                            WHEN elapsed_time_new > elapsed_time_old
                            THEN
                                  '-'
                               ||   TRUNC (
                                       (  (elapsed_time_new - elapsed_time_old)
                                        / DECODE (elapsed_time_old,
                                                  0, 1,
                                                  elapsed_time_old)),
                                       4)
                                  * 100
                               || '%'
                            WHEN elapsed_time_new < elapsed_time_old
                            THEN
                                  '+'
                               ||   TRUNC (
                                       (  (elapsed_time_old - elapsed_time_new)
                                        / DECODE (elapsed_time_old,
                                                  0, 1,
                                                  elapsed_time_old)),
                                       4)
                                  * 100
                               || '%'
                            WHEN elapsed_time_new = elapsed_time_old
                            THEN
                               '1'
                            ELSE
                               NULL
                         END
                            elapsed_impact,
                         CASE
                            WHEN buffer_gets_new > buffer_gets_old
                            THEN
                                  '-'
                               ||   TRUNC (
                                       (  (buffer_gets_new - buffer_gets_old)
                                        / DECODE (buffer_gets_old,
                                                  0, 1,
                                                  buffer_gets_old)),
                                       4)
                                  * 100
                               || '%'
                            WHEN buffer_gets_new < buffer_gets_old
                            THEN
                                  '+'
                               ||   TRUNC (
                                       (  (buffer_gets_old - buffer_gets_new)
                                        / DECODE (buffer_gets_old,
                                                  0, 1,
                                                  buffer_gets_old)),
                                       4)
                                  * 100
                               || '%'
                            WHEN buffer_gets_new = buffer_gets_old
                            THEN
                               '1'
                            ELSE
                               NULL
                         END
                            gets_impact
                    FROM (SELECT a.sql_id,
                                 a.executions,
                                 a.parsing_schema_name,
                                 a.plan_hash_value plan_hash_value_old,
                                 b.plan_hash_value plan_hash_value_new,
                                 TRUNC (a.elapsed_time / a.executions, 4)
                                    elapsed_time_old,
                                 b.elapsed_time elapsed_time_new,
                                 TRUNC (a.cpu_time / a.executions, 4)
                                    cpu_time_old,
                                 b.cpu_time cpu_time_new,
                                 TRUNC (a.buffer_gets / a.executions, 4)
                                    buffer_gets_old,
                                 b.buffer_gets buffer_gets_new,
                                 TRUNC (a.disk_reads / a.executions, 4)
                                    disk_reads_old,
                                 b.disk_reads disk_reads_new,
                                 TRUNC (a.rows_processed / a.executions, 4)
                                    rows_processed_old,
                                 b.rows_processed rows_processed_new
                            FROM dba_advisor_sqlstats b,
                                 dba_sqlset_statements a
                           WHERE     b.task_name = '&taskname'
                                 AND execution_type = 'TEST EXECUTE'
                                 AND a.sqlset_name = '&sqlsetname'
                                 AND a.executions >= 1
                                 AND a.sql_id = b.sql_id) c
                   WHERE    buffer_gets_new > buffer_gets_old
                         OR buffer_gets_new > buffer_gets_old) d) e
   WHERE sum_get > 1 OR sum_time > 1
ORDER BY e.sum_get DESC
/