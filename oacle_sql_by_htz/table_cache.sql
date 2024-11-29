set echo off
store set sqlplusset replace
set lines 170
set verify off
set serveroutput on
set feedback off
set pages 20000
col owner for a15
col table_name for a20
col buffer_pool for a20
col table_owner for a15
break on table_owner

ACCEPT owner prompt 'Enter Search Owner(default(all)) (i.e. scott) : ' default ''
ACCEPT tablename prompt 'Enter Search Table Name default(all)  (i.e. emp) : '  default ''


break on owner


select a.owner, a.table_name, a.BUFFER_POOL
  from dba_tables a
 where a.owner = nvl(upper('&owner'), a.owner)
   and a.table_name = nvl(upper('&tablename'), a.table_name)
   and a.owner not in ('SYSTEM', 'SYS', 'DBSNMP', 'XDB')
   and a.buffer_pool <> 'DEFAULT'
union all
select b.table_owner owner, b.table_name, b.BUFFER_POOL
 from dba_tab_partitions b
 where b.table_owner = nvl(upper('&owner'), b.table_owner)
  and b.table_name = nvl(upper('&tablename'), b.table_name)
  and b.table_owner not in ('SYSTEM', 'SYS', 'DBSNMP', 'XDB')
  and b.buffer_pool <> 'DEFAULT'
/
@sqlplusset