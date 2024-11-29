set verify off
set lines 200
set pages 1000
col owner for a12
col table_name for a25
col tablespace_name for a15 heading 'Tablespace|Name'
col partitioned for a4 heading 'Part'
col temporary for a4 heading 'Temp'
col num_rows for 99999999999999
col avg_row_len for 999 heading 'Avg|Row|Len'
col l_time for a19 heading 'last |analyzed'
col pct_free for 9999 heading 'Pct|Free'
col pct_used for 9999 heading 'Pct|Used'
col t_size for a15 heading 'Table|SIZE KB'
col degree for a6 heading 'DEGREE'
break on owner on table_name
WITH t AS 
(SELECT /*+ materialize */DISTINCT OBJECT_OWNER, OBJECT_NAME
          FROM (SELECT OBJECT_OWNER, OBJECT_NAME
                  FROM V$SQL_PLAN
                 WHERE SQL_ID = '&&sqlid'
                   AND OBJECT_NAME IS NOT NULL
                UNION ALL
                SELECT OBJECT_OWNER, OBJECT_NAME
                  FROM DBA_HIST_SQL_PLAN
                 WHERE SQL_ID = '&&sqlid'
                   AND OBJECT_NAME IS NOT NULL))
SELECT t.owner,t.table_name,
       t.tablespace_name,
       t.partitioned,
       t.ini_trans,
       t.max_trans,
       t.temporary,
       t.num_rows,
       t.avg_row_len,
       ltrim(t.degree) degree,
       TRUNC((t.blocks * p.VALUE) / 1024) || 'KB' t_size,
       TO_CHAR(t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time,
       t.pct_free
  FROM sys.dba_tables t, sys.v$parameter p
 WHERE (t.OWNER, t.TABLE_NAME) IN
       (SELECT table_owner, table_name
          FROM dba_indexes
         WHERE (owner, index_name) IN (SELECT * FROM t)
        UNION ALL
        SELECT * FROM t)
   AND p.name = 'db_block_size'
 order by owner, table_name;
clear breaks;
undefine sqlid;
