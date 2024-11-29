set echo off
alter session set nls_date_format='yyyymmdd';

set pagesize 50000
set heading on
SET VERIFY OFF
set linesize 200
-------------------------------------------------------------------------------------------------
col CPU_TIME                heading "CPU|TIME"           for 999,999,999,999
col ELAPSED_TIME            heading "ELAPSED|TIME"       for 999,999,999,999
col PARSE_CALLS             heading "PARSE|CALLS"        for 999,999,999,999
col DISK_READS              heading "DISK|READS"         for 999,999,999,999
col BUFFER_GETS             heading "BUFFER|GETS"        for 999,999,999,999
col SORTS                   heading "SORTS"              for 999,999,999,999
col ROWS_PROCESSED          heading "ROWS|PROCESSED"     for 999,999,999,999  
col FETCHES                 heading "FETCHES"            for 999,999,999,999
col EXECUTIONS              heading "EXEC"               for 999,999,999
col CPU_PRE_EXEC            heading "CPU|PRE EXEC"       for 999,999,999
col ELA_PRE_EXEC            heading "ELA|PRE EXEC"       for 999,999,999
col DISK_PRE_EXEC           heading "DISK|PRE EXEC"      for 999,999,999
col GET_PRE_EXEC            heading "GET|PRE EXEC"       for 999,999,999
col ROWS_PRE_EXEC           heading "ROWS|PRE EXEC"      for 999,999,999
col ROWS_PRE_FETCHES        heading "ROWS|PRE FETCHES"   for 999,999,999
col c                       heading "CHILD|NUMBER"       for 999999
col USERNAME                heading "USER|NAME"          for a10
col PLAN_HASH_VALUE         heading "PLAN|HASH VALUE"    for 999999999999
col APP_WAIT_PRE						heading "APPLICATION|PER EXEC"	for 999,999,999
col CON_WAIT_PER						heading "CONCURRENCY|PER EXEC"	for 999,999,999
col CLU_WAIT_PER						heading "CLUSTER|PER EXEC"		FOR 999,999,999
col USER_ID_WAIT_PER 				heading "USER_ID|PER EXEC"		FOR 999,999
COL PLSQL_WAIT_PER					heading "PLSQL|PER EXEC"			FOR 999,999
COL JAVA_WAIT_PER						heading "JAVA|PER EXEC"				FOR 999,999
-------------------------------------------------------------------------------------------------                           
col TABLE_NAME              heading "TABLE|NAME"         for a35
col SEGMENT_NAME            heading "SEGMENT|NAME"       for a35
col OWNER                   heading "OWNER"              for a15
col TABLESPACE_NAME         heading "TABLESPACE|NAME"    for a10
col LOGGING                 heading "LOG"                for a3 
col BUFFER_POOL             heading "BUFFER|POOL"        for a7
col DEGREE                  heading "DEGREE"             for a6
col PARTITIONED             heading "PART"               for a4 
col NUM_ROWS                heading "NUM|ROWS"           for 999,999,999
col BLOCKS                  heading "BLOCKS"             for 999,999,999 
col EMPTY_BLOCKS            heading "EMPTY|BLOCKS"       for 999,999,999 
col AVG_SPACE               heading "AVG|SPACE"          for 999,999,999 
col AVG_ROW_LEN             heading "AVG|ROW_LEN"        for 999,999,999 
col AVG_ROW_LEN             heading "AVG|ROW_LEN"        for 999,999,999 
col LAST_ANALYZED           heading "LAST|ANALYZED"      
col STALE_STATS							heading "OLD|STATS"					 FOR A5
-------------------------------------------------------------------------------------------------                           
col TABLE_OWNER             heading "TABLE|OWNER"        for a15
col INDEX_NAME              heading "Index|Name"         for a30
col UNIQUENESS              heading "UNIQUE"             for a9
col COLUMN_NAME             heading "COLUMN|NAME"        for a15
col COLUMN_POSITION         heading "COL|POS"            for 999
col DESCEND                 heading "DESC"               for a4 
-------------------------------------------------------------------------------------------------                            
col CHILD_NUMBER            heading "CHILD|NUMBER"       for 999
col name                    heading "BIND|NAME"          for a10        
col value_string            heading "VALUE|STRING"       for a60
col DATATYPE_STRING         heading "DATATYPE|STRING"    for a20
-------------------------------------------------------------------------------------------------                            
col program                 heading "PROGRAM"            for a30
col event                   heading "EVENT"              for a40
col total                   heading "TOTAL"              for 999,999
col wait_class              heading "WAIT|CLASS"         for a15
-------------------------------------------------------------------------------------------------                            
col DATA_TYPE               heading "DATA|TYPE"          for a15        
col NULLABLE                heading "NL"                 for a2         
col HISTOGRAM               heading "HIST"               for a5         
col DENSITY                 heading "DENSITY"            for 999,999,999
col NUM_NULLS               heading "NUM|NULLS"          for 999,999,999
col NUM_BUCKETS             heading "NUM|BUCKETS"        for 999,999,999
col AVG_COL_LEN             heading "AVG|COL LEN"        for 999,999,999
-------------------------------------------------------------------------------------------------                                                     
col LOGGING                 heading "LOG"                for a3   
col STATUS                  heading "STATUS"             for a6
col INDEX_TYPE              heading "INDEX|TYPE"         for a8
col UNIQUENESS              heading "Unique"             for a9
col BLEV                    heading "B|Tree|Level"       for 99
col LEAF_BLOCKS             heading "Leaf|Blks"          for 999,999
col DISTINCT_KEYS           heading "Distinct|Keys"      for 999,999,999
col AVG_LEAF_BLOCKS_PER_KEY heading "Average|Leaf Blocks|Per Key" for 99,999
col AVG_DATA_BLOCKS_PER_KEY heading "Average|Data Blocks|Per Key" for 99,999
col CLUSTERING_FACTOR       heading "Cluster|Factor"     for 999,999,999
col COLUMN_POSITION         heading "Col|Pos"            for 999
col degree                  heading "D"                  for a1

