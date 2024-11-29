set echo off
set lines 300 pages 100 heading on verify off serveroutput on
col tablespace_name for a10 heading 'TABLESPACE'
col file_name for a60 
col efno for 9999 heading 'REAL|FNO'
col fno for 999
col rfno for 999
col bytes for 999999999  heading 'BYTES(M)'
col blocks for 999999999 heading 'BLOCKS'
col status for a10
col autoextend for a6 heading 'AUTO|EXTEND'
SELECT /*+ ordered use_nl(hc) */
      ts.name tablespace_name,
       v.fnnam file_name,
       tf.TFAFN efno,
       hc.ktfthctfno fno,
       DECODE (hc.ktfthccval, 0, hc.ktfthcfno, NULL) rfno,
       round(DECODE (hc.ktfthccval, 0, ts.blocksize * hc.ktfthcsz, NULL)/1024/1024) bytes,
       DECODE (hc.ktfthccval, 0, hc.ktfthcsz, NULL) blocks,
       DECODE (BITAND (tf.tfsta, 2),  0, 'OFFLINE',  2, 'ONLINE',  'UNKNOWN')
          status,
       DECODE (hc.ktfthccval, 0, DECODE (hc.ktfthcinc, 0, 'NO', 'YES'), NULL)
          autoextend
  FROM sys.x$kccfn v,
       sys.x$ktfthc hc,
       sys.ts$ ts,
       sys.x$kcctf tf
 WHERE     v.fntyp = 7
       AND v.fnnam IS NOT NULL
       AND v.fnfno = hc.ktfthctfno
       AND hc.ktfthctsn = ts.ts#
       AND v.fnfno = tf.tfnum
       AND tf.tffnh = v.fnnum
       AND tf.tfdup != 0
       AND BITAND (tf.tfsta, 32) <> 32
/