set echo off
set lines 200
set pages 0
set feedback off;
ACCEPT owner prompt 'Enter Search Owner (i.e. scott) : '
ACCEPT tablename prompt 'Enter Search Table Name (i.e. dept) : '
select '*****************************************************************************' from dual;

select 'alter session set workarea_size_policy=MANUAL;' from dual
union all
select 'alter session set db_file_multiblock_read_count=512;' from dual
union all
select 'alter session set "_sort_multiblock_read_count"=128;' from dual
union all
select 'alter session enable parallel ddl;' from dual
union all
select 'alter session set sort_area_size=2040109466;' from dual
union all
select 'alter session set sort_area_size=2040109466;' from dual; 
select 'alter table ' || owner || '.' || table_name ||
       ' move nologging parallel 10;'
  from dba_tables
 where owner = upper('&&owner')
   and table_name = upper('&&tablename')
union all
select 'alter index ' || owner || '.' || index_name ||
       ' rebuild nologging parallel 10;'
  from dba_indexes
 where table_owner = upper('&&owner')
   and table_name = upper('&&tablename')
/
undefine owner;
undefine tablename;
set feedback on
set pages 40
set echo on