set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
with tt as
 (select /*+ materialize*/
   tablespace_name,
   trunc(sum(bytes) / 1024 / 1024 / 32767) t_size,
   round(mod(sum(bytes) / 1024 / 1024, 32767)) m_size
    from dba_data_files
   where tablespace_name not in ('SYSTEM', 'SYSAUX', 'TEMP')
   group by tablespace_name)
select 'create tablespace ' || tablespace_name || ' datafile ' || chr(39) ||
       '+data' || chr(39) || ' size ' ||
       decode(t_size, '0', m_size, '32767') || 'M;' as getddl
  from tt
 where tt.tablespace_name not in ('USERS')
union all
select 'alter tablespace ' || tablespace_name || ' add datafile ' ||
       chr(39) || '+data' || chr(39) || ' size ' || t_size || 'M;' as get_ddl
  from tt
 where t_size > 0
 order by getddl desc
/
spool migrate_get_ddl_tb.sql
 WITH tt
     AS (  SELECT /*+ materialize*/
                 tablespace_name,
                  TRUNC (SUM (bytes) / 1024 / 1024 / 32767) t_size,
                  ROUND (MOD (SUM (bytes) / 1024 / 1024, 32767)) m_size
             FROM dba_data_files
            WHERE tablespace_name NOT IN ('SYSTEM', 'SYSAUX', 'TEMP')
         GROUP BY tablespace_name)
  SELECT    'select '
         || CHR (39)
         || 'alter tablespace '
         || tablespace_name
         || ' add datafile '
         || CHR (39)
         || CHR (39)
         || CHR (39)
         || CHR (124)
         || CHR (124)
         || CHR (39)
         || '+data'
         || CHR (39)
         || CHR (124)
         || CHR (124)
         || CHR (39)
         || CHR (39)
         || CHR (39)
         || ' 32767M;'
         || CHR (39)
         || '   from dual connect by level < '
         || t_size
         || '; '
            AS getddl
    FROM tt
   WHERE t_size > 1
ORDER BY tablespace_name;
spool off
--@migrate_get_ddl_tb.sql