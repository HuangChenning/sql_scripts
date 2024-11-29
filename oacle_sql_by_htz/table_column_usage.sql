set echo off
set lines 300 pages 100 heading on verify off serveroutput on
col col# for 999 heading 'ID'
col column_name for a20 
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
undefine owner;
undefine table_name;
exec dbms_stats.FLUSH_DATABASE_MONITORING_INFO;
select c.col#,
       c.name column_name,
       equality_preds as "=_NUMS", ---等值过滤
       equijoin_preds as "JOIN_=_NUMS", ---等值JOIN过滤 比如where a.id=b.id
       nonequijoin_preds as "<>_JOIN_NUM", ----不等JOIN过滤
       range_preds as "RANGE_NUMS",----范围过滤 > >= < <= between and
       like_preds as "LIKE_NUMS",----LIKE过滤
       null_preds as "NULL_NUMS",----NULL 过滤
       timestamp
  from sys.col_usage$ u, sys.obj$ o, sys.col$ c, sys.user$ r
 where o.obj# = u.obj#
   and c.obj# = u.obj#
   and c.col# = u.intcol#
   and r.name = nvl(upper('&owner'),r.name)
   and o.name = nvl(upper('&table_name'),o.name);
undefine owner;
undefine table_name;