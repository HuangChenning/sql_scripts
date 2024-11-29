set echo off
set lines 300 pages 100 verify off serveroutput on heading on
select *
  from (select *
          from (select *
                  from (select u.name owner,
                               o.name table_name,
                               null partition_name,
                               null subpartition_name,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO') truncated,
                               m.drop_segments
                          from sys.mon_mods_all$ m,
                               sys.obj$          o,
                               sys.tab$          t,
                               sys.user$         u
                         where o.obj# = m.obj#
                           and o.obj# = t.obj#
                           and o.owner# = u.user#
                        union all
                        select u.name,
                               o.name,
                               o.subname,
                               null,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO'),
                               m.drop_segments
                          from sys.mon_mods_all$ m, sys.obj$ o, sys.user$ u
                         where o.owner# = u.user#
                           and o.obj# = m.obj#
                           and o.type# = 19
                        union all
                        select u.name,
                               o.name,
                               o2.subname,
                               o.subname,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO'),
                               m.drop_segments
                          from sys.mon_mods_all$ m,
                               sys.obj$          o,
                               sys.tabsubpart$   tsp,
                               sys.obj$          o2,
                               sys.user$         u
                         where o.obj# = m.obj#
                           and o.owner# = u.user#
                           and o.obj# = tsp.obj#
                           and o2.obj# = tsp.pobj#)
                 where owner not like '%SYS%'
                   and owner not like 'XDB'
                union all
                select *
                  from (select u.name owner,
                               o.name table_name,
                               null partition_name,
                               null subpartition_name,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO') truncated,
                               m.drop_segments
                          from sys.mon_mods$ m,
                               sys.obj$      o,
                               sys.tab$      t,
                               sys.user$     u
                         where o.obj# = m.obj#
                           and o.obj# = t.obj#
                           and o.owner# = u.user#
                        union all
                        select u.name,
                               o.name,
                               o.subname,
                               null,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO'),
                               m.drop_segments
                          from sys.mon_mods$ m, sys.obj$ o, sys.user$ u
                         where o.owner# = u.user#
                           and o.obj# = m.obj#
                           and o.type# = 19
                        union all
                        select u.name,
                               o.name,
                               o2.subname,
                               o.subname,
                               m.inserts,
                               m.updates,
                               m.deletes,
                               m.timestamp,
                               decode(bitand(m.flags, 1), 1, 'YES', 'NO'),
                               m.drop_segments
                          from sys.mon_mods$   m,
                               sys.obj$        o,
                               sys.tabsubpart$ tsp,
                               sys.obj$        o2,
                               sys.user$       u
                         where o.obj# = m.obj#
                           and o.owner# = u.user#
                           and o.obj# = tsp.obj#
                           and o2.obj# = tsp.pobj#)
                 where owner not like '%SYS%'
                   and owner not like '%XDB%')
         order by inserts desc)
 where rownum <= 50;

