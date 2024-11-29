set echo off
set lines 220 pages 1000
col elapsed_seconds heading "ELAPSED|SECONDS"
col output_mbytes for 999,999,999 heading "OUTPUT|SIZE(G)"
col session_recid for 999999 heading "SESSION|RECID"
col session_stamp for 99999999999 heading "SESSION|STAMP"
col status for a10 trunc
col time_taken_display for a10 heading "TIME|TAKEN"
col output_instance for 9999 heading "OUT|INST"
col start_time for a19
col end_time   for a19
col dow for a3 heading 'DAY'
col df_count for 999999 heading "FILE|COUNT"
select to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
       to_char(j.start_time, 'd') dow,
       to_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
       j.time_taken_display,
       (j.output_bytes / 1024 / 1024/1024) output_size,
       j.status,
       j.input_type,
       x.df_count,
       ro.inst_id output_instance
  from v$rman_backup_job_details j
  join (select b.session_recid,
                          b.session_stamp,
                          count(*) df_count
                     from v$backup_files a, v$backup_set_details b
                    where a.bs_count = b.set_count
                      and a.bs_stamp = b.set_stamp
                      and a.file_type = 'DATAFILE'
                      and a.backup_type = 'BACKUP SET'
                    group by b.session_recid, b.session_stamp) x
    on x.session_recid = j.session_recid
   and x.session_stamp = j.session_stamp
  left outer join (select o.session_recid,
                          o.session_stamp,
                          min(inst_id) inst_id
                     from gv$rman_output o
                    group by o.session_recid, o.session_stamp) ro
    on ro.session_recid = j.session_recid
   and ro.session_stamp = j.session_stamp
order by j.start_time;
