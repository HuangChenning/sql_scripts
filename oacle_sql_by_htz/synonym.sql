set echo off
set lines 300
set pages 40 heading on
col owner_name for a40 heading 'SYNONYM|OWNER_NAME'
col owner_t for a40  heading 'TABLE|OWNER_NAME'
col db_link for a40
col create_time for a8
undefine synonym_name
select a.owner || '.' || a.synonym_name owner_name,
       to_char(CREATED, 'yy-mm-dd') create_time,
       a.table_owner || '.' || a.table_name owner_t,
       a.db_link
  from dba_synonyms a, dba_objects b
 where synonym_name = nvl('&synonym_name', synonym_name)
   and a.synonym_name = b.object_name
   and a.owner = b.owner;

undefine synonym_name