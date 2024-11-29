set echo off
set lines 2000 pages 100000 heading on verify off serveroutput on
exec print_table('select * from v$session where sid=''&sid''');