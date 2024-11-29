set echo off
set heading on
set lines 200 pages 1000 num 20
SET VERIFY OFF
SELECT *
  FROM (SELECT begin_time,
               startup_time,
               (CASE
                 WHEN startup_same = 1 THEN
                  ROUND((VALUE - lag_value) /
                        ((begin_interval_time - lag_begin_interval_time) * 3600 * 24))
                 ELSE
                  NULL
               END) gas_rate
          FROM (SELECT TO_CHAR(begin_interval_time, 'yyyy-mm-dd hh24:mi:ss') begin_time,
                       TO_CHAR(startup_time, 'yyyy-mm-dd hh24:mi:ss') startup_time,
                       VALUE,
                       snap_id,
                       LAG(VALUE, 1) OVER(ORDER BY snap_id) lag_value,
                       TO_DATE(TO_CHAR(begin_interval_time,
                                       'yyyy-mm-dd hh24:mi:ss'),
                               'yyyy-mm-dd hh24:mi:ss') begin_interval_time,
                       TO_DATE(TO_CHAR(LAG(begin_interval_time, 1)
                                       OVER(ORDER BY snap_id),
                                       'yyyy-mm-dd hh24:mi:ss'),
                               'yyyy-mm-dd hh24:mi:ss') lag_begin_interval_time,
                       (CASE
                         WHEN startup_time = LAG(startup_time, 1)
                          OVER(ORDER BY snap_id) THEN
                          1
                         ELSE
                          0
                       END) startup_same
                  FROM (SELECT a.snap_id,
                               VALUE,
                               b.snap_time begin_interval_time,
                               startup_time
                          FROM stats$sysstat a, stats$snapshot b
                         WHERE a.name = 'calls to kcmgas'
                           AND a.snap_id = b.snap_id
                           AND a.dbid = b.dbid
                           AND a.instance_number = b.instance_number
                           AND b.dbid = (SELECT dbid FROM v$database)
                           AND b.instance_number =
                               (SELECT instance_number FROM v$instance)
                           AND b.snap_time >= SYSDATE - NVL('&day', 10))
                 ORDER BY snap_id)
         ORDER BY snap_id)
 WHERE gas_rate >= NVL('&rate_number', 1)
 ORDER BY begin_time;