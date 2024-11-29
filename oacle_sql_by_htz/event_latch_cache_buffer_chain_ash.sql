set echo off
set lines 2000 pages 3000 verify off heading on
col time for a20
col laddr for a20
col time_addr_pct for a9 heading 'PCT|TIME_ADDR'
col ADDR_PCT for a9 heading 'ADDR_PCT'
undefine begin_date;
undefine interval_hours;
select distinct TO_CHAR(DATE_HH, 'yyyymmdd hh24') || ' ' || 10 * (DATE_MI) || '-' ||
                10 * (DATE_MI + 1) TIME,
                lpad(latch_addr, 16, '0') laddr,
                round(count / count1, 4) * 100 || '%' TIME_ADDR_PCT,
                round(count3 / count2, 4) * 100 || '%' ADDR_PCT
  from (SELECT TRUNC(SAMPLE_TIME, 'HH') DATE_HH,
               TRUNC(TO_CHAR(SAMPLE_TIME, 'MI') / 10) DATE_MI,
               TRIM(TO_CHAR(p1, 'XXXXXXXXXXXXXXXX')) latch_addr,
               count(1) over(partition by TRUNC(SAMPLE_TIME, 'HH'), TRUNC(TO_CHAR(SAMPLE_TIME, 'MI') / 10), TRIM(TO_CHAR(p1, 'XXXXXXXXXXXXXXXX'))) count,
               count(1) over(partition by TRUNC(SAMPLE_TIME, 'HH'), TRUNC(TO_CHAR(SAMPLE_TIME, 'MI') / 10)) count1,
               count(1) over() count2,
               count(1) over(partition by TRIM(TO_CHAR(p1, 'XXXXXXXXXXXXXXXX'))) count3
          from (select sample_time, p1
                  FROM v$active_session_history
                 WHERE event = 'latch: cache buffers chains'
                   AND session_state = 'WAITING'
                   and SAMPLE_TIME >=
                       to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss')
                   AND SAMPLE_TIME <=
                       to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss') +
                       nvl(&&interval_hours, 2) / 24
                union all
                select sample_time, p1
                  FROM DBA_HIST_ACTIVE_SESS_HISTORY
                 WHERE event = 'latch: cache buffers chains'
                   AND session_state = 'WAITING'
                   and SAMPLE_TIME >=
                       to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss')
                   AND SAMPLE_TIME <=
                       to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss') +
                       nvl(&&interval_hours, 2) / 24))
 order by time,TIME_ADDR_PCT;
undefine begin_date;
undefine interval_hours;