set echo off
set headin off
set lines 300 pages 10000 
    SET PAGESIZE 1000
    PROMPT +++ In memory transaction +++ 

SELECT /*+ ORDERED */
      '----------------------------------------'
       || '
    Curent Time : '
       || TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24.MI.SS')
       || '
    '
       || 'TX start_time: '
       || t.KTCXBSTM
       || '
    '
       || 'FORMATID: '
       || g.K2GTIFMT
       || '
    '
       || 'GTXID: '
       || g.K2GTITID_EXT
       || '
    '
       || 'Branch: '
       || g.K2GTIBID
       || '
    Local_Tran_Id ='
       || SUBSTR (t.KXIDUSN || '.' || t.kXIDSLT || '.' || t.kXIDSQN, 1, 15)
       || '
    '
       || 'KTUXESTA='
       || x.KTUXESTA
       || '
    '
       || 'KTUXEDFL='
       || x.KTUXECFL
       || '
    Lock_Info: ID1: '
       || ( (t.kXIDUSN * 64 * 1024) + t.kXIDSLT)
       || ' ID2: '
       || t.kXIDSQN
          XA_transaction_INFO 
  FROM x$k2gte g, x$ktcxb t, x$ktuxe x
 WHERE     g.K2GTDXCB = t.ktcxbxba
       AND x.KTUXEUSN = t.KXIDUSN(+)
       AND x.KTUXESLT = t.kXIDSLT(+)
       AND x.KTUXESQN = t.kXIDSQN(+);

    PROMPT +++ Timed out, prepared XA transactions +++ 

SELECT global_tran_fmt,
       global_foreign_id,
       branch_id,
       state,
       tran.local_tran_id 
  FROM sys.pending_trans$ tran, sys.pending_sessions$ sess
 WHERE     tran.local_tran_id = sess.local_tran_id
       AND tran.state = 'prepared'
       AND DBMS_UTILITY.is_bit_set (tran.session_vector, sess.session_id) = 1
       /