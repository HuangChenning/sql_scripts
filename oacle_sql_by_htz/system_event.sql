set lines 170
set pages 10000
set echo on 
column total_waits format  999999999
col event for a60


SELECT   event, total_waits,
         ROUND (time_waited_micro / 1000000) AS time_waited_secs,
         ROUND (time_waited_micro * 100 / 
            SUM (time_waited_micro) OVER (),2) AS pct_time,
            AVERAGE_WAIT
    FROM (SELECT event, total_waits, time_waited_micro,  AVERAGE_WAIT
            FROM v$system_event
           WHERE wait_class <> 'Idle'
          UNION
          SELECT stat_name, NULL, VALUE,null
            FROM v$sys_time_model
           WHERE stat_name IN ('DB CPU', 'background cpu time'))
ORDER BY 3 DESC; 


