set echo off;
set lines 200 heading on verify off;
col db_unique_name for a20
col parent_dbun for 20
col dest_role for a20
col current_scn for 999999999999999
select DB_UNIQUE_NAME,PARENT_DBUN,DEST_ROLE,CURRENT_SCN from v$dataguard_config;