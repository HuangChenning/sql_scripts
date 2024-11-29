-- File Name : trace.sql
-- Purpose : 用户开启和关闭回话的event
-- 支持 10g,11g,12c
-- Date : 2017/12/07
-- 认真就输、QQ:7343696
-- http://www.htz.pw

set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
PRO
PRO Parameter 1:
PRO sid id (default mysid)
PRO
DEF sid_id=nvl('&1',USERENV('SID'))
PRO
PRO Parameter 2:
PRO event id (default 10046)
PRO
DEF event_id = nvl('&2','10046');
PRO
PRO Parameter 3:
PRO level_id (default 12 for 10046)
PRO
DEF level_id = nvl('&3','12');

declare
 i_serial    number;
 i_tracefile varchar2(1000);
 sid         number;
 event_id    number;
 level_id    number;
begin
  select serial# into i_serial from v$session where sid=&&sid_id;
  select &&level_id into level_id from dual;
  select &&event_id into event_id from dual;
  select &&sid_id into sid from dual;
  select value into i_tracefile from v$diag_info where name='Default Trace File';
  dbms_output.put_line(i_tracefile);
  sys.dbms_system.set_ev(sid,i_serial,event_id,level_id, '');
end;
/




