set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
col owner_name for a40 heading 'REFERENCED|OWNER_NAME'
col referenced_type for a20
col referenced_link_name for a20
col dependency_type for a15 heading 'DEPENDENCY|TYPE'
 SELECT  a.referenced_owner||'.'||
         a.referenced_name owner_name,
         a.referenced_type,
         b.last_ddl_time,
         B.STATUS,
         a.referenced_link_name,
         a.dependency_type
    FROM DBA_DEPENDENCIES a, dba_objects b
   WHERE     a.referenced_owner = b.owner
         AND A.REFERENCED_NAME = B.OBJECT_NAME
         AND A.REFERENCED_TYPE = B.OBJECT_TYPE
         AND a.owner = nvl(UPPER ('&owner'),a.owner)
         AND a.name = nvl(UPPER ('&object_name'),a.name)
ORDER BY referenced_type;
clear    breaks  
set echo on
