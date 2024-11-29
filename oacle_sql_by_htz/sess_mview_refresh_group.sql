-- File Name : sess_mview_refresh_group.sql
-- Purpose : 显示当前物化视图刷新的组
-- Version : 1.0
-- Date : 2015/09/05
-- Modify Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
set echo off;
set pages 1000 lines 200 verify on heading on;
COLUMN rowner FORMAT a15
COLUMN rname FORMAT a15
COLUMN sid FORMAT 9999

SELECT username,
       l.inst_id,
       sid,
       rowner,
       rname
  FROM (  SELECT username,
                 l.INST_ID,
                 s.sid,
                 rc.rowner,
                 rc.rname,
                 COUNT (*)
            FROM gv$lock l,
                 dba_objects o,
                 gv$session s,
                 dba_refresh_children rc
           WHERE     l.INST_ID = s.INST_ID
                 AND o.object_id = l.id1
                 AND l.TYPE = 'JI'
                 AND l.lmode = 6
                 AND s.sid = l.sid
                 AND o.object_type = 'TABLE'
                 AND o.object_name = rc.name
                 AND o.owner = rc.owner
                 AND rc.TYPE = 'SNAPSHOT'
        GROUP BY username,
                 l.INST_ID,
                 s.sid,
                 rc.rowner,
                 rc.rname
          HAVING COUNT (*) =
                    (SELECT COUNT (*)
                       FROM dba_refresh_children
                      WHERE     rowner = rc.rowner
                            AND rname = rc.rname
                            AND TYPE = 'SNAPSHOT'));
set lines 78;