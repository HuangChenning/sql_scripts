set echo off
set heading on
set lines 200
set verify off
select to_char(&&scn_number - trunc(&&scn_number / 4294967296) * 4294967296,
               'xxxxxxxxxxxxxx') scn_base,
       to_char(trunc(&&scn_number / 4294967296), 'xxxxxxxxxxxxxxxx') scn_wrap
  from dual;
undefine scn_number;