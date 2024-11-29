set lines 2000
set pages 10000

PROMPT "DATABASE"
select name,open_mode,log_mode,force_logging from v$database
/

PROMPT "PARAMETER"
col inst_id for 99
col parameter_name for a60 
col value for a60
col display_value for a60
select inst_id,name parameter_name,value,display_value from gv$parameter where isdefault='FALSE' order by name,inst_id
/ 
PROMPT "TABLESPACE SIZE"
col size_m for 9999999
col used_size_m for 99999999
col free_size_m for 999999
SELECT a.tablespace_name,
       TRUNC (tablespace_size * b.block_size / 1024 / 1024) size_m,
       TRUNC (used_space * b.block_size / 1024 / 1024) used_size_m,
       TRUNC ( (TABLESPACE_SIZE - used_space) * b.block_size / 1024 / 1024)
          free_size_m,
       USED_PERCENT
  FROM DBA_TABLESPACE_USAGE_METRICS a, dba_tablespaces b
 WHERE a.tablespace_name = b.tablespace_name
 ORDER BY USED_PERCENT
 /
col rtime for a10
col name for a20
col tsize for 9999999
col max_size for 99999999
col used_size for 9999999
col inc_size for 99999
col free_size for 99999999
PROMPT "TABLESPACE INC <10"
WITH tt
     AS (SELECT e.rtime,
                e.tablespace_id,
                e.tablespace_size,
                e.tablespace_maxsize,
                e.tablespace_usedsize,
                (  e.tablespace_usedsize
                 - NVL (
                      LAG (e.TABLESPACE_USEDSIZE)
                         OVER (PARTITION BY tablespace_id ORDER BY dnum),
                      e.tablespace_usedsize))
                   inc_use_size
           FROM (SELECT a.tablespace_id,
                        a.tablespace_size,
                        a.tablespace_maxsize,
                        a.TABLESPACE_USEDSIZE,
                        a.rtime,
                        ROW_NUMBER ()
                           OVER (PARTITION BY a.TABLESPACE_ID ORDER BY rtime)
                           dnum
                   FROM (SELECT b.tablespace_id,
                                b.tablespace_size,
                                b.tablespace_maxsize,
                                SUBSTR (b.rtime, 1, 10) rtime,
                                b.TABLESPACE_USEDSIZE,
                                ROW_NUMBER ()
                                OVER (
                                   PARTITION BY b.TABLESPACE_ID,
                                                SUBSTR (b.rtime, 1, 10)
                                   ORDER BY b.TABLESPACE_USEDSIZE DESC)
                                   rnum
                           FROM dba_hist_tbspc_space_usage b, v$database c
                          WHERE b.dbid = c.dbid) a
                  WHERE rnum = 1) e)
SELECT *
  FROM (SELECT i.rtime,
               i.name,
               i.tsize,
               i.max_size,
               i.used_size,
               TRUNC (i.tsize - i.used_size) free_size,
               TRUNC (i.avg_inc_size),
               TRUNC (
                  (i.tsize - i.used_size) / DECODE (i.avg_inc_size, 0, 1))
                  inc_day
          FROM (SELECT o.rtime,
                       o.name,
                       o.tsize,
                       o.max_size,
                       o.used_size,
                       MAX (rtime) OVER (PARTITION BY o.name) m_rtime,
                       MAX (used_size) OVER (PARTITION BY o.name)
                          max_used_size,
                       AVG (inc_size) OVER (PARTITION BY o.name) avg_inc_size
                  FROM (SELECT tt.rtime,
                               f.name,
                               TRUNC (
                                    tt.tablespace_size
                                  * h.BLOCK_SIZE
                                  / 1024
                                  / 1024)
                                  tsize,
                               TRUNC (
                                    tt.tablespace_maxsize
                                  * h.BLOCK_SIZE
                                  / 1024
                                  / 1024)
                                  max_size,
                               TRUNC (
                                    tt.tablespace_usedsize
                                  * h.BLOCK_SIZE
                                  / 1024
                                  / 1024)
                                  used_size,
                               TRUNC (
                                    tt.inc_use_size
                                  * h.BLOCK_SIZE
                                  / 1024
                                  / 1024)
                                  inc_size
                          FROM v$tablespace f, tt, dba_tablespaces h
                         WHERE     f.ts# = tt.tablespace_id(+)
                               AND tt.inc_use_size > 0
                               AND f.name = h.tablespace_name
                               AND h.CONTENTS IN ('PERMANENT')) o) i
         WHERE i.rtime = i.m_rtime)
 WHERE inc_day < 10