prompt
prompt ****************************************************************************************
prompt PLAN 
prompt ****************************************************************************************
select * from table(dbms_xplan.display);

prompt
prompt ****************************************************************************************
prompt OBJECT SIZE
prompt ****************************************************************************************
break on owner on segment_name
WITH t
     AS (SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )
  SELECT owner,
         segment_name,
         segment_type,
         SUM (bytes / 1024 / 1024) "Size(Mb)"
    FROM dba_segments a
   WHERE (a.owner, a.segment_name) IN (SELECT object_owner, object_name FROM t)
GROUP BY owner, segment_type, segment_name
UNION
  ----table in the index
  SELECT owner,
         '*' || segment_name,
         segment_type,
         SUM (bytes / 1024 / 1024) "Size(Mb)"
    FROM dba_segments
   WHERE     owner IN
                (SELECT table_owner
                   FROM dba_indexes
                  WHERE (owner, index_name) IN
                           (SELECT object_owner, object_name FROM t))
         AND segment_name IN
                (SELECT /*+ no_unnest */
                       table_name
                   FROM dba_indexes
                  WHERE (owner, index_name) IN
                           (SELECT object_owner, object_name FROM t))
GROUP BY owner, segment_type, segment_name
ORDER BY 1,2,3, 4;


prompt
prompt ****************************************************************************************
prompt TABLES
prompt ****************************************************************************************
break on owner
/* Formatted on 2015/5/6 22:38:10 (QP5 v5.240.12305.39446) */
WITH t
     AS (SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )
  SELECT a.owner,
         a.TABLE_NAME,
         -- TABLESPACE_NAME,
         a.LOGGING,
         a.BUFFER_POOL,
         LTRIM (a.DEGREE) DEGREE,
         a.PARTITIONED,
         a.NUM_ROWS,
         a.BLOCKS,
         a.EMPTY_BLOCKS,
         a.AVG_SPACE,
         a.AVG_ROW_LEN,
         STALE_STATS,
         a.LAST_ANALYZED
    FROM DBA_TABLES a, dba_tab_statistics b
   WHERE     (a.OWNER, a.TABLE_NAME) IN
                (SELECT table_owner, table_name
                   FROM dba_indexes
                  WHERE (owner, index_name) IN (SELECT * FROM t)
                 UNION ALL
                 SELECT * FROM t)
         AND a.owner = b.owner(+)
         AND a.table_name = b.table_name(+)
ORDER BY owner, table_name;
clear breaks; 

prompt
prompt ****************************************************************************************
prompt TABLE COLUMNS
prompt ****************************************************************************************
break on owner on table_name

col column_id for 999 heading 'Col|Id'
col d_type for a15 heading 'Column|Date Type'
col num_distinct for 9999999 heading 'NUM|DISTINCT'
col num_buckets for 9999 heading 'BUCK'
WITH t AS 
(SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )
SELECT OWNER,
       TABLE_NAME,
       COLUMN_NAME,
       data_type || '(' || data_length || ')' d_type,
       NULLABLE,     
       DENSITY,
       NUM_NULLS,
       num_distinct,
       NUM_BUCKETS,
       AVG_COL_LEN,
       sample_size,
       substr(HISTOGRAM,0,5) HISTOGRAM,
       LAST_ANALYZED
  FROM DBA_TAB_COLS tb
 WHERE (OWNER, TABLE_NAME) IN
       (SELECT table_owner,table_name FROM dba_indexes
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t)
 ORDER BY owner,table_name,COLUMN_ID;
