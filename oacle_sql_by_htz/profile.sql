set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col profile for a20
col resource_name for a40
col resource_type for a15
col limit for a20

select distinct profile from dba_profiles;

ACCEPT profile prompt 'Enter Search Profile Name (i.e. DEPT) : '

SELECT *
    FROM dba_profiles
   WHERE profile = NVL (UPPER ('&profile'), profile)
ORDER BY profile, resource_type
/
clear    breaks  
@sqlplusset

