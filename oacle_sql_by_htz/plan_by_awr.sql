set long 5000
set verify off
set echo off
set lines 175
ACCEPT sqlid prompt 'Enter sql_id  : '
select * from table(dbms_xplan.display_awr('&sqlid',null,null,'ADVANCED +PEEKED_BINDS'))
/

