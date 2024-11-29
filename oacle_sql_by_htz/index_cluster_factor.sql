set lines 200
set verify off
set echo off
col owner for a10
col tablename for a25
col ANALYZED for a20
col indexname for a30
col columnname for a20
col bytes for a10
col tablespacename for a15
col temp for a4
col tablespace_name for a20
col index_type for a15
set feedback off
set serveroutput on
set pages 9999
accept table_name prompt 'ENTER YOU TABLE_NAME: ' 
variable i_table_name varchar2(30);
exec :i_table_name :=upper('&table_name');

PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | TABLE INFORMATION********************************************              |
PROMPT +----------------------------------------------------------------------------+

/* Formatted on 2012/12/23 23:07:37 (QP5 v5.215.12089.38647) */
SELECT a.Owner Owner,
       a.Table_Name Tablename,
       a.tablespace_name,
       TO_CHAR (a.Last_Analyzed, 'YYYY-MM-DD HH24:Mi:ss') Analyzed,
       a.ini_trans,
       a.Partitioned Partition,
       a.temporary temp,
       Bytes || 'M' bytes,
       a.pct_free,
       a.pct_used,
       a.num_rows,
       a.blocks - a.empty_blocks block_used
  FROM Dba_Tables a,
       (  SELECT b.Segment_Name Segment_Name, SUM (b.Bytes / 1024 / 1024) Bytes
            FROM Dba_Segments b
           WHERE b.Segment_Name = :i_table_name
        GROUP BY Segment_Name) c
 WHERE a.Table_Name = c.Segment_Name;
 
PROMPT                                                                               
PROMPT +----------------------------------------------------------------------------+
PROMPT | TABLE INDEX INFORMATION********************************************              |
PROMPT +----------------------------------------------------------------------------+
 
/* Formatted on 2012/12/23 23:07:46 (QP5 v5.215.12089.38647) */
  SELECT b.Index_Owner Owner,
         a.table_name Tablename,
         a.Tablespace_Name Tablespacename,
         b.Index_Name Indexname,
         a.status,
         a.index_type,
         CLUSTERING_FACTOR,
         a.num_rows,
         b.Column_Name Columnname,
         b.Column_Position Columnpost
    FROM Dba_Indexes a, Dba_Ind_Columns b
   WHERE a.Table_Name = :i_Table_Name AND b.Index_Name = a.Index_Name
ORDER BY Indexname
/


PROMPT +---------------------------------------------------------------------------------|
PROMPT |The clustering factor of an index defines how ordered the rows are in the table. |
PROMPT |It affects the number of I/Os required for the whole operation.                  |
PROMPT |If the DBA_INDEXES.CLUSTERING_FACTOR of the index approaches                     |
PROMPT |the number of blocks in the table, then most of the rows                         |
PROMPT |in the table are ordered. This is desirable.                                     |
PROMPT |However, if the clustering factor approaches the number of rows in the table,    |
PROMPT |it means the rows in the table are randomly ordered.                             |    
PROMPT +---------------------------------------------------------------------------------|