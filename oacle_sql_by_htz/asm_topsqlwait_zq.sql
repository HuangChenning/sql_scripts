--------------------------------------------------------------------------------
--
-- File name:   ash_topsqlwait.sql
-- Author:      zhangqiao
-- Copyright:   zhangqiaoc@olm.com.cn
--
--------------------------------------------------------------------------------

set linesize 130
set pagesize 999
undefine BEGIN
undefine DURATION
undefine SQLID
col wait_class for a30

SELECT EVENT, sum(cnt) TOTAL, WAIT_CLASS
 FROM (SELECT DECODE(SESSION_STATE,
                     'ON CPU',
                     DECODE(SESSION_TYPE, 'BACKGROUND', 'BCPU', 'CPU'),
                     EVENT) EVENT,
              REPLACE(TRANSLATE(DECODE(SESSION_STATE,
                                       'ON CPU',
                                       DECODE(SESSION_TYPE,
                                              'BACKGROUND',
                                              'BCPU',
                                              'CPU'),
                                       WAIT_CLASS),
                                ' $',
                                '____'),
                      '/') WAIT_CLASS,1 cnt
         FROM GV$ACTIVE_SESSION_HISTORY
        WHERE sql_id='&&SQLID'
           and SAMPLE_TIME >=
               sysdate-&&BEGIN/24
           AND SAMPLE_TIME <=
               sysdate-(&&BEGIN-&&DURATION)/24
       UNION ALL
       SELECT DECODE(SESSION_STATE,
                     'ON CPU',
                     DECODE(SESSION_TYPE, 'BACKGROUND', 'BCPU', 'CPU'),
                     EVENT) EVENT,
              REPLACE(TRANSLATE(DECODE(SESSION_STATE,
                                       'ON CPU',
                                       DECODE(SESSION_TYPE,
                                              'BACKGROUND',
                                              'BCPU',
                                              'CPU'),
                                       WAIT_CLASS),
                                ' $',
                                '____'),
                      '/') WAIT_CLASS,10 cnt
         FROM DBA_HIST_ACTIVE_SESS_HISTORY
        WHERE sql_id='&&SQLID'
           AND SAMPLE_TIME >=
               sysdate-&&BEGIN/24
           AND SAMPLE_TIME <=
               sysdate-(&&BEGIN-&&DURATION)/24
       )
GROUP BY EVENT, WAIT_CLASS
ORDER BY TOTAL DESC;

undefine SQLID
undefine BEGIN
undefine DURATION

