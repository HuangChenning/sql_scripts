-- File Name : mview_register.sql
-- Purpose : 显示物化视图注册信息
-- Date : 2015/09/07
-- 认真就输、QQ:7343696
-- http://www.htz.pw
SET ECHO OFF;
SET LINES 2000 PAGES 1000 HEADING ON VERIFY OFF
COL o_n FOR a35 HEADING 'OWNER_TABLE_NAME'
col m_o_n for a35 heading 'MVIEW_SIZE|OWNER_TABLE_NAME'
COL mview_site FOR a20
COL refresh_method FOR a15 HEADING 'REFRESH|METHOD'
COL mview_id FOR 9999999 HEADING 'MVIEW|ID'
COL version FOR a30

undefine master_owner;
undefine table_name;
undefine mview_log_database_name;
break on o_n

SELECT s.MOWNER || '.' || s.MASTER o_n,
       s.SNAPID,
       nvl(a.owner,'UNREGISTER')||'.'||nvl(a.NAME,'UNREGISTER') m_o_n,
       NVL (a.mview_site, 'UNREGISTER') mview_site,
       NVL (a.refresh_method, 'UNREGISTER') refresh_method,
       NVL (a.version, 'UNREGISTER') version
  --       , query_txt
  FROM sys.slog$ s, dba_registered_mviews a
 WHERE     s.MOWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN')
       AND s.snapid = A.MVIEW_ID(+)
       AND s.MOWNER = NVL (UPPER ('&master_owner'), s.MOWNER)
       AND s.MASTER = NVL (UPPER ('&table_name'), s.MASTER)
/

undefine master_owner;
undefine table_name;
undefine mview_log_database_name;