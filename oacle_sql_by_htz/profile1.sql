set echo off
set feedback off
set linesize 512

prompt
prompt All Profiles in Database
prompt

SELECT DISTINCT PROFILE
	FROM DBA_PROFILES;