set echo off
set lines 270
set heading on
set pages 30
col profile for a20
col resource_name for a40
col resource_type for a15
col limit for a20

break on profile on resource_type
SELECT profile,resource_type,resource_name,limit
    FROM dba_profiles
   WHERE profile in (select profile from dba_users where username=nvl(upper('&username'),username)) 
ORDER BY profile, resource_type
/
clear    breaks  

