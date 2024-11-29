set echo off
set pages 50
set lines 170
COL OWNER FORMAT a15
COL USERNAME FORMAT A15 HEADING "CREATE|USER"
COL DB_LINK FORMAT A30  heading "DBLINK|NAME"
COL HOST FORMAT A40 HEADING "SERVICE"
col c_time for a20 heading "DBLINK|CREATE TIME"
SELECT a.owner,
       a.username,
       a.db_link,
       b.status,
       a.HOST,
       TO_CHAR (a.created, 'yyyy-mm-dd hh24:mi:ss') c_time
  FROM DBA_DB_LINKS a, dba_objects b
 WHERE a.db_link = b.object_name
/