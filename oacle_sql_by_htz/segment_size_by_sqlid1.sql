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
WITH t AS
 (SELECT /*+ materialize */
  DISTINCT OBJECT_OWNER, OBJECT_NAME
    FROM (SELECT OBJECT_OWNER, OBJECT_NAME
            FROM V$SQL_PLAN
           WHERE SQL_ID = '&&1'
             AND OBJECT_NAME IS NOT NULL
          UNION ALL
          SELECT OBJECT_OWNER, OBJECT_NAME
            FROM DBA_HIST_SQL_PLAN
           WHERE SQL_ID = '&&1'
             AND OBJECT_NAME IS NOT NULL))
select a.owner,
       a.segment_name,
       a.segment_size,
       trunc(a.segment_size / 8) block_count
  from (SELECT owner, segment_name, trunc(sum(bytes) / 1024) segment_size
          FROM dba_segments
         WHERE (owner, segment_name) IN
               (SELECT owner, segment_name
                  FROM dba_segments
                 WHERE (owner, segment_name) IN (SELECT * FROM t)
                UNION ALL
                SELECT * FROM t)
         group by rollup(owner, segment_name)) a
/
clear    breaks  
undefine 1;
