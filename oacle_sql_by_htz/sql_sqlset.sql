set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40
col id for 99 heading 'ID'
col name for a30
col owner for a15
col description for a50

SELECT a.id,
       a.owner,
       a.name,
       a.description,
       to_char(a.created,'yy-mm-dd') created,
       to_char(a.last_modified,'yy-mm-dd hh24:mi') last_modified,
       a.statement_count sql_count
  FROM dba_sqlset a
order by a.id

/
clear    breaks  