/
PROMPT "TABLESPACE INC INFO"
WITH tt
     AS (SELECT e.rtime,
                e.tablespace_id,
                e.tablespace_size,
                e.tablespace_maxsize,
                e.tablespace_usedsize,
                (  e.tablespace_usedsize
                 - NVL (
                      LAG (e.TABLESPACE_USEDSIZE)
                         OVER (PARTITION BY tablespace_id ORDER BY dnum),
                      e.tablespace_usedsize))
                   inc_use_size
           FROM (SELECT a.tablespace_id,
                        a.tablespace_size,
                        a.tablespace_maxsize,
                        a.TABLESPACE_USEDSIZE,
                        a.rtime,
                        ROW_NUMBER ()
                           OVER (PARTITION BY a.TABLESPACE_ID ORDER BY rtime)
                           dnum
                   FROM (SELECT b.tablespace_id,
                                b.tablespace_size,
                                b.tablespace_maxsize,
                                SUBSTR (b.rtime, 1, 10) rtime,
                                b.TABLESPACE_USEDSIZE,
                                ROW_NUMBER ()
                                OVER (
                                   PARTITION BY b.TABLESPACE_ID,
                                                SUBSTR (b.rtime, 1, 10)
                                   ORDER BY b.TABLESPACE_USEDSIZE DESC)
                                   rnum
                           FROM dba_hist_tbspc_space_usage b, v$database c
                          WHERE b.dbid = c.dbid) a
                  WHERE rnum = 1) e)
  SELECT tt.rtime,
         f.name,
         TRUNC (tt.tablespace_size * h.BLOCK_SIZE / 1024 / 1024) tsize,
         TRUNC (tt.tablespace_maxsize * h.BLOCK_SIZE / 1024 / 1024) max_size,
         TRUNC (tt.tablespace_usedsize * h.BLOCK_SIZE / 1024 / 1024) used_size,
         TRUNC (tt.inc_use_size * h.BLOCK_SIZE / 1024 / 1024) inc_size
    FROM v$tablespace f, tt, dba_tablespaces h
   WHERE     f.ts# = tt.tablespace_id(+)
         AND tt.inc_use_size > 0
         AND f.name = h.tablespace_name
         AND h.CONTENTS IN ('PERMANENT')
ORDER BY f.name, tt.rtime
/

PROMPT "RMAN JOB LAST 50"

COLUMN backup_name           FORMAT a20    HEADING 'Backup Name'          ENTMAP off
COLUMN start_time            FORMAT a20    HEADING 'Start Time'           ENTMAP off
COLUMN elapsed_time          FORMAT a20    HEADING 'Elapsed Time'         ENTMAP off
COLUMN status                FORMAT a15    HEADING 'Status'               ENTMAP off
COLUMN input_type            FORMAT a10     HEADING 'Input Type'           ENTMAP off
COLUMN output_device_type    FORMAT a10     HEADING 'Output Devices'       ENTMAP off

SELECT R.COMMAND_ID BACKUP_NAME,
       TO_CHAR (R.START_TIME, 'mm/dd/yyyy HH24:MI:SS') START_TIME,
       R.TIME_TAKEN_DISPLAY ELAPSED_TIME,
       DECODE (R.STATUS,
               'COMPLETED', R.STATUS,
               'RUNNING', R.STATUS,
               'FAILED', R.STATUS,
               R.STATUS)
          STATUS,
       R.INPUT_TYPE INPUT_TYPE,
       R.OUTPUT_DEVICE_TYPE OUTPUT_DEVICE_TYPE
  FROM (  SELECT COMMAND_ID,
                 START_TIME,
                 TIME_TAKEN_DISPLAY,
                 STATUS,
                 INPUT_TYPE,
                 OUTPUT_DEVICE_TYPE,
                 INPUT_BYTES_DISPLAY,
                 OUTPUT_BYTES_DISPLAY,
                 OUTPUT_BYTES_PER_SEC_DISPLAY
            FROM V$RMAN_BACKUP_JOB_DETAILS
        ORDER BY START_TIME DESC) R
 WHERE ROWNUM < 50;

