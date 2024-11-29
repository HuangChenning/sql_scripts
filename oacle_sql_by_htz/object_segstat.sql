set echo off
set lines 300
set pages 40
set heading on
set verify off
col o_o             for a60 heading 'OWNER|OBJECT_NAME.SUBOBJECT_NAME'
col tablespace_name for a20
col statistic_name  for a30 
col value           for 999999999999999
col used            for 999999 heading 'TOTAL %USED'
col name for a40 heading 'STATISTICS_NAME'
break on o_o;
select name from v$segstat_name;

select a.owner || '.' || a.object_name || '.' || subobject_name o_o,
       b.name tablespace_name,
       c.STATISTIC_NAME statistic_name,
       c.value,
       round(decode(d.total_value, 0, null, c.value / d.total_value) * 100,
             4) used
  from dba_objects a,
       v$tablespace b,
       (select *
          from (select obj#, ts#, STATISTIC_NAME, sum(value) value
                  from gv$segstat
                 where upper(STATISTIC_NAME) = upper('&name')
                 group by obj#, ts#, STATISTIC_NAME
                 order by value desc)
         where rownum < nvl('&top',10)) c,
       (select statistic_name, sum(value) total_value
          from gv$segstat
         group by statistic_name) d
 where c.ts# = b.ts#
   and c.obj# = a.object_id
   and d.statistic_name = c.statistic_name
 order by c.value;
clear breaks;
