set echo off
set lines 200 pages 1000
col name for a20
col tablespace_name for a30
col size_m for 9999999
col used_size_m for 9999999
col free_size_m for 99999999
col used_percent for 99999999


 select c.name,a.tablespace_name,
       trunc (tablespace_size * b.block_size / 1024 / 1024) size_m,
       trunc (used_space * b.block_size / 1024 / 1024) used_size_m,
       trunc ( (tablespace_size - used_space) * b.block_size / 1024 / 1024)
          free_size_m,
       round(used_percent,2) used_percent
  from cdb_tablespace_usage_metrics a, cdb_tablespaces b,v$containers c
 where a.tablespace_name = b.tablespace_name
       and a.con_id	=b.con_id and b.con_id=c.con_id
 order by 1,used_percent
 /
