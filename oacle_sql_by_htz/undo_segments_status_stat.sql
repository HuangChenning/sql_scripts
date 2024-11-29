/*#此脚本用于查询UNDO中每一个段下面区的状态的统计信息，及UNDO中区的状态的统计信息
#输出结果如下
#SEGMENT_NAME    ACTSIZE(M) ACT%            UNEXPSIZE(M) UNEXP%          EXPSIZE(M) EXP%
#--------------- ---------- --------------- ------------ --------------- ---------- -----
#_SYSSMU5$               27 .82%                       2 .06%                  4.13 .12%
#_SYSSMU3$                0 0%                         1 .05%                 21.13 .95%
#_SYSSMU10$               0 0%                         3 .05%                    60 .95%
#_SYSSMU2$                0 0%                      2.13 .19%                     9 .81%
#_SYSSMU6$                0 0%                         2 .22%                  7.13 .78%
#_SYSSMU1$                0 0%                     49.13 .82%                    11 .18%
#_SYSSMU4$                0 0%                         0 0%                    8.13 1%
#_SYSSMU8$                0 0%                         1 .11%                  8.13 .89%
#_SYSSMU9$                0 0%                         1 .09%                 10.13 .91%
#_SYSSMU7$                0 0%                      2.13 .06%                    35 .94%
#
#10 rows selected.
#
#
#CURTIME  Status             size(M) TOTAL_EXTENT
#-------- --------------- ---------- ------------
#20:55:41 UNEXPIRED               63           84
#20:55:41 EXPIRED                173          178
#20:55:41 ACTIVE                  27           27   */

set lines 200 pages 40
set echo off
col segment_name for a15
col status for a15
select segment_name,
       round(nvl(sum(act), 0) / 1024 / 1024, 2) "ACTSIZE(M)",
       round(nvl(sum(act), 0) /
             decode((nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0)),
                    0,
                    1,
                    (nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0))),
             2) || '%' "ACT%",
       round(nvl(sum(unexp), 0) / 1024 / 1024, 2) "UNEXPSIZE(M)",
       round(nvl(sum(unexp), 0) /
             decode((nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0)),
                    0,
                    1,
                    (nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0))),
             2) || '%' "UNEXP%",
       round(nvl(sum(exp), 0) / 1024 / 1024, 2) "EXPSIZE(M)",
       round(nvl(sum(exp), 0) /
             decode((nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0)),
                    0,
                    1,
                    (nvl(sum(act), 0) + nvl(sum(unexp), 0) +
                    nvl(sum(exp), 0))),
             2) || '%' "EXP%"
  from (select segment_name, nvl(sum(bytes), 0) act, 00 unexp, 00 exp
          from DBA_UNDO_EXTENTS
         where status = 'ACTIVE'
           and tablespace_name =
               (select VALUE from v$parameter where name = 'undo_tablespace')
         group by segment_name
        union
        select segment_name, 00 act, nvl(sum(bytes), 0) unexp, 00 exp
          from DBA_UNDO_EXTENTS
         where status = 'UNEXPIRED'
           and tablespace_name =
               (select VALUE from v$parameter where name = 'undo_tablespace')
         group by segment_name
        union
        select segment_name, 00 act, 00 unexp, nvl(sum(bytes), 0) exp
          from DBA_UNDO_EXTENTS
         where status = 'EXPIRED'
           and tablespace_name =
               (select VALUE from v$parameter where name = 'undo_tablespace')
         group by segment_name)
 group by segment_name;



select to_char(sysdate, 'hh24:mi:ss') as curtime,
       status,
       TRUNC(SUM(BYTES) / 1024 / 1024) "size(M)",
       count(*) total_extent
  from dba_undo_extents
 where tablespace_name =
       (select VALUE from v$parameter where name = 'undo_tablespace') group by status
       
/
       