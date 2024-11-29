set echo off
set linesize 200
set pagesize 200
prompt *******************tablespace size**************************
-- select * from (
--SELECT /*+ ALL_ROWS */ to_char(sysdate,'yyyy-mm-dd') as now_date,
--       Total.name "Tablespace Name",
--       round(nvl(Free_space, 0), 1) Free_space,
--       round(nvl(total_space - Free_space, 0), 1) Used_space,
--       round(total_space, 1) total_space,
--       trunc((nvl(total_space - Free_space, 0) / total_space) * 100, 2) used_percent
--  FROM (select tablespace_name,
--               sum(bytes / 1024 / 1024) Free_Space
--         from dba_free_space
--         group by tablespace_name) Free,
--       (select b.name,
--               sum(bytes / 1024 / 1024) TOTAL_SPACE
--          from v$datafile a,
--               v$tablespace b
--         where a.ts# = b.ts#
--        group by b.name) Total
-- WHERE Free.Tablespace_name (+) = Total.name
-- ORDER BY Total.name) order by used_percent desc;*/
--
SELECT /* + RULE */
 df.tablespace_name "Tablespace",
 df.bytes / (1024 * 1024) "Size (MB)",
 SUM(fs.bytes) / (1024 * 1024) "Free (MB)",
 Nvl(Round(SUM(fs.bytes) * 100 / df.bytes), 2) "% Free",
 Round(((df.bytes - SUM(fs.bytes)) * 100 / df.bytes), 2) "% Used"
  FROM dba_free_space fs,
       (SELECT tablespace_name, SUM(bytes) bytes
          FROM dba_data_files
         GROUP BY tablespace_name) df
 WHERE fs.tablespace_name(+) = df.tablespace_name
 GROUP BY df.tablespace_name, df.bytes
UNION ALL
SELECT /* + RULE */
 df.tablespace_name tspace,
 fs.bytes / (1024 * 1024),
 SUM(df.bytes_free) / (1024 * 1024),
 Nvl(Round((SUM(fs.bytes) - df.bytes_used) * 100 / fs.bytes), 2),
 Round(((SUM(fs.bytes) - df.bytes_free) * 100 / fs.bytes), 2)
  FROM dba_temp_files fs,
       (SELECT tablespace_name, bytes_free, bytes_used
          FROM v$temp_space_header
         GROUP BY tablespace_name, bytes_free, bytes_used) df
 WHERE fs.tablespace_name(+) = df.tablespace_name
 GROUP BY df.tablespace_name, fs.bytes, df.bytes_free, df.bytes_used
 ORDER BY 4 DESC;

--SELECT a.tablespace_name,
--       TRUNC (tablespace_size * b.block_size / 1024 / 1024) size_m,
--       TRUNC (used_space * b.block_size / 1024 / 1024) used_size_m,
--       TRUNC ( (TABLESPACE_SIZE - used_space) * b.block_size / 1024 / 1024)
--          free_size_m,
--       USED_PERCENT
--  FROM DBA_TABLESPACE_USAGE_METRICS a, dba_tablespaces b
-- WHERE a.tablespace_name = b.tablespace_name
-- ORDER BY USED_PERCENT
-- /

prompt *******************total tablespace**************************
select 'total',to_char(sysdate,'yyyy-mm-dd') as now_date,(total_space-free_space) used_space,total_space from (
SELECT
       (select round(sum(bytes / 1024 / 1024), 1)
          from dba_free_space) free_space,
       (select /*+ ORDERED */ round(sum(bytes / 1024 / 1024), 1)
          from v$datafile a,
               v$tablespace b
         where a.ts# = b.ts#) total_space
  from dual);
