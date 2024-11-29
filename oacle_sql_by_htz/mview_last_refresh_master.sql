-- File Name : mview_last_refresh_master.sql
-- Purpose : 显示物化视图日志刷新时间
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
SET ECHO OFF;
SET LINES 2000 PAGES 1000 HEADING ON VERIFY OFF
ALTER SESSION SET nls_date_format='yyyy-mm-dd hh24:mi:ss';
COL o_n FOR a35 HEADING 'OWNER_TABLE_NAME'
col m_o_n for a35 heading 'MVIEW_SIZE|OWNER_TABLE_NAME'
COLUMN logname FORMAT a35
COLUMN youngest FORMAT a19
COLUMN "last refreshed" FORMAT a19
COLUMN "last refreshed" for a19 HEADING "last|refreshed"
COL mview_site FOR a20
COLUMN "mview id" FORMAT 99999
COLUMN "mview id" HEADING "mview|id"
COLUMN oldest_rowid FORMAT a19
COLUMN oldest_pk FORMAT a19
break on owner on table_name;
undefine owner;
undefine table_name;
SELECT m.mowner||'.'||m.master o_n,
       nvl(a.owner,'UNREGISTER')||'.'||nvl(a.NAME,'UNREGISTER') m_o_n,
       m.LOG logname,
       NVL (a.mview_site, 'UNREGISTER') mview_site,
       m.youngest youngest,
       s.snapid "mview id",
       s.snaptime "last refreshed",
       oldest_pk oldest_pk,
       oldest Oldest_ROWID
  FROM sys.mlog$ m, sys.slog$ s,dba_registered_mviews a
 WHERE     s.mowner(+) = m.mowner
       AND s.master(+) = m.master
       AND s.snapid = A.MVIEW_ID(+)
       AND m.mowner = NVL (UPPER ('&owner'), m.mowner)
       AND m.master = NVL (UPPER ('&table_name'), m.master)
       AND a.mview_site = NVL (UPPER ('&mview_dbname'),a.mview_site)
/
undefine owner;
undefine table_name;