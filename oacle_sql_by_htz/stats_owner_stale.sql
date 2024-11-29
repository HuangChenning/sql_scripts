/* Formatted on 2013/12/5 23:08:06 (QP5 v5.240.12305.39476) */
set serveroutput on
set verify off
DECLARE
   CURSOR STALE_TABLE
   IS
      SELECT OWNER,
             SEGMENT_NAME,
             CASE
                WHEN SIZE_GB < 0.5 THEN 30
                WHEN SIZE_GB >= 0.5 AND SIZE_GB < 1 THEN 20
                WHEN SIZE_GB >= 1 AND SIZE_GB < 5 THEN 10
                WHEN SIZE_GB >= 5 AND SIZE_GB < 10 THEN 5
                WHEN SIZE_GB >= 10 THEN 1
             END
                AS PERCENT,
             8 AS DEGREE
        FROM (  SELECT OWNER,
                       SEGMENT_NAME,
                       SUM (BYTES / 1024 / 1024 / 1024) SIZE_GB
                  FROM DBA_SEGMENTS
                 WHERE     OWNER = UPPER ('&&owner')
                       AND SEGMENT_NAME IN
                              (SELECT /*+ UNNEST */
                                     DISTINCT TABLE_NAME
                                 FROM DBA_TAB_STATISTICS
                                WHERE     (   LAST_ANALYZED IS NULL
                                           OR STALE_STATS = 'YES')
                                      AND OWNER = UPPER ('&&owner'))
              GROUP BY OWNER, SEGMENT_NAME);

BEGIN
   DBMS_STATS.FLUSH_DATABASE_MONITORING_INFO;

   FOR STALE IN STALE_TABLE
   LOOP
      DBMS_STATS.GATHER_TABLE_STATS (
         OWNNAME            => STALE.OWNER,
         TABNAME            => STALE.SEGMENT_NAME,
         ESTIMATE_PERCENT   => STALE.PERCENT,
         METHOD_OPT         => 'for all columns size repeat',
         DEGREE             => 8,
         GRANULARITY        => 'ALL',
         CASCADE            => TRUE);
      DBMS_OUTPUT.PUT_LINE('table '||STALE.OWNER||'.'||STALE.SEGMENT_NAME||'.'||STALE.PERCENT||' is success');
   END LOOP;
END;
/
undefine owner;