set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
break on table_owner,table_name,owner
col table_owner for a15  heading 'TABLE OWNER'
col table_name for a35  heading 'TABLE NAME'
col owner for a15 heading 'INDEX OWNER'
col index_name for a35 heading 'INDEX NAME'
col index_type for a15 heading 'INDEX TYPE'
col IN_CACHEED_PLAN for a10  heading 'USED |NO/YES'
ACCEPT owner prompt 'Enter Search Index Owner (i.e. SCOTT|ALL(default)) : ' default ''
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|ALL(default)) : ' default ''

/* Formatted on 2013/3/21 14:26:31 (QP5 v5.240.12305.39476) */
  SELECT c.table_owner,
         c.table_name,
         c.owner,
         c.index_name,
         c.index_type,
         CASE WHEN b.object_name IS NULL THEN 'NO' ELSE 'YES' END
            IN_CACHEED_PLAN
    FROM dba_indexes c,
         (SELECT DISTINCT a.object_owner, a.object_name
            FROM v$sql_plan a
           WHERE     object_type = 'INDEX'
                 AND a.object_owner NOT IN ('SYS', 'OUTLN', 'SYSTEM')
                 AND a.object_owner = NVL (UPPER ('&owner'), a.object_owner)
          UNION
          SELECT DISTINCT a.object_owner, a.object_name
            FROM dba_hist_sql_plan a
           WHERE     object_type = 'INDEX'
                 AND a.object_owner NOT IN ('SYS', 'OUTLN', 'SYSTEM')
                 AND a.object_owner = NVL (UPPER ('&owner'), a.object_owner)) b
   WHERE     c.index_name = b.object_name(+)
         AND c.owner NOT IN
                ('SYS',
                 'OUTLN',
                 'SYSTEM',
                 'DBSNMP',
                 'WMSYS',
                 'EXFSYS',
                 'CTXSYS',
                 'XDB',
                 'OLAPSYS',
                 'ORDSYS',
                 'MDSYS',
                 'SYSMAN')
         AND c.owner = NVL (UPPER ('&owner'), c.owner)
         AND c.table_name = NVL (UPPER ('&name'), c.table_name)
ORDER BY IN_CACHEED_PLAN,table_owner,table_name
/
clear    breaks  

