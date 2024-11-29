-- Author:      认真就输
-- Copyright:   www.htz.pw
-- 1 制定2要收集的信息的名字
-- 2 指定次数
-- 3 过滤变换值大于多少的显示

set echo off lines 2000 pages 1000 verify off heading on
alter session set "_optimizer_cartesian_enabled"=false;
alter session set "_optimizer_mjc_enabled"=false;
DEF _lhp_name="&1"
DEF _lhp_samples="&2"
DEF _lhp_where='&3'

col rid for 99999999 heading 'ORDER_NUMBER'
col inst_id for 99 heading 'I'
col name for a40 heading 'NAME'
col avg_s for 999999.99 heading 'AVG|VALUE_CHANG(S)'

WITH t1 AS (SELECT hsecs FROM v$timer),
     samples
     AS (SELECT /*+ ORDERED USE_NL(l) use_nl(b) cardinality(b 100) NO_TRANSFORM_DISTINCT_AGG */ rid,
                inst_id,
                name,
                VALUE,
                LAG (VALUE) OVER (PARTITION BY inst_id, name ORDER BY rid)
                   value_last
           FROM (    SELECT /*+ NO_MERGE */
                           ROWNUM rid
                       FROM DUAL b
                 CONNECT BY LEVEL <= &_lhp_samples) s,
                (SELECT inst_id, name, VALUE
                   FROM gv$sysstat l
                  WHERE (LOWER (l.name) LIKE LOWER ('%&_lhp_name%')))),
     t2 AS (SELECT hsecs FROM v$timer)
  SELECT /*+ ORDERED */
        rid,
         inst_id,
         name,
--         VALUE,
--        (VALUE - value_last) c_value,
           ( (VALUE - value_last) / (&_lhp_samples / (t2.hsecs - t1.hsecs)))
         * 100
            avg_s
    FROM t1, samples s, t2
   WHERE   ( (VALUE - value_last) / (&_lhp_samples / (t2.hsecs - t1.hsecs)))
         * 100 >= &_lhp_where
ORDER BY rid, inst_id, name;

undef _lhp_name;
undef _lhp_samples;
undef _lhp_where;