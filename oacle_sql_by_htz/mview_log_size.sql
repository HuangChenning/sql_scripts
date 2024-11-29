-- File Name : mview_log_size.sql
-- Purpose : 显示物化视图日志的大小
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
SET ECHO OFF;
SET LINES 2000 PAGES 1000 HEADING ON VERIFY OFF
col owner for a15
col segment_name for a35
col size for 999999999
SELECT owner, segment_name, bytes / 1024 / 1024 AS "SIZE"
    FROM dba_segments a
   WHERE (a.owner, a.segment_name) IN
            (SELECT log_owner, log_table FROM dba_mview_logs)
ORDER BY 3;
