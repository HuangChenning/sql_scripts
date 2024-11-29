set echo off
set heading on
set lines 200
set verify off
col scn for 99999999999999999
select &scn_wrap*4294967296+&scn_base scn
  from dual;
undefine scn_wrap;
undefine scn_base
