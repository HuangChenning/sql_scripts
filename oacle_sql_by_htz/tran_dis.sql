set echo off
set lines 300 pages 10000 
column origin format a13
column GTXID format a35
column LSESSION format a10
column s format a1
column waiting format a15
/* Formatted on 2014/6/19 12:40:25 (QP5 v5.240.12305.39446) */
SELECT /*+ ORDERED */
      SUBSTR (s.ksusemnm, 1, 10) || '-' || SUBSTR (s.ksusepid, 1, 10)
          "ORIGIN",
       SUBSTR (g.K2GTITID_ORA, 1, 35) "GTXID",
       SUBSTR (s.indx, 1, 4) || '.' || SUBSTR (s.ksuseser, 1, 5) "LSESSION",
       SUBSTR (
          DECODE (
             BITAND (ksuseidl, 11),
             1, 'ACTIVE',
             0, DECODE (BITAND (ksuseflg, 4096), 0, 'INACTIVE', 'CACHED'),
             2, 'SNIPED',
             3, 'SNIPED',
             'KILLED'),
          1,
          1)
          "S",
       SUBSTR (event, 1, 10) "WAITING"
  FROM x$k2gte g,
       x$ktcxb t,
       x$ksuse s,
       v$session_wait w
 -- where  g.K2GTeXCB =t.ktcxbxba <= use this if running in Oracle7
 WHERE     g.K2GTDXCB = t.ktcxbxba -- comment out if running in Oracle8 or later
       AND g.K2GTDSES = t.ktcxbses
       AND s.addr = g.K2GTDSES
       AND w.sid = s.indx
/
set echo on