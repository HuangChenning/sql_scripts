-- REM  rowid_ranges should be at least 21
-- REM  utilize this script help delete large table
-- REM  if update large table  Why not online redefinition or CTAS
-- This script spits desired number of rowid ranges to be used for any parallel operations.
-- Best to use it for copying a huge table with out of row lob columns in it or CTAS/copy the data over db links.
-- This can also be used to simulate parallel insert/update/delete operations.
-- Maximum number of rowid ranges you can get here is 255.
-- Doesn't work for partitioned tables, but with minor changes it can be adopted easily.

-- Doesn't display any output if the total table blocks are less than rowid ranges times 128.

-- It can split a table into more ranges than the number of extents
-- From Saibabu Devabhaktuni  http://sai-oracle.blogspot.com/2006/03/how-to-split-table-into-rowid-ranges.html



set verify off
undefine rowid_ranges
undefine segment_name
undefine owner
set head off
set pages 0
set trimspool on

-- select 'where rowid between ''' ||sys.dbms_rowid.rowid_create(1, d.oid, c.fid1, c.bid1, 0) ||''' and ''' ||sys.dbms_rowid.rowid_create(1, d.oid, c.fid2, c.bid2, 9999) || '''' ||';'
--   from (select distinct b.rn,
--                         first_value(a.fid) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) fid1,
--                         last_value(a.fid) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) fid2,
--                         first_value(decode(sign(range2 - range1),
--                                            1,
--                                            a.bid +
--                                            ((b.rn - a.range1) * a.chunks1),
--                                            a.bid)) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) bid1,
--                         last_value(decode(sign(range2 - range1),
--                                           1,
--                                           a.bid +
--                                           ((b.rn - a.range1 + 1) * a.chunks1) - 1,
--                                           (a.bid + a.blocks - 1))) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) bid2
--           from (select fid,
--                        bid,
--                        blocks,
--                        chunks1,
--                        trunc((sum2 - blocks + 1 - 0.1) / chunks1) range1,
--                        trunc((sum2 - 0.1) / chunks1) range2
--                   from (select /*+ rule */
--                          relative_fno fid,
--                          block_id bid,
--                          blocks,
--                          sum(blocks) over() sum1,
--                          trunc((sum(blocks) over()) / &&rowid_ranges) chunks1,
--                          sum(blocks) over(order by relative_fno, block_id) sum2
--                           from dba_extents
--                          where segment_name = upper('&&segment_name')
--                            and owner = upper('&&owner'))
--                  where sum1 > &&rowid_ranges) a,
--                (select rownum - 1 rn
--                   from dual
--                 connect by level <= &&rowid_ranges) b
--          where b.rn between a.range1 and a.range2) c,
--        (select max(data_object_id) oid
--           from dba_objects
--          where object_name = upper('&&segment_name')
--            and owner = upper('&&owner')
--            and data_object_id is not null) d
-- /




select c.partition_name,'where rowid between ''' ||sys.dbms_rowid.rowid_create(1, d.oid, c.fid1, c.bid1, 0) ||''' and ''' ||sys.dbms_rowid.rowid_create(1, d.oid, c.fid2, c.bid2, 9999) || '''' ||';'
  from (
        select distinct partition_name,b.rn,
                        first_value(a.fid) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) fid1,
                        last_value(a.fid) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) fid2,
                        first_value(decode(sign(range2 - range1),
                                           1,
                                           a.bid +
                                           ((b.rn - a.range1) * a.chunks1),
                                           a.bid)) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) bid1,
                        last_value(decode(sign(range2 - range1),
                                          1,
                                          a.bid +
                                          ((b.rn - a.range1 + 1) * a.chunks1) - 1,
                                          (a.bid + a.blocks - 1))) over(partition by b.rn order by a.fid, a.bid rows between unbounded preceding and unbounded following) bid2
          from (
                select partition_name,
                       fid,
                       bid,
                       blocks,
                       chunks1,
                       trunc((sum2 - blocks + 1 - 0.1) / chunks1) range1,
                       trunc((sum2 - 0.1) / chunks1) range2
                  from (
                        select /*+ rule */
                            partition_name,
                            relative_fno fid,
                            block_id bid,
                            blocks,
                            sum(blocks) over(partition  by partition_name) sum1,
                            trunc((sum(blocks) over(partition  by partition_name)) / &&rowid_ranges) chunks1,
                            sum(blocks) over(partition  by partition_name order by relative_fno, block_id) sum2
                         from dba_extents
                         where segment_name = upper('&&segment_name')
                           and owner = upper('&&owner')
                        )
                 where sum1 > &&rowid_ranges
                ) a,
               (select rownum - 1 rn
                  from dual
                connect by level <= &&rowid_ranges) b
         where b.rn between a.range1 and a.range2
         ) c,
         (
          SELECT subobject_name oname,
                 data_object_id oid
          FROM dba_objects
          WHERE object_name = upper('&&segment_name')
            AND OWNER = upper('&&owner')
            AND data_object_id IS NOT NULL
        ) d
        where c.partition_name=d.oname
/





