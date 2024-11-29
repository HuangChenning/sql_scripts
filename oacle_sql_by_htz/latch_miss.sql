set echo off
set heading on
set pages 40
set lines 200
col parent_name for a40
col location for a50
col nwfail_count for 999999999 heading 'NOWAIT FAILD|COUNT'
col sleep_count for 999999999 heading 'SLEEP|COUNT'
col wtr_slp_count for 99999999 heading 'WAITER SLEEP|COUNT'
  SELECT parent_name,
         location,
         nwfail_count,
         sleep_count,
         wtr_slp_count,
         longhold_count
    FROM v$latch_misses
   WHERE     UPPER (parent_name) LIKE
                UPPER (NVL ('%&latch_name%', parent_name))
         AND sleep_count <> 0
ORDER BY parent_name, sleep_count
/
