set echo off
set serveroutput on
set feedback on
set lines 170
set pages 10

ACCEPT sql_id prompt 'Enter Search Object Name (i.e. a6wbhyug5tand) : '
ACCEPT plan prompt 'Enter Heap 0(all info) or Heap 6(only plan) (i.e 1 or 6) : '

COL address  NEW_V address;
COL hash_value NEW_V hashvalue;
set termout off
select address from v$sqlarea where sql_id='&sql_id'
/
select hash_value from v$sqlarea where sql_id='&sql_id'
/
alter session set events '5614566 trace name context forever';
exec dbms_shared_pool.purge ('&address,&hashvalue','C',&plan);
set termout on
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

undefine sql_id;
undefine plan;