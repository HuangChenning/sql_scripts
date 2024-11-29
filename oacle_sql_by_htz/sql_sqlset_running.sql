set echo off
set lines 200
set pages 40
set heading on
col sqlset_name for a40
col sqlset_owner for a15
col sqlset_id for 999
col id for 999
col owner for a15
col description for a50
SELECT a.sqlset_name,
       a.sqlset_owner,
       a.sqlset_id,
       a.id,
       a.owner,
       TO_CHAR (a.created, 'yyyy-mm-dd hh24:mi:ss') created,
       a.DESCRIPTION
  FROM DBA_SQLSET_REFERENCES a;
set echo on