--------------------------------------------------------------------------------
--
-- File name:   sql9.sql
-- Author:      zhangqiao
-- Copyright:   zhangqiaoc@olm.com.cn
--
--------------------------------------------------------------------------------

alter session set nls_date_format='yyyymmdd';

col file_name new_value file_name noprint
select to_char(sysdate,'yyyymmddhh24miss')||'_'||'&&1' file_name from dual;
spool sql_&file_name

set pagesize 0
SET VERIFY OFF
set linesize 130

-------------------------------------------------------------------------------------------------
col CPU_TIME                heading "CPU|TIME"           for 999,999,999
col ELAPSED_TIME            heading "ELAPSED|TIME"       for 999,999,999
col PARSE_CALLS             heading "PARSE|CALLS"        for 999,999
col DISK_READS              heading "DISK|READS"         for 999,999,999
col BUFFER_GETS             heading "BUFFER|GETS"        for 999,999,999 
col SORTS                   heading "SORTS"              for 999,999
col ROWS_PROCESSED          heading "ROWS|PROCESSED"     for 999,999,999  
col FETCHES                 heading "FETCHES"            for 999,999,999
col EXECUTIONS              heading "EXEC"               for 999,999,999
col CPU_PRE_EXEC            heading "CPU|PRE EXEC"       for 999,999,999
col DISK_PRE_EXEC           heading "DISK|PRE EXEC"      for 999,999,999
col ELA_PRE_EXEC	    heading "ELA|PRE EXEC"	 for 999,999,999
col GET_PRE_EXEC            heading "GET|PRE EXEC"       for 999,999,999
col ROWS_PRE_EXEC           heading "ROWS|PRE EXEC"      for 999,999,999
col ROWS_PRE_FETCHES         heading "ROWS|PRE FETCHES"  for 999,999,999
-------------------------------------------------------------------------------------------------                           
col TABLE_NAME              heading "TABLE|NAME"         for a15
col OWNER                   heading "OWNER"              for a5
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
-------------------------------------------------------------------------------------------------                           
col TABLE_OWNER             heading "TABLE|OWNER"        for a10
col INDEX_NAME              heading "Index|Name"         for a15
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

prompt ****************************************************************************************
prompt CURSOR
prompt ****************************************************************************************
set serveroutput on size 1000000
@display_cursor_9i.sql &1 0
@display_cursor_9i.sql &1 1
@display_cursor_9i.sql &1 2

prompt
prompt ****************************************************************************************
prompt SQL STATS
prompt ****************************************************************************************
set pagesize 9999

SELECT DISTINCT (SELECT USERNAME FROM DBA_USERS WHERE USER_ID = PARSING_USER_ID) PARSING_SCHEMA_NAME,MODULE FROM V$SQL WHERE hash_value = '&1';
 
select CPU_TIME,ELAPSED_TIME,DISK_READS, BUFFER_GETS, ROWS_PROCESSED,FETCHES, PARSE_CALLS, SORTS,EXECUTIONS from v$sqlarea where hash_value='&1';

select
CPU_TIME/decode(EXECUTIONS,0,1,EXECUTIONS) CPU_PRE_EXEC,
ELAPSED_TIME/decode(EXECUTIONS,0,1,EXECUTIONS) ELA_PRE_EXEC,
DISK_READS/decode(EXECUTIONS,0,1,EXECUTIONS) DISK_PRE_EXEC,
BUFFER_GETS/decode(EXECUTIONS,0,1,EXECUTIONS) GET_PRE_EXEC,
ROWS_PROCESSED/decode(EXECUTIONS,0,1,EXECUTIONS) ROWS_PRE_EXEC,
ROWS_PROCESSED/decode(FETCHES,0,1,FETCHES) ROWS_PRE_FETCHES,EXECUTIONS 
from v$sqlarea where hash_value='&1';

prompt
prompt ****************************************************************************************
prompt TABLES
prompt ****************************************************************************************
break on owner
WITH t AS 
(SELECT /*+ materialize */
DISTINCT OBJECT_OWNER, OBJECT_NAME
  FROM (SELECT OBJECT_OWNER, OBJECT_NAME
	  FROM V$SQL_PLAN
	 WHERE hash_value = '&1'
	   AND OBJECT_NAME IS NOT NULL))
