set echo off;
set lines 200 pages 1000 verify off heading on;
col inst_id for 9 heading 'I'
col con_id for 9 heading 'CI'
col name for a15 heading 'PDB_NAME'
col instance_name for a16 heading 'INST_NAME'
col open_mode for a10
col restricted for a10
col open_time for a19
col total_size for 999999 heading 'SIZE(G)'
col recovery_status for a15 heading 'RECOVERY|STATUS'
col state for a10 heading 'SAVE|STATE'
/* Formatted on 2016/6/14 23:49:39 (QP5 v5.256.13226.35510) */
SELECT a.inst_id,
       a.con_id,
       a.name,
       b.instance_name,
       a.open_mode,
       a.RESTRICTED,
       TO_CHAR (a.OPEN_TIME, 'yyyy-mm-dd hh24:mi:ss') open_time,
       trunc(a.TOTAL_SIZE/1024/1024/1024) total_size,
       a.RECOVERY_STATUS,
       STATE
  FROM gv$containers a, dba_pdb_saved_states b
 WHERE a.con_id = b.con_id(+)
 order by con_id,inst_id
 /

