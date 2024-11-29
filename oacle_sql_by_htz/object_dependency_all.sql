set echo off;
set lines 280 pages 10000 heading on verify off
col lv for 999
col O_N for a45 heading 'OWNER_OBJECT_NAME'
col type for a15 heading 'TYPE'
col R_O_N for a45 heading 'REF_OWNER_OBJECT_NAME'
col referenced_type for a15 heading 'REF_TYPE'
col status for a10
alter session set nls_date_format='mm-dd hh24:mi:ss';
undefine owner;
undefine objectname;
select lv,
       c.owner || '.' || c.name o_n,
       c.type,
       c.referenced_owner || '.' || c.referenced_name r_o_n,
       c.referenced_type,
       d.status,
       d.created,
       d.last_ddl_time
  from (select a.owner,
               a.name,
               a.type,
               a.referenced_owner,
               a.referenced_name,
               a.referenced_type,
               level lv
          from dba_dependencies a
         start with a.owner = upper('&owner')
                and a.name = upper('&objectname')
        connect by NOCYCLE a.owner = prior a.referenced_owner
               and a.name = prior a.referenced_name) c,
       dba_objects d
 where c.owner = d.owner
   and c.name = d.object_name
   and c.type = d.object_type
 order by lv
/
undefine owner;
undefine objectname;