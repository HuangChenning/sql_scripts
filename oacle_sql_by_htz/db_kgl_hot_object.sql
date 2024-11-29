set echo off;
set lines 2000 pages 4000 verify off heading on serveroutput on;
col cursor for a10;
col name for a100;
col hash_value for 999999999999;
col type for a15;
col locked for 999999999999999 heading 'LOCKED_TOTAL';
col pined for 999999999999999 heading 'PINED_TOTAL';

select *
  from (select case
                 when (kglhdadr = kglhdpar) then
                  'Parent'
                 else
                  ' Child ' || kglobt09
               end cursor,
               kglhdadr ADDRESS,
               kglnaobj name,
               kglnahsh hash_value,
               kglobtyd type,
               kglobt23 LOCKED,
               kglobt24 PINNED
          from x$kglob
         order by &ORDER_LOCKED_or_PINNED desc)
 where rownum < 100
/