set linesize 130 pagesize 999

select event,count(*) from(
select sample_id,sample_time,event from v$active_session_history
union all
select sample_id,sample_time,event from dba_hist_active_sess_history
) where sample_time between
to_date('&&YYYYMMDD &&HHMISS','yyyymmdd hh24miss')
and to_date('&&YYYYMMDD &&HHMISS','yyyymmdd hh24miss') + &&MINUTE/1440
group by event
order by 2;

SELECT sample_id FROM(
SELECT * FROM(
select sample_id,dbms_random.value random from (
select distinct sample_id from(
select sample_id,sample_time,event from v$active_session_history
union all
select sample_id,sample_time,event from dba_hist_active_sess_history
) where sample_time between
to_date('&&YYYYMMDD &&HHMISS','yyyymmdd hh24miss')
and to_date('&&YYYYMMDD &&HHMISS','yyyymmdd hh24miss') + &&MINUTE/1440
and event='&EVENT' )) ORDER BY random)
where rownum<=20;

undefine YYYYMMDD
undefine HHMISS
undefine MINUTE

col     sid for 999999
col blk_sid for 999999
col event   for a30
col p1      for 99999999999999999
col p2      for 99999999999999999
col sql_id  for a15

select sid,blk_sid,event,p1,p2,sql_id
from (
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from v$active_session_history
union all
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from dba_hist_active_sess_history
) where sample_id=&SAMPLE_ID
order by 1;

select sid,blk_sid,event,p1,p2,sql_id
from (
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from v$active_session_history
union all
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from dba_hist_active_sess_history
) where sample_id=&SAMPLE_ID
order by 1;

select sid,blk_sid,event,p1,p2,sql_id
from (
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from v$active_session_history
union all
select sample_id,session_id sid,blocking_session blk_sid,event,p1,p2,sql_id from dba_hist_active_sess_history
) where sample_id=&SAMPLE_ID
order by 1;
