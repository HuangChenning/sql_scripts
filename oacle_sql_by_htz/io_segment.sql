store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set lines 200
set pages 100
col owner for a15
col object_name for a30
col subobject_name for a20
col tablespace_name for a20
col obj# for 99999999
col object_type for a15
col statistic_name for a24
col value for 999999999999999
select * from v$segstat_name;

ACCEPT owner prompt 'Enter Search Owner(i.e. SCOTT(DEFAULT ALL)) : ' default ''
ACCEPT t_name prompt 'Enter Search Tablespace Name(i.e. USERS(DEFAULT ALL)) : ' default ''
ACCEPT s_name prompt 'Enter Search Statistics Name(i.e. logical reads(DEFAULT ALL)) : ' default ''

select *
  from (select owner,
               object_name,
               subobject_name,
               tablespace_name,
               obj#,
               object_type,
               statistic_name,
               value
          from v$segment_statistics
         where statistic_name = 'logical reads'
           and owner = nvl('&owner', owner)
           and tablespace_name = nvl('&t_name', tablespace_name)
         order by value desc)
 where rownum < 20;
clear    breaks  
@sqlplusset