set long 5000
set verify off
set echo off
set lines 175
undefine sqlid;

select t.*
  from v$sql s,
       table(dbms_xplan.display_cursor(s.sql_id, s.child_number,'outline')) t
 where s.sql_id = '&sqlid';
undefine sqlid;