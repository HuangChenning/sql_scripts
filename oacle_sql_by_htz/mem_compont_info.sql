set echo off
set heading on
set lines 200
set pages 40
select name,
       total,
       round(total - free, 2) used,
       round(free, 2) free,
       round((total - free) / total * 100, 2) pctused
  from (select 'SGA' name,
               (select sum(value / 1024 / 1024) from v$sga) total,
               (select sum(bytes / 1024 / 1024)
                  from v$sgastat
                 where name = 'free memory') free
          from dual)
union
select name,
       total,
       round(used, 2) used,
       round(total - used, 2) free,
       round(used / total * 100, 2) pctused
  from (select 'PGA' name,
               (select value / 1024 / 1024 total
                  from v$pgastat
                 where name = 'aggregate PGA target parameter') total,
               (select value / 1024 / 1024 used
                  from v$pgastat
                 where name = 'total PGA allocated') used
          from dual)
union
select name,
       round(total, 2) total,
       round((total - free), 2) used,
       round(free, 2) free,
       round((total - free) / total * 100, 2) pctused
  from (select 'Shared pool' name,
               (select sum(bytes / 1024 / 1024)
                  from v$sgastat
                 where pool = 'shared pool') total,
               (select bytes / 1024 / 1024
                  from v$sgastat
                 where name = 'free memory'
                   and pool = 'shared pool') free
          from dual)
union
select name,
       round(total, 2) total,
       round(total - free, 2) used,
       round(free, 2) free,
       round((total - free) / total, 2) pctused
  from (select 'Default pool' name,
               (select a.cnum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 total
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) total,
               (select a.anum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 free
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) free
          from dual)
union
select name,
       nvl(round(total, 2), 0) total,
       nvl(round(total - free, 2), 0) used,
       nvl(round(free, 2), 0) free,
       nvl(round((total - free) / total, 2), 0) pctused
  from (select 'KEEP pool' name,
               (select a.cnum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 total
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'KEEP'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) total,
               (select a.anum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 free
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'KEEP'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) free
          from dual)
union
select name,
       nvl(round(total, 2), 0) total,
       nvl(round(total - free, 2), 0) used,
       nvl(round(free, 2), 0) free,
       nvl(round((total - free) / total, 2), 0) pctused
  from (select 'RECYCLE pool' name,
               (select a.cnum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 total
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'RECYCLE'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) total,
               (select a.anum_repl *
                       (select value
                          from v$parameter
                         where name = 'db_block_size') / 1024 / 1024 free
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'RECYCLE'
                   and p.block_size =
                       (select value
                          from v$parameter
                         where name = 'db_block_size')) free
          from dual)
union
select name,
       nvl(round(total, 2), 0) total,
       nvl(round(total - free, 2), 0) used,
       nvl(round(free, 2), 0) free,
       nvl(round((total - free) / total, 2), 0) pctused
  from (select 'DEFAULT 16K buffer cache' name,
               (select a.cnum_repl * 16 / 1024 total
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size = 16384) total,
               (select a.anum_repl * 16 / 1024 free
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size = 16384) free
          from dual)
union
select name,
       nvl(round(total, 2), 0) total,
       nvl(round(total - free, 2), 0) used,
       nvl(round(free, 2), 0) free,
       nvl(round((total - free) / total, 2), 0) pctused
  from (select 'DEFAULT 32K buffer cache' name,
               (select a.cnum_repl * 32 / 1024 total
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size = 32768) total,
               (select a.anum_repl * 32 / 1024 free
                  from x$kcbwds a, v$buffer_pool p
                 where a.set_id = p.LO_SETID
                   and p.name = 'DEFAULT'
                   and p.block_size = 32768) free
          from dual)
union
select name,
       total,
       total - free used,
       free,
       (total - free) / total * 100 pctused
  from (select 'Java Pool' name,
               (select sum(bytes / 1024 / 1024) total
                  from v$sgastat
                 where pool = 'java pool'
                 group by pool) total,
               (select bytes / 1024 / 1024 free
                  from v$sgastat
                 where pool = 'java pool'
                   and name = 'free memory') free
          from dual)
union
select name,
       Round(total, 2),
       round(total - free, 2) used,
       round(free, 2) free,
       round((total - free) / total * 100, 2) pctused
  from (select 'Large Pool' name,
               (select sum(bytes / 1024 / 1024) total
                  from v$sgastat
                 where pool = 'large pool'
                 group by pool) total,
               (select bytes / 1024 / 1024 free
                  from v$sgastat
                 where pool = 'large pool'
                   and name = 'free memory') free
          from dual)
 order by pctused desc;
set lines 80
set echo on;