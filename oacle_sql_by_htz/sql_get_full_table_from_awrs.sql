set lines 200
col sql_id                      for a18
col sql_count                   for 99999
col eecutions                   for 999999999
col buffer_gets                 for 999999999
col avg_get                     for 9999999
col object_owner                for a15
col object_name                 for a30
col filter_predicates           for a100
col parent_access               for a30
col parent_join                 for a20

SET LINES 200
COL sql_id                      FOR a18
COL sql_count                   FOR 99999
COL exec                        FOR 999999999
COL disk_read                   FOR 999999999999
COL buffer_gets                 FOR 999999999999
COL io_wait                     FOR 9999999999999
COL pread                       FOR 9999999999999
COL object_owner                FOR a15
COL object_name                 FOR a30
COL filter_predicates           FOR a100
COL parent_access               FOR a30
COL parent_join                 FOR a20

WITH tt
     AS (SELECT sql_id,
                plan_hash_value,
                force_matching_signature,
                sql_count,
                executions,
                buffer_gets,
                TRUNC (buffer_gets / DECODE (executions, 0, 1, executions))
                   avg_buffer_gets,
                disk_reads,
                TRUNC (disk_reads / DECODE (executions, 0, 1, executions))
                   avg_disk_reads,
                iowait_time,
                TRUNC (iowait_time / DECODE (executions, 0, 1, executions))
                   avg_user_id_wait_time,
                physical_read_bytes,
                TRUNC (
                     physical_read_bytes
                   / DECODE (executions, 0, 1, executions))
                   avg_physical_read_bytes
           FROM (  SELECT b.sql_id,
                          b.plan_hash_value,
                          b.force_matching_signature,
                          COUNT (*)                       sql_count,
                          SUM (b.executions_delta)        executions,
                          SUM (b.buffer_gets_delta)       buffer_gets,
                          SUM (b.disk_reads_delta)        disk_reads,
                          SUM (b.iowait_delta)            iowait_time,
                          SUM (b.physical_read_bytes_delta) physical_read_bytes,
                          SUM (b.clwait_delta)            clwait_time,
                          SUM (elapsed_time_delta)        elapsed_time,
                          SUM (cpu_time_delta)            cpu_time
                     FROM dba_hist_sqlstat b
                    WHERE     b.force_matching_signature <> 0
                          AND parsing_schema_name NOT IN
                                 ('SYS', 'SYSTEM', 'SYSMAN')
                 GROUP BY b.sql_id,
                          b.plan_hash_value,
                          b.force_matching_signature
                 ORDER BY sql_id)
          WHERE executions > 10),
     bb
     AS (SELECT c.sql_id,
                c.plan_hash_value,
                c.object_owner,
                c.object_name,
                c.id,
                c.partition_start,
                c.operation,
                c.options,
                NVL (
                   (SELECT TRIM (b.FILTER_PREDICATES)
                      FROM v$sql_plan b
                     WHERE     c.sql_id = b.sql_id
                           AND c.PARENT_ID = b.id
                           AND c.PLAN_HASH_VALUE = b.plan_hash_value
                           AND ROWNUM = 1),
                   'NOT FIND')
                   FILTER_PREDICATES,
                NVL (
                   (SELECT TRIM (b.ACCESS_PREDICATES)
                      FROM v$sql_plan b
                     WHERE     c.sql_id = b.sql_id
                           AND c.PARENT_ID = b.id
                           AND c.PLAN_HASH_VALUE = b.plan_hash_value
                           AND ROWNUM = 1),
                   'NOT FIND')
                   parent_access,
                NVL (
                   (SELECT TRIM (b.OPERATION)
                      FROM v$sql_plan b
                     WHERE     c.sql_id = b.sql_id
                           AND c.PARENT_ID = b.id
                           AND c.PLAN_HASH_VALUE = b.plan_hash_value
                           AND ROWNUM = 1),
                   'NOT FIND')
                   parent_join
           FROM dba_hist_sql_plan c
          WHERE     c.operation = 'TABLE ACCESS'
                AND c.options = 'FULL'
                AND object_owner NOT IN ('SYS', 'SYSTEM', 'SYSMAN'))
  SELECT sql_id,
         plan_hash_value,
         object_owner,
         object_name,
         id,
         executions            exec,
         avg_buffer_gets       buffer_get,
         avg_disk_reads        disk_read,
         avg_user_id_wait_time io_wait,
         avg_physical_read_bytes pread,
         FILTER_PREDICATES,
         parent_access,
         sql_text
    FROM (SELECT bb.sql_id,
                 bb.plan_hash_value,
                 bb.object_owner,
                 bb.object_name,
                 bb.id,
                 bb.FILTER_PREDICATES,
                 bb.operation,
                 bb.options,
                 tt.force_matching_signature,
                 tt.sql_count,
                 tt.executions,
                 tt.buffer_gets,
                 tt.avg_buffer_gets,
                 bb.parent_access,
                 bb.parent_join,
                 tt.disk_reads,
                 tt.avg_disk_reads,
                 tt.avg_user_id_wait_time,
                 tt.avg_physical_read_bytes,
                 TO_CHAR (SUBSTR (d.sql_text, 1, 1000)) sql_text,
                 ROW_NUMBER ()
                 OVER (PARTITION BY tt.plan_hash_value
                       ORDER BY tt.plan_hash_value)
                    sql_order
            FROM tt, bb, dba_hist_sqltext d
           WHERE     tt.sql_id = bb.sql_id
                 AND tt.plan_hash_value = bb.plan_hash_value
                 AND tt.sql_id = d.sql_id) cc
   WHERE sql_order = 1
ORDER BY avg_buffer_gets, id
/


