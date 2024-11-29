define _GV_INST  = "2"
define _BLK_SIZE = 8192
set pagesize 50000 linesize 9999 arraysize 5000 headsep off verify off 
col inst_num   noprint new_value _GV_NUM
col inst       noprint new_value _GV_INST
select 
      count(*) inst_num
  from gv$instance where inst_id=decode(&&1,0,inst_id,1);
  
select 
      decode(&&1,0,'--','') inst
  from dual;
  
WITH SAMPLE AS
 (SELECT SNAP_ID,
         DECODE(STAT_NAME,
                'user commits',
                'transactions',
                'user rollbacks',
                'transactions',
                'consistent gets',
                'logical reads',
                'db block gets',
                'logical reads',
                'sorts (memory)',
                'sorts',
                'sorts (disk)',
                'sorts',
                STAT_NAME) NAME,
         VALUE
    FROM DBA_HIST_SYSSTAT
   WHERE STAT_NAME IN ('redo size',
                       'user commits',
                       'user rollbacks',
                       'logons cumulative',
                       'consistent gets',
                       'db block gets',
                       'db block changes',
                       'physical writes',
                       'physical reads',
                       'parse count (hard)',
                       'parse count (total)',
                       'user calls',
                       'execute count',
                       'sorts (memory)',
                       'sorts (disk)')
&_GV_INST AND INSTANCE_NUMBER = &1                     
  UNION ALL
  SELECT SNAP_ID, STAT_NAME NAME, VALUE
    FROM DBA_HIST_SYS_TIME_MODEL
   WHERE STAT_NAME IN ('DB time', 'DB CPU')
&_GV_INST AND INSTANCE_NUMBER = &1 
  UNION ALL
  SELECT SNAP_ID,
         'Estd Interconnect traffic' NAME,
         CASE
           WHEN stat_name IN ('gc cr blocks received',
                              'gc cr blocks served',
                              'gc current blocks received',
                              'gc current blocks served') THEN
            VALUE * &_BLK_SIZE
           ELSE
            VALUE * 200
         END
    FROM DBA_HIST_SYSSTAT
   WHERE STAT_NAME IN ('gc cr blocks received',
                       'gc cr blocks served',
                       'gc current blocks received',
                       'gc current blocks served',
                       'gcs messages sent',
                       'ges messages sent')
&_GV_INST AND INSTANCE_NUMBER = &1                       
  UNION ALL
  SELECT SNAP_ID, 'Estd Interconnect traffic' NAME, VALUE * 200
    FROM DBA_HIST_DLM_MISC
   WHERE NAME IN ('gcs msgs received', 'ges msgs received')
&_GV_INST AND INSTANCE_NUMBER = &1   
  ),
EVENT_SAMPLE AS
 (select snap_id,
         event name,
         DECODE(wtfg, 0, TO_NUMBER(NULL), tmfg / wtfg) / 1000 value
    from (SELECT e.snap_id,
                 e.event_name event,
                 CASE
                   WHEN e.total_waits_fg IS NOT NULL THEN
                    e.total_waits_fg - NVL(b.total_waits_fg, 0)
                   ELSE
                    (e.total_waits - NVL(b.total_waits, 0)) -
                    GREATEST(0,
                             (NVL(ebg.total_waits, 0) - NVL(bbg.total_waits, 0)))
                 END wtfg,
                 CASE
                   WHEN e.time_waited_micro_fg IS NOT NULL THEN
                    e.time_waited_micro_fg - NVL(b.time_waited_micro_fg, 0)
                   ELSE
                    (e.time_waited_micro - NVL(b.time_waited_micro, 0)) -
                    GREATEST(0,
                             (NVL(ebg.time_waited_micro, 0) -
                             NVL(bbg.time_waited_micro, 0)))
                 END tmfg
            FROM dba_hist_system_event     b,
                 dba_hist_system_event     e,
                 dba_hist_bg_event_summary bbg,
                 dba_hist_bg_event_summary ebg
           WHERE e.dbid = (SELECT dbid FROM v$database)
             AND e.dbid = b.dbid
             AND e.dbid = bbg.dbid
             and e.dbid = ebg.dbid
             AND e.instance_number = b.instance_number
             AND e.instance_number = ebg.instance_number
             AND e.instance_number = bbg.instance_number
             AND e.event_id = b.event_id
             AND e.event_id = ebg.event_id
             and e.snap_id = ebg.snap_id
             and b.snap_id = bbg.snap_id
             and e.snap_id = b.snap_id + 1
             AND e.event_id = bbg.event_id
             AND e.total_waits > NVL(b.total_waits, 0)
             AND e.wait_class <> 'Idle'
             and e.event_name in
                 ('db file scattered read', 'db file sequential read')
             &_GV_INST AND E.INSTANCE_NUMBER = &1
                 )
  ),