PROMPT "RMAN JOBS FAILED"
SELECT R.COMMAND_ID BACKUP_NAME,
       TO_CHAR (R.START_TIME, 'mm/dd/yyyy HH24:MI:SS') START_TIME,
       R.TIME_TAKEN_DISPLAY ELAPSED_TIME,
       DECODE (R.STATUS,
               'COMPLETED', R.STATUS,
               'RUNNING', R.STATUS,
               'FAILED', R.STATUS,
               R.STATUS)
          STATUS,
       R.INPUT_TYPE INPUT_TYPE,
       R.OUTPUT_DEVICE_TYPE OUTPUT_DEVICE_TYPE
  FROM (  SELECT COMMAND_ID,
                 START_TIME,
                 TIME_TAKEN_DISPLAY,
                 STATUS,
                 INPUT_TYPE,
                 OUTPUT_DEVICE_TYPE,
                 INPUT_BYTES_DISPLAY,
                 OUTPUT_BYTES_DISPLAY,
                 OUTPUT_BYTES_PER_SEC_DISPLAY
            FROM V$RMAN_BACKUP_JOB_DETAILS
           WHERE STATUS NOT IN ('COMPLETED') AND START_TIME > SYSDATE - 30
        ORDER BY START_TIME DESC) R
/

  SELECT inst_id, status, COUNT (*)
    FROM gv$session
GROUP BY inst_id, status
/

PROMPT "2PC"
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
 WHERE a.local_tran_id = b.local_tran_id
/

PROMPT "SYS SYSTEM OBJECT STATUS (NOT VALID)"
  SELECT owner, status, COUNT (*)
    FROM dba_objects
   WHERE owner IN ('SYS', 'SYSTEM') AND status NOT IN ('VALID')
GROUP BY owner, status
/

COL TABLESPACE_NAME HEADING 'TABLESPACENAME' FOR a20
PROMPT "DATAFILE STATUS (NOT AVALIABLE) OR AUTOEXTENSIBLE (NOT NO)"
SELECT tablespace_name,
       file_id,
       status,
       TRUNC (bytes / 1024 / 1024) bytes_m,
       AUTOEXTENSIBLE
  FROM dba_data_files
 WHERE status NOT IN ('AVAILABLE') OR AUTOEXTENSIBLE not in ('NO')
/

PROMPT "LOGFILE STATUS"

SELECT a.group#,
       b.thread#,
       b.status,
       a.TYPE,
       ROUND (bytes / 1024 / 1024) bytes
  FROM v$logfile a, v$log b
 WHERE a.group# = b.group#
UNION ALL
SELECT a.group#,
       b.thread#,
       b.status,
       a.TYPE,
       bytes / 1024 / 1024
  FROM v$logfile a, v$standby_log b
 WHERE a.group# = b.group#
ORDER BY thread#, group#
/

col process for a7 heading 'PROCESS'
col pid for a10 heading 'OS PID'
col status for a15 heading 'PROCESS_STATUS'
col client_process for a10 heading 'CLIENT|PROCESS'
col client_pid for a10 heading 'CLIENT|PID'
col g_t for a5 heading 'GROUP|THREAD'
col blocks for 999999999
col block# for 999999999
PROMPT "DG STATUS "
SELECT a.process,
       a.status,
       a.group# || '.' || a.thread# g_t,
       a.sequence#,
       a.block#,
       a.blocks
  FROM v$managed_standby a
 WHERE status NOT IN ('IDLE', 'CLOSING')
/

PROMPT "DISKGROUP SPACE "
COLUMN group_name             FORMAT a25           HEAD 'Disk Group|Name'
COLUMN sector_size            FORMAT 99,999        HEAD 'Sector|Size'
COLUMN block_size             FORMAT 99,999        HEAD 'Block|Size'
COLUMN allocation_unit_size   FORMAT 999,999,999   HEAD 'Allocation|Unit Size'
COLUMN state                  FORMAT a11           HEAD 'State'
COLUMN type                   FORMAT a6            HEAD 'Type'
COLUMN total_mb               FORMAT 999,999,999   HEAD 'Total Size (MB)'
column free_mb 		     format 999,999,999 heading 'Free Size (MB)'
COLUMN used_mb                FORMAT 999,999,999   HEAD 'Used Size (MB)'
COLUMN pct_used               FORMAT 999.99        HEAD 'Pct. Used'
  SELECT name group_name,
         state state,
         TYPE TYPE,
         total_mb total_mb,
         free_mb free_mb,
         (total_mb - free_mb) used_mb,
         ROUND ( (1 - (free_mb / total_mb)) * 100, 2) pct_used
    FROM v$asm_diskgroup
   WHERE total_mb != 0
ORDER BY name
/


PROMPT "RECOVERY FILE DEST"
 col reclaimable for a20
 COL used for a20
 COL QUOTA FOR A20
 COL NAME FOR A30
col used1 for 99999 heading 'USED%';
SELECT substr(name, 1, 30) name, round(space_limit/1024/1024)||'M' AS quota,
       round(space_used/1024/1024)||'M'        AS used,round(100*space_used/space_limit) used1,
       round(space_reclaimable/1024/1024)||'M' AS reclaimable,
        number_of_files   AS files
  FROM  v$recovery_file_dest 
/