SELECT owner,
       TABLE_NAME,
       TABLESPACE_NAME,
       LOGGING,
       BUFFER_POOL,
       ltrim(DEGREE) DEGREE,
       PARTITIONED,
       NUM_ROWS,
       BLOCKS,
       EMPTY_BLOCKS,
       AVG_SPACE,
       AVG_ROW_LEN,  
       LAST_ANALYZED
  FROM DBA_TABLES
 WHERE (OWNER, TABLE_NAME) IN
       (SELECT table_owner,table_name FROM dba_indexes 
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t);

prompt
prompt ****************************************************************************************
prompt INDEX INFO
prompt ****************************************************************************************
break on table_owner on table_name on index_name on index_type on uniqueness on LOGGING on status
WITH t AS 
(SELECT /*+ materialize */
DISTINCT OBJECT_OWNER, OBJECT_NAME
  FROM (SELECT OBJECT_OWNER, OBJECT_NAME
	  FROM V$SQL_PLAN
	 WHERE hash_value = '&1'
	   AND OBJECT_NAME IS NOT NULL))   
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
   AND A.INDEX_NAME = B.INDEX_NAME;

prompt
prompt ****************************************************************************************
prompt SQL WAIT HIST
prompt ****************************************************************************************
break on program
SELECT PROGRAM,EVENT, SUM(CNT) TOTAL, WAIT_CLASS
  FROM (SELECT DECODE(SESSION_STATE,
		      'ON CPU',
		      DECODE(SESSION_TYPE, 'BACKGROUND', 'BCPU', 'CPU'),
		      EVENT) EVENT,
	       REPLACE(TRANSLATE(DECODE(SESSION_STATE,
					'ON CPU',
					DECODE(SESSION_TYPE,
					       'BACKGROUND',
					       'BCPU',
					       'CPU'),
					WAIT_CLASS),
				 ' $',
				 '____'),
		       '/') WAIT_CLASS,
	       PROGRAM,
	       1 CNT
	  FROM V$ACTIVE_SESSION_HISTORY
	 WHERE SQL_ID = '&&1'
	   AND SAMPLE_TIME >= SYSDATE - 4 / 24
	   AND SAMPLE_TIME <= SYSDATE)
 GROUP BY EVENT, WAIT_CLASS, PROGRAM
 ORDER BY PROGRAM,TOTAL DESC;
 
prompt
prompt ****************************************************************************************
prompt TABLE COLUMNS
prompt ****************************************************************************************
break on owner on table_name
WITH t AS 
(SELECT /*+ materialize */
DISTINCT OBJECT_OWNER, OBJECT_NAME
  FROM (SELECT OBJECT_OWNER, OBJECT_NAME
	  FROM V$SQL_PLAN
	 WHERE hash_value = '&1'
	   AND OBJECT_NAME IS NOT NULL))
SELECT OWNER,
       TABLE_NAME,
       COLUMN_NAME,
       DATA_TYPE,
       NULLABLE,
       DENSITY,
       NUM_NULLS,
       NUM_BUCKETS,
       AVG_COL_LEN,
       LAST_ANALYZED
  FROM DBA_TAB_COLS
 WHERE (OWNER, TABLE_NAME) IN
       (SELECT table_owner,table_name FROM dba_indexes 
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t)
 ORDER BY owner,table_name,COLUMN_ID;

prompt
prompt ****************************************************************************************
prompt INDEX STATS
prompt ****************************************************************************************
WITH t AS 
(SELECT /*+ materialize */
DISTINCT OBJECT_OWNER, OBJECT_NAME
  FROM (SELECT OBJECT_OWNER, OBJECT_NAME
	  FROM V$SQL_PLAN
	 WHERE hash_value = '&1'
	   AND OBJECT_NAME IS NOT NULL))
SELECT INDEX_NAME,
       INDEX_TYPE,
       LOGGING,
       STATUS,
       BLEVEL BLEV,
       LEAF_BLOCKS,
       DISTINCT_KEYS,
       NUM_ROWS,
       AVG_LEAF_BLOCKS_PER_KEY,
       AVG_DATA_BLOCKS_PER_KEY,
       CLUSTERING_FACTOR,
       LAST_ANALYZED
  FROM DBA_INDEXES T
 WHERE (TABLE_OWNER, TABLE_NAME) IN
       (SELECT table_owner,table_name FROM dba_indexes 
         WHERE (owner,index_name) IN (SELECT * FROM t)
        UNION ALL SELECT * FROM t)
 ORDER BY 1 
/

spool off

undefine 1




