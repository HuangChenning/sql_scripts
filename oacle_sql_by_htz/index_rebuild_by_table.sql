set echo off
set verify off
set pages 0
set lines 200

SELECT 'ALTER INDEX ' || I.owner || '.' || I.index_name || ' REBUILD ' || ';'
  from DBA_INDEXES I, DBA_TABLES T
 WHERE I.table_name = T.table_name
   AND I.owner = T.owner
   AND T.owner = UPPER('&owner')
   and t.table_name = upper('&table_name');
   
set verify on
set pages 40
set heading on
set echo on
 