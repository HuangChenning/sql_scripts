set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col name for a29
col owner for a15
col category for a15
col time for a8 heading 'CREATE|TIME'
col sql_text for a70

select distinct category from dba_outlines
/
SELECT name,
       owner,
       category,
       used,
       TO_CHAR (timestamp, 'yy mm-dd') time,
       compatible,
       do.enabled,
       format,
       sql_text
  FROM dba_outlines do
 WHERE     owner = NVL (UPPER ('&owner'), do.owner)
       AND category = NVL (UPPER ('&category'), do.category)
       AND used = NVL (UPPER ('&used'), do.used) 
/
clear    breaks  
@sqlplusset

