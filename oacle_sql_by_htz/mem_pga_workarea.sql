set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

PROMPT +------------------------------------------------------------------------|
PROMPT |（1）Optimal                                                            |
PROMPT |	最优方式，指所有的处理可以在内存中完成                                |
PROMPT |（2）Onepass                                                            |
PROMPT |	大部分的操作可以在内存中完成，但是需要读写一次临时磁盘段                  |
PROMPT |（3）Multipass                                                          |
PROMPT |	大量的操作需要产生磁盘交互，性能极差                                  |
PROMPT +------------------------------------------------------------------------|
PROMPT
select name,
       value,
       100 *
       (value / decode((select sum(value)
                         from v$sysstat
                        where name like '%workarea executions%'),
                       0,
                       null,
                       (select sum(value)
                          from v$sysstat
                         where name like '%workarea executions%'))) pct
  from v$sysstat
 where name like '%workarea executions%'
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on


