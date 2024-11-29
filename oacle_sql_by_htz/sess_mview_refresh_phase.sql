-- File Name : sess_mview_refresh_phase.sql
-- Purpose : 显示物化视图在刷新时的阶段.
-- Date : 2015/09/06
-- 认真就输、QQ:7343696
-- http://www.htz.pw
set echo off
set lines 200 pages 1000 verify off heading on
COLUMN "MVIEW BEING REFRESHED" FORMAT a30
COLUMN INSERTS FORMAT 9999999
COLUMN UPDATES FORMAT 9999999
COLUMN DELETES FORMAT 9999999

SELECT CURRMVOWNER_KNSTMVR || '.' || CURRMVNAME_KNSTMVR
          "MVIEW BEING REFRESHED",
       DECODE (REFTYPE_KNSTMVR,  1, 'FAST',  2, 'COMPLETE',  'UNKNOWN')
          REFTYPE,
       DECODE (GROUPSTATE_KNSTMVR,
               1, 'SETUP',
               2, 'INSTANTIATE',
               3, 'WRAPUP',
               'UNKNOWN')
          STATE,
       TOTAL_INSERTS_KNSTMVR INSERTS,
       TOTAL_UPDATES_KNSTMVR UPDATES,
       TOTAL_DELETES_KNSTMVR DELETES
  FROM X$KNSTMVR X
 WHERE     type_knst = 6
       AND EXISTS
              (SELECT 1
                 FROM gv$session s
                WHERE     s.sid = x.sid_knst
                      AND s.serial# = x.serial_knst
                      AND s.inst_id = x.inst_id);
set lines 78
set echo on
                      