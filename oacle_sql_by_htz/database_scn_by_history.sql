set echo off
set pages 400 heading on lines 2000 num 20
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
 SELECT tim,
         gscn,
         ROUND (rate),
         ROUND ( (chk16kscn - gscn) / 24 / 3600 / 16 / 1024, 1) "Headroom Day"
    FROM (SELECT tim,
                 gscn,
                 rate,
                 (  (  (  (TO_NUMBER (TO_CHAR (tim, 'YYYY')) - 1988)
                        * 12
                        * 31
                        * 24
                        * 60
                        * 60)
                     + (  (TO_NUMBER (TO_CHAR (tim, 'MM')) - 1)
                        * 31
                        * 24
                        * 60
                        * 60)
                     + (  ( (TO_NUMBER (TO_CHAR (tim, 'DD')) - 1))
                        * 24
                        * 60
                        * 60)
                     + (TO_NUMBER (TO_CHAR (tim, 'HH24')) * 60 * 60)
                     + (TO_NUMBER (TO_CHAR (tim, 'MI')) * 60)
                     + (TO_NUMBER (TO_CHAR (tim, 'SS'))))
                  * (16 * 1024))
                    chk16kscn
            FROM (SELECT FIRST_TIME tim,
                         FIRST_CHANGE# gscn,
                         (  (NEXT_CHANGE# - FIRST_CHANGE#)
                          / (  DECODE (
                                  (  LEAD (
                                        FIRST_TIME)
                                     OVER (PARTITION BY THREAD#
                                           ORDER BY FIRST_TIME)
                                   - FIRST_TIME),
                                  0, 1,
                                  (  LEAD (
                                        FIRST_TIME)
                                     OVER (PARTITION BY THREAD#
                                           ORDER BY FIRST_TIME)
                                   - FIRST_TIME))
                             * 24
                             * 60
                             * 60))
                            rate
                    FROM v$log_history))
ORDER BY 1, 2;