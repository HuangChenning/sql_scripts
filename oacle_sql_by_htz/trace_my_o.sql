--oradebug setmypid
--oradebug event 10046 trace name context forever,level 12;
--oradebug tracefile_name;
--prompt 'oradebug event 10046 trace name context off'
SET TERM ON ECHO OFF heading off  verify OFF autotrace OFF pages 0
PRO
PRO Parameter 1:
PRO event id (default 10046)
PRO
DEF event_id = nvl('&1','10046');
PRO
PRO Parameter 2:
PRO level_id (default 12 for 10046)
PRO
DEF level = nvl('&2','12');
PRO

select value from v$diag_info where name='Default Trace File';

set heading on pages 1000
alter session set events '10046 trace name context forever,level 12';

