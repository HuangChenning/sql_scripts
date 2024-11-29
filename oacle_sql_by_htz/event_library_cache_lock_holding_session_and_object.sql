set echo off
set lines 200 pages 2000 heading on verify off
col inst_id for 99 heading 'I'
col sid for 9999999
col username for a20
col terminal for a30
col program for a30
SELECT s.inst_id,
       s.SID,
       s.USERNAME,
       s.TERMINAL,
       s.PROGRAM,
       l.kgllksnm "Obj Name",
       sq.sql_id
  FROM GV$SESSION s, GV$SQL sq, x$kgllk l
 WHERE     s.INST_ID = sq.INST_ID
       AND s.SQL_HASH_VALUE = sq.HASH_VALUE
       AND s.SQL_ADDRESS = sq.ADDRESS
       AND l.inst_id = s.inst_id
       AND l.kgllksnm = s.sid
       AND s.SADDR IN
              (SELECT KGLLKSES
                 FROM X$KGLLK LOCK_A
                WHERE     KGLLKREQ = 0
                      AND EXISTS
                             (SELECT LOCK_B.KGLLKHDL
                                FROM X$KGLLK LOCK_B
                               WHERE     KGLLKSNM IN
                                            (SELECT sid
                                               FROM v$session_wait
                                              WHERE     wait_time = 0
                                                    AND event =
                                                           'library cache lock')
                                     AND LOCK_A.KGLLKHDL = LOCK_B.KGLLKHDL
                                     AND KGLLKREQ > 0));