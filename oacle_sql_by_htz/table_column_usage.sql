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
       equality_preds as "=_NUMS", ---��ֵ����
       equijoin_preds as "JOIN_=_NUMS", ---��ֵJOIN���� ����where a.id=b.id
       nonequijoin_preds as "<>_JOIN_NUM", ----����JOIN����
       range_preds as "RANGE_NUMS",----��Χ���� > >= < <= between and
       like_preds as "LIKE_NUMS",----LIKE����
       null_preds as "NULL_NUMS",----NULL ����
       timestamp
  from sys.col_usage$ u, sys.obj$ o, sys.col$ c, sys.user$ r
 where o.obj# = u.obj#
   and c.obj# = u.obj#
   and c.col# = u.intcol#
   and r.name = nvl(upper('&owner'),r.name)
   and o.name = nvl(upper('&table_name'),o.name);
undefine owner;
undefine table_name;