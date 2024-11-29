set  echo off
set long 100000000
set pages 50000
select * from table(dbms_xplan.display_cursor('&sqlid',nvl('&childnum',NULL),nvl('&format',null)));
undefine sqlid;
undefine childnum;
undefine format;
