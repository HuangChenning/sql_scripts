set echo off
set headin off
set lines 300 pages 10000 
SELECT /*+ ORDERED */
      '----------------------------------------'
       || '
Curent Time : '
       || SUBSTR (TO_CHAR (SYSDATE, 'dd-Mon-YYYY HH24.MI.SS'), 1, 22)
       || '
'
       || 'GTXID='
       || SUBSTR (g.K2GTITID_EXT, 1, 10)
       || '
'
       || 'Ascii GTXID='
       || g.K2GTITID_ORA
       || '
'
       || 'Branch= '
       || g.K2GTIBID
       || '
Client Process ID is '
       || SUBSTR (s.ksusepid, 1, 10)
       || '
running in machine : '
       || SUBSTR (s.ksusemnm, 1, 80)
       || '
  Local TX Id  ='
       || SUBSTR (t.KXIDUSN || '.' || t.kXIDSLT || '.' || t.kXIDSQN, 1, 10)
       || '
  Local Session SID.SERIAL ='
       || SUBSTR (s.indx, 1, 4)
       || '.'
       || s.ksuseser
       || '
  is : '
       || DECODE (
             BITAND (ksuseidl, 11),
             1, 'ACTIVE',
             0, DECODE (BITAND (ksuseflg, 4096), 0, 'INACTIVE', 'CACHED'),
             2, 'SNIPED',
             3, 'SNIPED',
             'KILLED')
       || ' and '
       || SUBSTR (STATE, 1, 9)
       || ' since '
       || TO_CHAR (SECONDS_IN_WAIT, '9999')
       || ' seconds'
       || '
  Wait Event is :'
       || '
  '
       || SUBSTR (event, 1, 30)
       || ' '
       || p1text
       || '='
       || p1
       || ','
       || p2text
       || '='
       || p2
       || ','
       || p3text
       || '='
       || p3
       || '
  Waited '
       || TO_CHAR (SEQ#, '99999')
       || ' times '
       || '
  Server for this session:'
       || DECODE (s.ksspatyp,
                  1, 'Dedicated Server',
                  2, 'Shared Server',
                  3, 'PSE',
                  'None')
          "Server"
  FROM x$k2gte g,
       x$ktcxb t,
       x$ksuse s,
       v$session_wait w
 -- where  g.K2GTeXCB =t.ktcxbxba <= use this if running Oracle7
 WHERE     g.K2GTDXCB = t.ktcxbxba  -- comment out if running Oracle8 or later
       AND g.K2GTDSES = t.ktcxbses
       AND s.addr = g.K2GTDSES
       AND w.sid = s.indx;
set heading on
