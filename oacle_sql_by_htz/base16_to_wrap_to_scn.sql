set echo off
set heading on
set lines 200
set verify off
col scn for 99999999999999999
select to_number('&scn_wrap','xxxxxxxxxxxxxxxxxx')*4294967296+to_number('&scn_base','xxxxxxxxxxxxxxx') scn
  from dual;
undefine scn_wrap;
undefine scn_base