SNAPSHOT AS
 (SELECT DISTINCT SNAP_ID,
                  STARTUP_TIME STARTUP_TIME,
                  TRUNC(CAST(END_INTERVAL_TIME AS DATE), 'MI') END_TIME,
                  EXTRACT(HOUR FROM END_INTERVAL_TIME) HOUR,
                  TRUNC(TRUNC(SYSDATE) -
                        TRUNC(CAST(END_INTERVAL_TIME AS DATE))) DAY,
                  TO_CHAR(END_INTERVAL_TIME, 'D') DAY_OF_WEEK,
                  TRUNC((TRUNC(SYSDATE) + 7 - TO_CHAR(SYSDATE, 'D') -
                        TRUNC(CAST(END_INTERVAL_TIME AS DATE))) / 7) WEEK
    FROM (SELECT INSTANCE_NUMBER,
                 SNAP_ID,
                 CAST(MAX(STARTUP_TIME) OVER(PARTITION BY SNAP_ID) AS DATE) STARTUP_TIME,
                 COUNT(*) OVER(PARTITION BY SNAP_ID) CNT,
                 COUNT(DISTINCT INSTANCE_NUMBER) OVER() INSTS,
                 END_INTERVAL_TIME
            FROM DBA_HIST_SNAPSHOT)
   WHERE CNT = INSTS
     AND EXTRACT(MINUTE FROM END_INTERVAL_TIME) = 0)
SELECT END_TIME,
       ROUND(SUM(DECODE(NAME, 'DB time', PER_SECOND, 0)) / 1000000) AAS,
       ROUND(SUM(DECODE(NAME, 'DB CPU', PER_SECOND, 0)) / 1000000) CPU_AAS,
       ROUND(SUM(DECODE(NAME, 'redo size', PER_SECOND, 0)) / 1024) REDO_KB,
       ROUND(SUM(DECODE(NAME, 'logons cumulative', PER_SECOND, 0))) LOGON,
       ROUND(SUM(DECODE(NAME, 'logical reads', PER_SECOND, 0)) * 8 / 1024) LOG_READ_MB,
       ROUND(SUM(DECODE(NAME, 'db block changes', PER_SECOND, 0)) * 8 / 1024) BLK_CHANGE_MB,
       ROUND(SUM(DECODE(NAME, 'physical reads', PER_SECOND, 0)) * 8 / 1024) PHY_READ_MB,
       ROUND(SUM(DECODE(NAME, 'physical writes', PER_SECOND, 0)) * 8 / 1024) PHY_WRT_MB,
       ROUND(SUM(DECODE(NAME, 'parse count (total)', PER_SECOND, 0))) PARSE,
       ROUND(SUM(DECODE(NAME, 'user calls', PER_SECOND, 0))) UCALL,
       ROUND(SUM(DECODE(NAME, 'execute count', PER_SECOND, 0))) EXECNT,
       ROUND(SUM(DECODE(NAME, 'sorts', PER_SECOND, 0))) SORTS,
       ROUND(SUM(DECODE(NAME, 'transactions', PER_SECOND, 0))) TRANS,
       ROUND(SUM(DECODE(NAME, 'Estd Interconnect traffic', PER_SECOND, 0)) / 1024) ICONN_KB,
       ROUND(SUM(DECODE(NAME, 'db file scattered read', PER_SECOND)) / &&_GV_NUM, 2) M_AVG_MS,
       ROUND(SUM(DECODE(NAME, 'db file sequential read', PER_SECOND)) / &&_GV_NUM,2) S_AVG_MS
  FROM (SELECT TO_CHAR(END_TIME, 'YYYYMMDD HH24') END_TIME,
               NAME,
               VALUE / INTERVAL PER_SECOND
          FROM (SELECT SNAP_ID,
                       END_TIME,
                       (END_TIME -
                       (LAG(END_TIME)
                        OVER(PARTITION BY STARTUP_TIME, NAME ORDER BY SNAP_ID))) * 1440 * 60 INTERVAL,
                       (VALUE -
                       (LAG(VALUE)
                        OVER(PARTITION BY STARTUP_TIME, NAME ORDER BY SNAP_ID))) VALUE,
                       NAME,
                       STARTUP_TIME
                  FROM (SELECT S.SNAP_ID,
                               NAME,
                               STARTUP_TIME,
                               END_TIME,
                               SUM(VALUE) VALUE
                          FROM SAMPLE S, SNAPSHOT N
                         WHERE S.SNAP_ID = N.SNAP_ID
                           AND N.END_TIME > SYSDATE - 60
                         GROUP BY S.SNAP_ID, NAME, STARTUP_TIME, END_TIME))
         WHERE INTERVAL IS NOT NULL
        union all
        SELECT TO_CHAR(END_TIME, 'YYYYMMDD HH24') END_TIME,
               NAME,
               VALUE PER_SECOND
          FROM (SELECT S.SNAP_ID,
                       NAME,
                       STARTUP_TIME,
                       END_TIME,
                       SUM(VALUE) VALUE
                  FROM EVENT_SAMPLE S, SNAPSHOT N
                 WHERE S.SNAP_ID = N.SNAP_ID
                   AND N.END_TIME > SYSDATE - 60
                 GROUP BY S.SNAP_ID, NAME, STARTUP_TIME, END_TIME))
 GROUP BY END_TIME
 ORDER BY END_TIME
;
set headsep on