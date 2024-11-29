set echo off
set lines 200
set heading on
set pages 40
col owner for a15
col table_name for a25
col partition_name for a15  heading 'PART'
col subpartition_name for a15 heading 'SUBPART'
col truncated for a10 heading 'TRUNCATED'
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

PROMPT exec dbms_stats.flush_database_monitoring_info;

SELECT *
  FROM (  SELECT *
            FROM (SELECT *
                    FROM (SELECT u.name owner,
                                 o.name table_name,
                                 NULL partition_name,
                                 NULL subpartition_name,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO')
                                    truncated,
                                 m.drop_segments
                            FROM sys.mon_mods_all$ m,
                                 sys.obj$ o,
                                 sys.tab$ t,
                                 sys.user$ u
                           WHERE     o.obj# = m.obj#
                                 AND o.obj# = t.obj#
                                 AND o.owner# = u.user#
                          UNION ALL
                          SELECT u.name,
                                 o.name,
                                 o.subname,
                                 NULL,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO'),
                                 m.drop_segments
                            FROM sys.mon_mods_all$ m, sys.obj$ o, sys.user$ u
                           WHERE     o.owner# = u.user#
                                 AND o.obj# = m.obj#
                                 AND o.type# = 19
                          UNION ALL
                          SELECT u.name,
                                 o.name,
                                 o2.subname,
                                 o.subname,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO'),
                                 m.drop_segments
                            FROM sys.mon_mods_all$ m,
                                 sys.obj$ o,
                                 sys.tabsubpart$ tsp,
                                 sys.obj$ o2,
                                 sys.user$ u
                           WHERE     o.obj# = m.obj#
                                 AND o.owner# = u.user#
                                 AND o.obj# = tsp.obj#
                                 AND o2.obj# = tsp.pobj#)
                   WHERE owner NOT LIKE '%SYS%' AND owner NOT LIKE 'XDB' 
                   AND owner = NVL (UPPER ('&&owner'), owner)
                         AND table_name =
                                NVL (UPPER ('&&table_name'), table_name)
                  UNION ALL
                  SELECT *
                    FROM (SELECT u.name owner,
                                 o.name table_name,
                                 NULL partition_name,
                                 NULL subpartition_name,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO')
                                    truncated,
                                 m.drop_segments
                            FROM sys.mon_mods$ m,
                                 sys.obj$ o,
                                 sys.tab$ t,
                                 sys.user$ u
                           WHERE     o.obj# = m.obj#
                                 AND o.obj# = t.obj#
                                 AND o.owner# = u.user#
                          UNION ALL
                          SELECT u.name,
                                 o.name,
                                 o.subname,
                                 NULL,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO'),
                                 m.drop_segments
                            FROM sys.mon_mods$ m, sys.obj$ o, sys.user$ u
                           WHERE     o.owner# = u.user#
                                 AND o.obj# = m.obj#
                                 AND o.type# = 19
                          UNION ALL
                          SELECT u.name,
                                 o.name,
                                 o2.subname,
                                 o.subname,
                                 m.inserts,
                                 m.updates,
                                 m.deletes,
                                 m.timestamp,
                                 DECODE (BITAND (m.flags, 1), 1, 'YES', 'NO'),
                                 m.drop_segments
                            FROM sys.mon_mods$ m,
                                 sys.obj$ o,
                                 sys.tabsubpart$ tsp,
                                 sys.obj$ o2,
                                 sys.user$ u
                           WHERE     o.obj# = m.obj#
                                 AND o.owner# = u.user#
                                 AND o.obj# = tsp.obj#
                                 AND o2.obj# = tsp.pobj#)
                   WHERE     owner NOT LIKE '%SYS%'
                         AND owner NOT LIKE '%XDB%'
                         AND owner = NVL (UPPER ('&&owner'), owner)
                         AND table_name =
                                NVL (UPPER ('&&table_name'), table_name))
        ORDER BY inserts DESC)
 WHERE ROWNUM <= 100;
undefine table_name;
undefine owner;
set pages 40
set lines 80
set echo on