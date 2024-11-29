set echo off
set lines 2000 serveroutput on verify off
undefine sqlid;
/* Formatted on 2015/6/2 0:07:25 (QP5 v5.240.12305.39446) */
DECLARE
   l_free_blks            NUMBER;
   l_total_blocks         NUMBER;
   l_total_bytes          NUMBER;
   l_unused_blocks        NUMBER;
   l_unused_bytes         NUMBER;
   l_LastUsedExtFileId    NUMBER;
   l_LastUsedExtBlockId   NUMBER;
   l_LAST_USED_BLOCK      NUMBER;
   l_segment_space_mgmt   VARCHAR2 (255);
   l_unformatted_blocks   NUMBER;
   l_unformatted_bytes    NUMBER;
   l_fs1_blocks           NUMBER;
   l_fs1_bytes            NUMBER;
   l_fs2_blocks           NUMBER;
   l_fs2_bytes            NUMBER;
   l_fs3_blocks           NUMBER;
   l_fs3_bytes            NUMBER;
   l_fs4_blocks           NUMBER;
   l_fs4_bytes            NUMBER;
   l_full_blocks          NUMBER;
   l_full_bytes           NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE (
         RPAD ('OWNER', 20)
      || RPAD ('OBJECT_NAME', 40)
      || RPAD ('PARTITION_NAME', 20, ' ')
      || RPAD ('OBJECT_TYPE', 20)
      || RPAD ('TOTAL_FULL', 15)
      || RPAD ('FREE_0~25%', 15)
      || RPAD ('FREE_25~50%', 15)
      || RPAD ('FREE_50~75%', 15)
      || RPAD ('FREE_75~100%', 15)
      || RPAD ('UNFORMATTED', 15));

   FOR x
      IN (WITH t
               AS (SELECT /*+ materialize */
                         DISTINCT OBJECT_OWNER, OBJECT_NAME
                     FROM (SELECT OBJECT_OWNER, OBJECT_NAME
                             FROM V$SQL_PLAN
                            WHERE     SQL_ID = '&&sqlid'
                                  AND OBJECT_NAME IS NOT NULL
                           UNION ALL
                           SELECT OBJECT_OWNER, OBJECT_NAME
                             FROM DBA_HIST_SQL_PLAN
                            WHERE     SQL_ID = '&&sqlid'
                                  AND OBJECT_NAME IS NOT NULL))
          SELECT DISTINCT owner,
                          segment_name object_name,
                          partition_name,
                          segment_type object_type
            FROM dba_segments a
           WHERE     (a.owner, a.segment_name) IN
                        (SELECT object_owner, object_name FROM t)
                 AND a.segment_type = 'TABLE')
   LOOP
      DBMS_SPACE.space_usage (x.owner,
                              x.object_name,
                              x.object_type,
                              l_unformatted_blocks,
                              l_unformatted_bytes,
                              l_fs1_blocks,
                              l_fs1_bytes,
                              l_fs2_blocks,
                              l_fs2_bytes,
                              l_fs3_blocks,
                              l_fs3_bytes,
                              l_fs4_blocks,
                              l_fs4_bytes,
                              l_full_blocks,
                              l_full_bytes,
                              x.partition_name);
      DBMS_OUTPUT.put_line (
            RPAD (x.owner, 20)
         || RPAD (x.object_name, 40)
         || RPAD (NVL (x.partition_name, ' '), 20, ' ')
         || RPAD (x.object_type, 20)
         || RPAD (l_full_blocks, 15)
         || RPAD (l_fs1_blocks, 15)
         || RPAD (l_fs2_blocks, 15)
         || RPAD (l_fs3_blocks, 15)
         || RPAD (l_fs4_blocks, 15)
         || RPAD (l_unformatted_blocks, 15));
   END LOOP;
END;
/
undefine sqlid;