set echo off
set line 200
set pages 40
set heading on
col owner_table for a35 heading 'OWNER|TABLE_NAME'
col num_rows for 99999999999 heading 'NUM_ROWS'
col block for a15 heading 'USER_BLOCK|EMPTY_BLOCK'
col chain_cnt for 999999 heading 'CHAIN_CNT'
col sample_size for a6 heading 'SAMPLE|SIZE'
col last_analyzed for a15 heading 'LAST_ANALYZED'
col statle_stats for a6 heading 'STATE|STATS'
/* Formatted on 2013/12/5 22:54:13 (QP5 v5.240.12305.39476) */
undefine 1
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
SELECT owner || '.' || table_name owner_table,
       num_rows,
       blocks || '.' || a.empty_blocks block,
       chain_cnt,
          TRUNC (
               sample_size
             / DECODE (num_rows,  '0', '1',  NULL, '1',  num_rows)
             * 100,
             2)
       || '%'
          sample_size,
       TO_CHAR (last_analyzed, 'yyyy-mm-dd hh24') last_analyzed,
       stale_stats
  FROM dba_tab_statistics a
 WHERE (OWNER, TABLE_NAME) IN
          (SELECT owner, table_name
             FROM dba_tables
            WHERE (owner, table_name) IN (SELECT * FROM t)
           UNION ALL
           SELECT * FROM t)
/
set lines 80
undefine 1;
set echo on;

