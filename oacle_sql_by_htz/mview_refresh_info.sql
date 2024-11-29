set echo off
set lines 200 pages 4000 verify off heading on;
col mview for a35 heading 'MVIEW_OWNER_NAME'
col master_link for a40 heading 'DB_LINK'
col refresh for a25 heading 'REFRESH_METHOD|LAST_REF_MET'
col BEHIND for 9999999 heading 'INTERVAL|LAST_SUSS(M)'
col next_date for a11
col succ_interval for 9999999 heading 'SUSS|INTERVAL'
col interval for a30
col broken for a6 heading 'BROKEN'
undefine owner;
undefine mviewname;
SELECT
--    int.rowner "rgroup owner",
--    int.rname "refresh group",
 mv.owner || '.' || mv.mview_name mview,
 mv.master_link,
 mv.REFRESH_METHOD || '.' || mv.last_refresh_type refresh,
 round(1440 * (sysdate - mv.last_refresh_date)) behind/*与上次成功同步的时间间隔*/,
 to_char(int.next_date, 'mm-dd hh24:mi') next_date/*下一次同步的时间*/,
 round(int.interval1 * 1440) succ_interval/*上2次成功同步的隔间时间*/,
 int.interval/*自动同步的间隔*/,
 int.broken
  FROM dba_mviews mv,
       (SELECT child.owner,
       child.name,
       child.rowner,
       child.rname,
       job.next_date,
       job.next_date - job.last_date AS interval1,
       job.interval,
       job.broken
  FROM dba_refresh REF, dba_refresh_children child, dba_jobs job
 WHERE REF.rname = child.rname
   and ref.rowner = child.owner
   AND ref.job = job.job) int
 WHERE mv.owner = int.owner(+)
   AND mv.mview_name = int.name(+)
   and mv.owner not in ('SYSMAN')
   and mv.owner = nvl(upper('&mviewowner'), mv.owner)
   and mv.mview_name = nvl(upper('&mviewname'), mv.mview_name)
   and mv.mview_name not in ('MGMT_ECM_MD_ALL_TBL_COLUMNS')
 ORDER BY (sysdate - mv.last_refresh_date) * 1440 DESC,
          mv.owner,
          mv.mview_name;
undefine owner;
undefine mviewname;

