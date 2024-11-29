set echo off
set lines 2000 pages 500 verify off heading on
col inst_id for 99 heading 'II'
col owner for a15
col object_name for a100
col hash_value for 9999999999999
col object_type for a14
col sql_id for a15
col hot for a3 heading 'HOT'
select inst_id,
       kglnaown  owner,
       kglnaobj  object_name,
       kglnahsh  hash_value,
       kglobtyd  object_type,
       kglobt03  sql_id,
       kglobprop hot
  from x$kglob
 where kglobprop = 'HOT'
   and kglhdadr = kglhdpar
   ;