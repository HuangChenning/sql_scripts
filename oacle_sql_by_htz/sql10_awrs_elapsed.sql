set lines 200
set echo off;
set heading on
set term off
spool sql10_awr_elapsed.sql
select '@sql10_awr.sql ' || e.snap_id || ' ' || e.end_time || ' ' || rnum || ' ' ||
       e.sql_id || ' ' || 'elapsed'||';'
  from (select d.snap_id,
               d.end_time,
               d.sql_id,
               row_number() over(partition by d.snap_id order by d.buffer_get) rnum
          from (select c.snap_id,
                       to_char(c.end_interval_time, 'yymmddhh24mi') end_time,
                       a.sql_id,
                       sum(a.elapsed_time_delta) buffer_get
                  from dba_hist_sqlstat a, dba_hist_snapshot c
                 where a.dbid = (select b.dbid from v$database b)
                   and a.dbid = c.dbid
                   and a.snap_id = c.snap_id
                   and a.snap_id >= &1
                   and a.snap_id <= &2
                 group by c.snap_id,
                          to_char(c.end_interval_time, 'yymmddhh24mi'),
                          a.sql_id) d) e
 where rnum < &3
/
spool off;
host grep '^@sql10' sql10_awr_elapsed.sql > sql10_awr_elapseds.sql
@sql10_awr_elapseds.sql
host rm -rf sql10_awr_elapsed.sql  sql10_awr_elapseds.sql