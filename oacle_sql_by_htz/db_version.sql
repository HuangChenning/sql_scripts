SET ECHO OFF
SET PAGESIZE 2000  LINESIZE 200 VERIFY OFF HEADING ON
col action format a20  
col namespace format a10  
col version format a10  
col comments format a50  
col action_time format a30 
col bundle_series format a15  
col comp_name for a50
col comp_id for a25
col schema for a15
col patch_id for 9999999999
col version for a10
col action for a10
col status for a10
col banner for a90
col DESCRIPTION for a60
col BUNDLE_SERIES for a10 heading 'BUNDLE'
define _VERSION_12  = "--"
define _VERSION_11  = "--"


col version11  noprint new_value _VERSION_11
col version12  noprint new_value _VERSION_12

select case
         when 
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version11,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version12
  from v$version
 where banner like 'Oracle Database%';
 
alter session set nls_timestamp_format = 'yyyy-mm-dd hh24:mi:ss.ff';  
select * from v$version
/
select comp_id, comp_name, schema,version, status from sys.dba_registry
/

select 
&_VERSION_11  * from dba_registry_history order by 1
&_VERSION_12  substr(ACTION_TIME,1,18) ACTION_TIME ,patch_id,version,action,status,BUNDLE_SERIES,BUNDLE_ID,DESCRIPTION from dba_registry_sqlpatch order by 1
/

