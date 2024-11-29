select *
  from (select begin_time,
               startup_time,
               (case
                 when startup_same = 1 then
                  round((value - lag_value) /
                        ((end_interval_time - lag_end_interval_time) * 3600 * 24))
                 else
                  null
               end) gas_rate
          from (select to_char(begin_interval_time, 'yyyy-mm-dd hh24:mi:ss') begin_time,
                       to_char(startup_time, 'yyyy-mm-dd hh24:mi:ss') startup_time,
                       value,
                       snap_id,
                       lag(value, 1) over(order by snap_id) lag_value,
                       to_date(to_char(end_interval_time,
                                       'yyyy-mm-dd hh24:mi:ss'),
                               'yyyy-mm-dd hh24:mi:ss') end_interval_time,
                       to_date(to_char(lag(end_interval_time, 1)
                                       over(order by snap_id),
                                       'yyyy-mm-dd hh24:mi:ss'),
                               'yyyy-mm-dd hh24:mi:ss') lag_end_interval_time,
                       (case
                         when startup_time = lag(startup_time, 1)
                          over(order by snap_id) then
                          1
                         else
                          0
                       end) startup_same
                  from (select a.snap_id,
                               value,
                               b.begin_interval_time,
                               b.end_interval_time,
                               startup_time
                          from dba_hist_sysstat a, dba_hist_snapshot b
                         where stat_name = 'calls to kcmgas'
                           and a.snap_id = b.snap_id
                           and a.dbid = b.dbid
                           and a.instance_number = b.instance_number
                           and b.dbid = (select dbid from v$database)
                           and b.instance_number = b.instance_number
                           and b.instance_number =
                               (select instance_number from v$instance)
                           and b.begin_interval_time >= sysdate - 10)
                 order by snap_id)
         order by snap_id)
 where gas_rate >= 5000
 order by begin_time;

