set echo off
set lines 2000 pages 400 verify off heading on
col owner for a15
col name for a100
col hash_value for 999999999999
col type for a15
select kglhdadr ADDRESS,
       kglnaown owner,
       kglnaobj name,
       kglnahsh hash_value,
       kglobtyd type,
       kglobt23 LOCKED_TOTAL,
       kglobt24 PINNED_TOTAL
  from x$kglob
 where kglnahsh = '&hash_value_or_idn' and kglhdadr = kglhdpar
 /