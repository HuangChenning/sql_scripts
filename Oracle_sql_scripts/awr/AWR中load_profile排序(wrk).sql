set pagesize 50 linesize 250
col TIME for a5
col snap_date for a8
col "DB CPU/DB time(%)" for a15
select s.dbid,s.instance_number,
       s.snap_date,
       decode(s.redosize, null, '--shutdown or end--', s.currtime) "TIME",
       z.avg_sess_count "active_sess",
       round(t.db_time / 1000000 / 60) "DB time(min)",
       round(t.db_time / 1000000 / s.seconds) "DB time/s",
       round(t.db_cpu / 1000000 / s.seconds) "DB CPU/s",
       round((t.db_cpu / t.db_time) * 100, 2) || '%' "DB CPU/DB time(%)",
       round(s.redosize / 1024 / 1024 / s.seconds, 2) "redo/s(M)",
       round(s.logicalreads / 1000000 / s.seconds, 2) "gets(million)/s",
       round(s.physicalreads / 1000 / s.seconds, 1) "reads(thousand)/s",
       round(s.blockchanges / s.seconds, 1) "blockchanges/s",
       round(s.executes / s.seconds) "execs/s",
       round(s.parse / s.seconds) "parse/s",
       round(s.hardparse / s.seconds) "hardparse/s",
       round(s.transactions / s.seconds) "trans/s"
  from (select dbid,instance_number,
               curr_redo - last_redo redosize,
               curr_logicalreads - last_logicalreads logicalreads,
               curr_physicalreads - last_physicalreads physicalreads,
               curr_blockchanges - last_blockchanges blockchanges,
               curr_executes - last_executes executes,
               curr_parse - last_parse parse,
               curr_hardparse - last_hardparse hardparse,
               curr_transactions - last_transactions transactions,
               round(((currtime + 0) - (lasttime + 0)) * 3600 * 24, 0) seconds,
               to_char(currtime, 'yy/mm/dd') snap_date,
               to_char(currtime, 'hh24:mi') currtime,
               currsnap_id endsnap_id,
               to_char(startup_time, 'yyyy-mm-dd hh24:mi:ss') startup_time
          from (select a.dbid,a.instance_number,
                       a.redo last_redo,
                       a.logicalreads last_logicalreads,
                       a.physicalreads last_physicalreads,
                       a.blockchanges last_blockchanges,
                       a.executes last_executes,
                       a.parse last_parse,
                       a.hardparse last_hardparse,
                       a.transactions last_transactions,
                       lead(a.redo, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_redo,
                       lead(a.logicalreads, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_logicalreads,
                       lead(a.physicalreads, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_physicalreads,
                       lead(a.blockchanges, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_blockchanges,
                       lead(a.executes, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_executes,
                       lead(a.parse, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_parse,
                       lead(a.hardparse, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_hardparse,
                       lead(a.transactions, 1, null) over(partition by b.startup_time order by b.end_interval_time) curr_transactions,
                       b.end_interval_time lasttime,
                       lead(b.end_interval_time, 1, null) over(partition by b.startup_time order by b.end_interval_time) currtime,
                       lead(b.snap_id, 1, null) over(partition by b.startup_time order by b.end_interval_time) currsnap_id,
                       b.startup_time
                  from (select dbid,snap_id,
                               instance_number,
                               sum(decode(stat_name, 'redo size', value, 0)) redo,
                               sum(decode(stat_name,'session logical reads', value,0)) logicalreads,
                               sum(decode(stat_name,'physical reads',value,0)) physicalreads,
                               sum(decode(stat_name,'db block changes',value,0)) blockchanges,
                               sum(decode(stat_name,'execute count', value, 0)) executes,
                               sum(decode(stat_name,'parse count (total)',value,0)) parse,
                               sum(decode(stat_name,'parse count (hard)',value,0)) hardparse,
                               sum(decode(stat_name,'user rollbacks',value,'user commits',value,0)) transactions
                          from dba_hist_sysstat
                         where stat_name in
                               ('redo size',
                                'session logical reads','db block changes',
                                'physical reads',
                                'execute count',
                                'user rollbacks',
                                'user commits',
                                'parse count (hard)',
                                'parse count (total)')
                           and dbid=&dbid and instance_number = &inst_num and (snap_id between &begin_snap and &end_snap)
                         group by snap_id, dbid, instance_number) a,
                       dba_hist_snapshot b
                 where a.snap_id = b.snap_id
                   and a.dbid = b.dbid
                   and a.instance_number = b.instance_number
                 order by end_interval_time)) s,
       (select a.dbid,a.instance_number, a.db_time, b.db_cpu, b.endsnap_id
          from (select x.dbid,x.instance_number,
                       lead(x.value, 1, null) over(partition by y.startup_time order by y.end_interval_time) - x.value db_time,
                       lead(y.snap_id, 1, null) over(partition by y.startup_time order by y.end_interval_time) endsnap_id
                  from dba_hist_sys_time_model x, dba_hist_snapshot y
                 where x.snap_id = y.snap_id
                   and x.dbid = y.dbid
                   and x.instance_number = y.instance_number
                   and x.stat_name = 'DB time') a,
               (select x.dbid,x.instance_number,
                       lead(x.value, 1, null) over(partition by y.startup_time order by y.end_interval_time) - x.value db_cpu,
                       lead(y.snap_id, 1, null) over(partition by y.startup_time order by y.end_interval_time) endsnap_id
                  from dba_hist_sys_time_model x, dba_hist_snapshot y
                 where x.snap_id = y.snap_id
                   and x.dbid = y.dbid
                   and x.instance_number = y.instance_number
                   and x.stat_name = 'DB CPU') b
         where a.endsnap_id = b.endsnap_id
           and a.instance_number = b.instance_number and a.dbid=b.dbid) t,
       (select dbid,snap_id,
               instance_number,
               round(sum(sess_count) / count(sample_id), 2) avg_sess_count
          from (select dbid,snap_id,
                       sample_id,
                       instance_number,
                       count(distinct session_id || session_serial#) sess_count
                  from dba_hist_active_sess_history
                 where session_type = 'FOREGROUND'
                 group by dbid,snap_id, instance_number, sample_id)
         group by dbid,snap_id, instance_number) z
 where s.endsnap_id = t.endsnap_id
   and z.snap_id = t.endsnap_id
   and s.instance_number = t.instance_number
   and z.instance_number = t.instance_number and s.dbid=t.dbid and z.dbid=t.dbid
 order by &orderby desc;