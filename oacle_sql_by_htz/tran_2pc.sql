set echo off
set heading on pages 400 lines 300 verify off
col local_tran_id for a20
col global_tran_id for a40
col in_out for a6
col database for a15
col  dbuser_owner for a15
col interface for a5
col  state for a15
col fail_retry_time for a28
SELECT a.local_tran_id,
       b.global_tran_id,
       a.in_out,
       a.database,
       a.dbuser_owner,
       a.interface,
       b.state,
          TO_CHAR (b.fail_time, 'yy-mm-dd hh24:ss')
       || '*'
       || TO_CHAR (b.retry_time, 'dd hh24:mi')
          fail_retry_time
  FROM DBA_2PC_NEIGHBORS a, DBA_2PC_PENDING b
 WHERE a.local_tran_id = b.local_tran_id;