clear breaks; 
prompt
prompt ****************************************************************************************
prompt INDEX INFO
prompt ****************************************************************************************
break on table_owner on table_name on index_name on index_type on uniqueness on LOGGING on status
WITH t AS 
(SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )        
SELECT A.TABLE_OWNER,
       A.TABLE_NAME,
       A.INDEX_NAME,
       UNIQUENESS,
       COLUMN_NAME,
       COLUMN_POSITION,
       DESCEND
  FROM DBA_INDEXES A, DBA_IND_COLUMNS B
 WHERE (A.OWNER, A.table_name) IN
       (SELECT table_owner,table_name FROM dba_indexes 
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t)
   AND A.OWNER = B.INDEX_OWNER
   AND A.INDEX_NAME = B.INDEX_NAME
   order by table_owner,table_name,index_name,COLUMN_POSITION;
clear breaks; 
prompt
prompt ****************************************************************************************
prompt INDEX STATS
prompt ****************************************************************************************
BREAK ON OWNER on table_name

WITH t AS 
(SELECT /*+ materialize */ distinct object_owner,object_name from plan_table ) 
SELECT OWNER,table_name,
       INDEX_NAME,
       LOGGING,
       STATUS,
       BLEVEL BLEV,
       LEAF_BLOCKS,
       DISTINCT_KEYS,
       NUM_ROWS,
       AVG_LEAF_BLOCKS_PER_KEY,
       AVG_DATA_BLOCKS_PER_KEY,
       CLUSTERING_FACTOR,
       trim(degree) degree,
       LAST_ANALYZED
  FROM DBA_INDEXES T
 WHERE (TABLE_OWNER, TABLE_NAME) IN
       (SELECT table_owner,table_name FROM dba_indexes 
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t)
 ORDER BY 1 
/
clear breaks; 
prompt
prompt ****************************************************************************************
prompt PARTITION TABLE
prompt ****************************************************************************************
col DENSITY                 heading "DENSITY"             for 999,999,999
col owner 									heading 'TABLE|OWNER' 			  for a15 
col name 										heading 'TABLE|NAME'					for a20 
col COLUMN_NAME 						heading 'PARTITION|COLUMN NAME'	for a15  
col COLUMN_POSITION  			  heading 'COLUMN|POSITION'			for 99
col partition_name 					heading 'PARTITION|NAME'			for a20
col HIGH_VALUE 							heading 'HIGH_VALUE'					for  a15
col HIGH_VALUE_LENGTH 			heading 'HIGH_VALUE|LENGTH'		for 99
col tablespace_name 				heading 'TABLESPACE|NAME'			for a15 
col num_rows 								heading 'NUM_ROWS'						for 9999999
col blocks 									heading 'BLOCKS'							for 9999999
col EMPTY_BLOCKS for 999 heading 'EMPTY|BLOCKS'
col l_time for a19 heading 'LAST TIME|ANALYZED'
COL AVG_SPACE FOR 999999
col SUBPARTITION_COUNT for 99 heading 'SUBPARTITION|COUNT'
col compression for a11
col t_size for a10 heading 'PARTITION|SIZE_KB'
col partitioning_type for a10 heading 'PARTITION|TYPE'
col subpartitioning_type for a10 heading 'SUBPART|TYPE'
col partition_count for 99 heading 'PART|COUNT'
col def_subpartition_count for 99 heading 'SUBPART|COUNT'
col partitioning_key_count for 99 heading 'PARTITION|KEY COUNT'
WITH t AS
(SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )
SELECT a.owner,
       a.name,
       b.partitioning_type,
       b.subpartitioning_type,
       b.partition_count,
       b.def_subpartition_count,
       b.partitioning_key_count,
       a.COLUMN_NAME,
       a.COLUMN_POSITION
  FROM sys.DBA_PART_KEY_COLUMNS a, sys.dba_part_tables b
 WHERE a.name = b.table_name
   AND (a.owner, a.name) in (SELECT table_owner, table_name
                               FROM dba_indexes
                              WHERE (owner, index_name) IN (SELECT * FROM t)
                             UNION ALL
                             SELECT * FROM t)
   AND a.owner = b.owner
 ORDER BY a.NAME, a.COLUMN_POSITION
/

prompt
prompt ****************************************************************************************
prompt display every partition  info 
prompt ****************************************************************************************
break on table_name
WITH t AS
(SELECT /*+ materialize */ distinct object_owner,object_name from plan_table )
SELECT table_name ,PARTITION_NAME,
       HIGH_VALUE,
       HIGH_VALUE_LENGTH,
       TABLESPACE_NAME,
       NUM_ROWS,
       BLOCKS,
       round(blocks * 8 / 1024, 2) || 'KB' t_size,
       EMPTY_BLOCKS,
       to_char(LAST_ANALYZED, 'yyyy-mm-dd') l_time,
       AVG_SPACE,
       SUBPARTITION_COUNT,
       COMPRESSION
  FROM sys.DBA_TAB_PARTITIONS
 WHERE (table_owner, table_name) in
       (SELECT table_owner, table_name
          FROM dba_indexes
         WHERE (owner, index_name) IN (SELECT * FROM t)
        UNION ALL
        SELECT * FROM t)
 ORDER BY table_name,PARTITION_POSITION
/
clear breaks
