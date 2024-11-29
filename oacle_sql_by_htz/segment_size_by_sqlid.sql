set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40
col segment_name for a20 heading 'OBJECT_NAME'
col segment_size for 99999999999999 heading 'SEGMENT_SIZE(KB)'
col block_count for 99999999999 heading 'BLOCK_COUNT'
/* Formatted on 2013/12/24 18:52:26 (QP5 v5.240.12305.39446) */
/* Formatted on 2013/12/24 19:14:26 (QP5 v5.240.12305.39446) */
WITH t
     AS (SELECT /*+ materialize */
               DISTINCT OBJECT_OWNER, OBJECT_NAME
           FROM (SELECT OBJECT_OWNER, OBJECT_NAME
                   FROM V$SQL_PLAN
                  WHERE SQL_ID = '&&1' AND OBJECT_NAME IS NOT NULL
                 UNION ALL
                 SELECT OBJECT_OWNER, OBJECT_NAME
                   FROM DBA_HIST_SQL_PLAN
                  WHERE SQL_ID = '&&1' AND OBJECT_NAME IS NOT NULL))
SELECT a.owner,
       a.segment_name,
       a.segment_size,
       TRUNC (a.segment_size / 8) block_count
  FROM (  SELECT owner, segment_name, TRUNC (SUM (bytes) / 1024) segment_size
            FROM dba_segments
           WHERE     segment_type LIKE 'TABLE%'
                 AND (OWNER, segment_name) IN
                        (SELECT table_owner, table_name
                           FROM dba_indexes
                          WHERE (owner, index_name) IN (SELECT * FROM t)
                         UNION ALL
                         SELECT * FROM t)
        GROUP BY ROLLUP (owner, segment_name)) a
/
clear    breaks  
undefine 1;
