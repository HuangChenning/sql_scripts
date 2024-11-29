set echo off
set linesize 20000 verify off heading on
set pagesize 999
set numwidth 14
set numformat 999G999G999G990
col set_count for 9999 heading 'SET|COUNT'
col buffer_size for 99999999 heading 'BUFFER|SIZE'
col buffer_count for 99999 heading 'BUFFER|COUNT'
col agg for 9999 heading 'MAX|FILE|OPEN'
col io_count for 99999999 heading 'IO|COUNT(K)'
col devtype for a5 heading 'DEVICE|TYPE'
col elapsed_time for 99999999 heading 'ELAPSED|TIME(S)'
col total_bytes for 9999999 heading 'TOTAL|BYTES(M)'
COL BYTES for 999999 heading 'SO FAR|BYTES(M)'
col BUFFER_MEM for 999999999 heading 'BUFFER|MEM'
col filename for a20
col rate for 999999 heading 'RATE(M/S)'
col efficiency for 9999999999
col inst for a1 heading 'I'
col rate_with_create for 99999999 heading 'RATE_WITH|CREATE'
col eff for 99999999 heading 'EFF(M/S)'
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
column inst format a4
/* Formatted on 2014/7/3 15:53:41 (QP5 v5.240.12305.39446) */
undefine hours
WITH subq
     AS (SELECT 'ASYNC' sync,
                TO_CHAR (inst_id) inst,
                filename,
                open_time,
                close_time,
                TRUNC (elapsed_time / 100 / 60) elapsed_time,
                SUBSTR (device_type, 1, 10) devtype,
                set_count,
                set_stamp,
                maxopenfiles agg,
                buffer_size,
                buffer_count,
                buffer_size * buffer_count buffer_mem,
                io_count,
                TRUNC (total_bytes / 1024 / 1024) total_bytes,
                TRUNC (bytes / 1024 / 1024) bytes,
                  DECODE (
                     NVL (close_time, SYSDATE),
                     open_time, NULL,
                       io_count
                     * buffer_size
                     / ( (NVL (close_time, SYSDATE) - open_time) * 86400))
                * 1
                   rate,
                effective_bytes_per_second eff
           FROM gv$backup_async_io
          WHERE TYPE <> 'AGGREGATE' and open_time>(SYSDATE-NVL('&&HOURS',2))
         UNION ALL
         SELECT 'SYNC' sync,
                TO_CHAR (inst_id) inst,
                filename,
                open_time,
                close_time,
                TRUNC (elapsed_time / 100 / 60) elapsed_time,
                SUBSTR (device_type, 1, 10) devtype,
                set_count,
                set_stamp,
                maxopenfiles agg,
                buffer_size,
                buffer_count,
                buffer_size * buffer_count buffer_mem,
                io_count,
                TRUNC (total_bytes / 1024 / 1024) total_bytes,
                TRUNC (bytes / 1024 / 1024) bytes,
                  DECODE (
                     NVL (close_time, SYSDATE),
                     open_time, NULL,
                       io_count
                     * buffer_size
                     / ( (NVL (close_time, SYSDATE) - open_time) * 86400))
                * 1
                   rate,
                effective_bytes_per_second eff
           FROM gv$backup_sync_io 
          WHERE TYPE <> 'AGGREGATE'  and open_time>(SYSDATE-NVL('&&HOURS',2)))
  SELECT subq.sync,
         subq.inst,
         SUBSTR (subq.filename, -20, 20) filename,
            TO_CHAR (open_time, 'yyyy-mm-dd hh24:mi')
         || '.'
         || TO_CHAR (close_time, 'dd hh24:mi')
            open_close,
         elapsed_time,
         devtype,
         set_count,
         set_stamp,
         agg,
         buffer_size,
         buffer_count,
         io_count/1000 io_count,
         total_bytes,
         bytes,
         trunc(rate/1024/1024) rate,
         trunc(eff/1024/1024) eff,
           io_count
         * buffer_size
         / ( (NVL (close_time, SYSDATE) - open_time) * 86400 + agg)
         * 1
            rate_with_create,
         DECODE (buffer_mem, 0, NULL, rate / buffer_mem) * 1000 efficiency
    FROM subq
ORDER BY open_time;
undefine hours