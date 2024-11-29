store set sqlplusset replace
set lines 170
col sid format 9999
col serial# noprint format 9999
col event format a19
col blocking_sid heading "BLOCKING_SID_MUTEX" format 9999
col shared_refcount heading "RFC" format 99
col location_id heading "LOCATION_ID" format 99
col sleeps  noprint format 99999
col mutex_object format a30
col count format 999
col wtime format 9999999
set wrap off
set pagesize 3000
 
SELECT SID,
       wait_time wtime,
       event,
       p1 idn,
       FLOOR(p2 / POWER(2, 4 * ws)) blocking_sid,
       MOD(p2, POWER(2, 4 * ws)) shared_refcount,
       FLOOR(p3 / POWER(2, 4 * ws)) location_id,
       MOD(p3, POWER(2, 4 * ws)) sleeps,
       substr(CASE
         WHEN (event LIKE 'library cache:%' AND p1 <= power(2, 17)) THEN
          'library cache bucket: ' || p1
         ELSE
          (SELECT kglnaobj
             FROM x$kglob
            WHERE kglnahsh = p1
              AND (kglhdadr = kglhdpar)
              and rownum = 1)
       END,1,30) mutex_object
  FROM (SELECT DECODE(INSTR(banner, '64'), 0, '4', '8') ws
          FROM v$version
         WHERE ROWNUM = 1) wordsize,
       v$session_wait_history
 WHERE p1text = 'idn';
 @sqlplusset
