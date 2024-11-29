set echo off
set lines 200 verify off heading on pages 50
undefine p1
select distinct chr(bitand(&&p1, -16777216) / 16777215) ||
                chr(bitand(&&p1, 16711680) / 65535) block_type,
                mod(&&p1, 16) lock_mode
  from dual;

undefine p1
