-- Purpose:     Show the last_load_time of the SQL
set verify off
set pagesize 999
set lines 175
col prog format a22
col sql_text format a41 trunc
col sid format 999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.99
col avg_pio format 9,999,999
col avg_lio format 999,999,999
col etime format 9,999,999.99
col dtime for a19
break on sql_text

select sql_id, child_number, plan_hash_value plan_hash, last_load_time dtime, executions execs,
(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
disk_reads/decode(nvl(executions,0),0,1,executions) avg_pio,
buffer_gets/decode(nvl(executions,0),0,1,executions) avg_lio,
sql_text
from v$sql s
where sql_text like '%&sql_text%'
and sql_text not like '%from v$sql where sql_text like nvl(%'
and sql_id like nvl('&sql_id',sql_id)
order by 1, 2, 3
/

