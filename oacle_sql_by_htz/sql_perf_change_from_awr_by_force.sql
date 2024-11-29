set echo off
set lines 200 pages 100
col end_time                  for a8
col sanp_id                   for 9999999
col sql_id                    for a18
col cur_plan                  for 9999999999999
col buffer_new                for 9999999999999
col incre_value.              for 9999999999999
col flag                      for a4
WITH get_snap_id
     AS (SELECT MIN (snap_id) snap_id
           FROM dba_hist_snapshot
          WHERE end_interval_time >= SYSDATE - 1),
     sql_stat
     AS (  SELECT snap_id,
                  force_matching_signature,
                  plan_hash_value,
                  SUM (cpu_time_delta)  cpu_time,
                  SUM (disk_reads_delta) disk_reads,
                  SUM (buffer_gets_delta) buffer_gets,
                  DECODE (SUM (executions_delta), 0, 1, SUM (executions_delta))
                     execs
             FROM (SELECT CASE
                             WHEN dhs.snap_id >= gsi.snap_id THEN dhs.snap_id
                             ELSE 0
                          END
                          snap_id,
                          force_matching_signature,
                          plan_hash_value,
                          cpu_time_delta,
                          disk_reads_delta,
                          buffer_gets_delta,
                          executions_delta
                     FROM dba_hist_sqlstat dhs, get_snap_id gsi
                    WHERE dhs.snap_id IN
                             (SELECT snap_id
                                FROM dba_hist_snapshot a
                               WHERE TO_CHAR (a.END_INTERVAL_TIME, 'hh24') BETWEEN '08'
                                                                               AND '22'))
            WHERE plan_hash_value <> 0
         GROUP BY snap_id, force_matching_signature, plan_hash_value)
SELECT (SELECT TO_CHAR (END_INTERVAL_TIME, 'dd hh24:mi')
          FROM dba_hist_snapshot
         WHERE snap_id = b.snap_id AND ROWNUM = 1)
          end_time,
       snap_id,
       (select sql_id from dba_hist_sqlstat where force_matching_signature=b.force_matching_signature and plan_hash_value=b.cur_plan and rownum=1) sql_id,
       execs,
       cur_plan,
       buffer_new,
       (buffer_new-buffer_old) incre_value,
       flag_new flag
  FROM (SELECT sql_cur.snap_id,
               sql_cur.force_matching_signature,
               sql_cur.execs,
               sql_cur.plan_hash_value                     cur_plan,
               sql_old.plan_hash_value                     old_plan,
               ROUND (sql_cur.buffer_gets / sql_cur.execs) buffer_new,
               NVL (ROUND (sql_old.buffer_gets / sql_old.execs), 0)
                  buffer_old,
               NVL2 (sql_old.force_matching_signature, 'old', 'new')         flag_new,
               ROW_NUMBER ()
               OVER (PARTITION BY sql_cur.force_matching_signature, sql_cur.plan_hash_value
                     ORDER BY sql_cur.snap_id)
                  rn
          FROM sql_stat sql_cur, sql_stat sql_old
         WHERE     sql_cur.force_matching_signature = sql_old.force_matching_signature(+)
               AND sql_cur.plan_hash_value = sql_old.plan_hash_value(+)
               AND   ROUND (sql_cur.buffer_gets / sql_cur.execs)
                   - NVL (ROUND (sql_old.buffer_gets / sql_old.execs), 0) >
                      50000
               AND sql_cur.snap_id > 0
               AND sql_old.snap_id(+) = 0
               and sql_cur.execs>10) b
 WHERE rn = 1 order by incre_value
 /