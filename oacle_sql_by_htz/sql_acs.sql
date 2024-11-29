set echo off
set lines 300 pages 4000 verify off heading on
undefine sqlid;
col sql_id for a15
col acs                     heading 'SENSITIVE|AWARE|SHARE'            FOR a15 
COL F_L_TIME                heading 'FIRST_LOAD_TIME|LAST_LOAD_TIME'   FOR a22
col USERNAME                heading "USER|NAME"          for a10
col CHILD_NUMBER            heading 'CHI'                for 999
col PEEKED for a6
select a.sql_id,a.PARSING_SCHEMA_NAME username,
       a.CHILD_NUMBER,
       a.BUFFER_GETS,
       a.plan_hash_value,
       substr(FIRST_LOAD_TIME,6,10)||'.'||substr(LAST_LOAD_TIME,6,10) f_l_time,
       is_bind_sensitive || '.' || is_bind_aware || '.' || is_shareable acs
  from v$sql a
 where a.sql_id = nvl('&&sqlid', a.sql_id)
 order by username;
 
PROMPT 'FROM V$SQL_CS_SELECTIVITY'
select a.sql_id, a.CHILD_NUMBER, a.PREDICATE, a.RANGE_ID, a.LOW, a.HIGH
  from v$sql_cs_selectivity a
 where a.sql_id = nvl('&&sqlid', a.sql_id)
order by a.child_number, a.range_id;

PROMPT 'FROM V$SQL_CS_STATISTICS'
select a.sql_id,
       a.CHILD_NUMBER,
       a.PEEKED,
       a.EXECUTIONS,
       a.ROWS_PROCESSED,
       a.BUFFER_GETS,
       a.CPU_TIME
  from v$sql_cs_statistics a
 where a.sql_id = nvl('&&sqlid', a.sql_id)
 order by a.child_number;

undefine sqlid;